# Run Plan — AGN Variability Context Ablation Experiment

This experiment holds the science task prompt fixed and varies only the context window across 10 trials. Each trial produces a Jupyter notebook; notebooks are scored against a reference implementation for correctness and performance. The goal is to find the minimum sufficient context that produces a correct, performant pipeline in a single shot.

Data flows through four stages: raw collection → resource preparation (concatenation + optional compaction) → context assembly → trial execution.

---

## Directory Structure

```
experiment/
  1_raw_resources/          # Stage 1: exact downloaded originals
    lsdb_guide/             # single file or subdir of shards
    lsdb_rtd/
    eztaox/
    dp2_schema/
    rsp_lsdb_nb/
    lsdb_nbs/
    agn_var_nb/
    hw2/
    caplar/

  2_resources/              # Stage 2: prepared, trial-ready versions
    full/                   # one file per resource, all shards concatenated
      lsdb_guide.txt
      lsdb_rtd.txt
      eztaox.txt
      ...
    summarized/             # Claude-generated summaries, one file per resource
      lsdb_guide.txt        # (probably not needed — already dense)
      lsdb_rtd.txt
      eztaox.txt
      ...

  3_contexts/               # Stage 3: assembled per-trial context files
    T0.txt                  # baseline only (env statement + data paths)
    T1.txt                  # baseline + LSDB_GUIDE
    T2.txt                  # baseline + HW2
    T3.txt                  # baseline + all Tool resources
    T4.txt                  # baseline + all Domain resources
    T5.txt                  # baseline + AGN VAR NB (science example)
    T6.txt                  # baseline + T + D (hypothesized minimum working set)
    T7.txt                  # baseline + T + D + S
    T8.txt                  # baseline + all resources (ceiling)
    TB.txt                  # ceiling + Caplar (bonus)

  4_outputs/                # Stage 4: trial results
    T0_notebook.md
    T0_raw.md
    T1_notebook.md
    T1_raw.md
    ...

  science_task.txt          # fixed prompt — never changes between trials
  baseline.txt              # always-in-context env statement and data paths

  assemble_contexts.sh      # Stage 3: builds 3_contexts/ from 2_resources/
  compact_resources.sh          # Stage 2b: generates 2_resources/summarized/ via Claude
  run_trial.sh              # Stage 4: executes one trial, writes to 4_outputs/
```

---

## Stage 1 — Raw Resource Collection (`1_raw_resources/`)

Collect exact originals: downloaded HTML/text, notebook `.ipynb` files, documentation pages. Store as-is with no modification. 

If a resource spans multiple files (e.g., a multi-page RTD export, a notebook with associated data files), keep them in a named subdirectory. Nothing in Stage 1 is generated or transformed.

---

## Stage 2 — Resource Preparation (`2_resources/`)

Two subdirectories: `full/` and `summarized/`. Both are derived from Stage 1; neither is edited by hand after generation.

### 2a. Concatenation → `full/`

Each resource becomes a single `.txt` file. For multi-shard resources (e.g., a multi-page RTD export), concatenate all shards in order. For notebooks, convert `.ipynb` to plain text or markdown — code cells and markdown cells, no outputs.

```bash
# Example: concatenate a multi-page RTD export
cat 1_raw_resources/lsdb_rtd/*.txt > 2_resources/full/lsdb_rtd.txt

# Example: notebook to text (strip outputs)
jupyter nbconvert --to script 1_raw_resources/agn_var_nb/notebook.ipynb \
  --stdout > 2_resources/full/agn_var_nb.txt
```

All resources in `full/` are then compacted in Stage 2b before use. Nothing in `full/` is referenced directly by `assemble_contexts.sh`.

### 2b. Compaction → `processed/` (`compact_resources.sh`)

For every resource, generate a compacted version that retains only what's load-bearing for the science task. Scope the compaction against HW2: open `2_resources/full/hw2.txt`, list every LSDB function call, EzTaoX call, schema column name, and quality flag, then pass that list to Claude as the retention target.

Running everything through this step ensures context length is not a confound across trials — differences in trial output are attributable to which resources are present, not how large they are.

```bash
#!/bin/bash
# compact_resources.sh
# Compacts all resources in 2_resources/full/ into 2_resources/processed/.
# Run once before assembling contexts. Re-run if source resources change.

TARGET="Extract only the content relevant to this pipeline task: cross-matching \
the Gaia AGN catalog with Rubin DP2 using LSDB, filtering on quality flags, and \
fitting a DRW model with EzTaoX. Retain function signatures, column names, flag \
definitions, and code patterns that appear in or are directly relevant to the \
pipeline. Omit installation instructions, changelogs, contributor guides, and \
anything not directly called or referenced in the pipeline. Document follows:\n\n"

mkdir -p 2_resources/processed

for f in 2_resources/full/*.txt; do
  name=$(basename $f)
  echo "Compacting $name..."
  claude \
    --no-session-persistence \
    -p "${TARGET}$(cat $f)" \
    > 2_resources/processed/$name \
    2> 2_processed/compact_${name%.txt}_raw.md
  echo "  $(wc -c < 2_resources/full/$name) bytes → $(wc -c < 2_resources/processed/$name) bytes"
done

echo "Done."
```

After running, verify the compacted files aren't over-truncated — spot-check that key function names and flag definitions from HW2 are still present in the corresponding processed files.

---


## Stage 3 — Context Assembly (`3_contexts/`, `assemble_contexts.sh`)

One context file per trial. Each file is the complete system prompt for that trial: `baseline.txt` concatenated with the designated resources for that trial. `science_task.txt` is never part of the context file — it's always passed separately as the user prompt.

Context files are checked into version control. They are the independent variable and the audit record.

```bash
#!/bin/bash
# assemble_contexts.sh
# Assembles 3_contexts/T*.txt from baseline.txt and 2_resources/.
# Run this once before any trials, and again if resources are updated.

# --- Resource designations ---
LSDB_GUIDE=2_resources/full/lsdb_guide.txt
LSDB_RTD=2_resources/summarized/lsdb_rtd.txt
EZTAOX=2_resources/full/eztaox.txt
DP2_SCHEMA=2_resources/summarized/dp2_schema.txt
RSP_LSDB_NB=2_resources/full/rsp_lsdb_nb.txt
LSDB_NBS=2_resources/summarized/lsdb_nbs.txt
AGN_VAR_NB=2_resources/full/agn_var_nb.txt
HW2=2_resources/full/hw2.txt
CAPLAR=2_resources/full/caplar.txt

BASE=baseline.txt

# --- Phase 1: Solo probes ---
cat $BASE > 3_contexts/T0.txt

cat $BASE $LSDB_GUIDE > 3_contexts/T1.txt

cat $BASE $HW2 > 3_contexts/T2.txt

# --- Phase 2: Dimension isolation ---
cat $BASE $LSDB_GUIDE $LSDB_RTD $EZTAOX $LSDB_NBS > 3_contexts/T3.txt  # Full Tool

cat $BASE $DP2_SCHEMA $RSP_LSDB_NB > 3_contexts/T4.txt                  # Full Domain

cat $BASE $AGN_VAR_NB > 3_contexts/T5.txt                               # Full Science

# --- Phase 3: Progressive build ---
cat $BASE $LSDB_GUIDE $LSDB_RTD $EZTAOX $LSDB_NBS \
         $DP2_SCHEMA $RSP_LSDB_NB > 3_contexts/T6.txt                   # T + D

cat $BASE $LSDB_GUIDE $LSDB_RTD $EZTAOX $LSDB_NBS \
         $DP2_SCHEMA $RSP_LSDB_NB $AGN_VAR_NB > 3_contexts/T7.txt       # T + D + S

cat $BASE $LSDB_GUIDE $LSDB_RTD $EZTAOX $LSDB_NBS \
         $DP2_SCHEMA $RSP_LSDB_NB $AGN_VAR_NB $HW2 > 3_contexts/T8.txt  # Full ceiling

# --- Bonus ---
cat $BASE $LSDB_GUIDE $LSDB_RTD $EZTAOX $LSDB_NBS \
         $DP2_SCHEMA $RSP_LSDB_NB $AGN_VAR_NB $HW2 $CAPLAR > 3_contexts/TB.txt

echo "Assembled context files:"
wc -l 3_contexts/*.txt
```

After assembly, inspect token counts before running any trials. A rough check:

```bash
# ~4 characters per token
for f in 3_contexts/*.txt; do
  echo "$f: ~$(($(wc -c < $f) / 4)) tokens"
done
```

Flag any context over ~150K tokens for review before running. Claude's context window is 200K tokens, but the science task prompt adds to that, and very long contexts degrade retrieval from the middle.

---

## Stage 4 — Trial Execution (`4_outputs/`, `run_trial.sh`)

Each trial invocation is a fresh agent with no memory of prior runs. The only inputs are the assembled context file (injected as a system prompt addendum) and the fixed science task prompt.

```bash
#!/bin/bash
# run_trial.sh
# Usage: bash run_trial.sh T1
# Outputs: 4_outputs/T1_notebook.md, 4_outputs/T1_raw.md

TRIAL=$1
CONTEXT="$(cat 3_contexts/${TRIAL}.txt)
Write the final notebook to 4_outputs/${TRIAL}_notebook.ipynb."
TASK=$(cat science_task.txt)

if [ ! -f "$CONTEXT" ]; then
  echo "Context file $CONTEXT not found. Run assemble_contexts.sh first."
  exit 1
fi

echo "Running trial $TRIAL..."
claude \
  --append-system-prompt-file "$CONTEXT" \
  --no-session-persistence \
  --dangerously-skip-permissions \
  -p "$TASK" 2>&1 | tee 4_outputs/${TRIAL}_raw.md

echo "Trial $TRIAL complete."
echo "  Raw output: 4_outputs/${TRIAL}_raw.md"
echo "  Notebook:   4_outputs/${TRIAL}_notebook.md"
```

Run trials in Phase 1 order first. Phase 1 is cheap and may short-circuit later decisions: if T2 (HW2 alone) produces a good result, that immediately tells you what Claude can do with a worked example and reshapes which Phase 2/3 trials matter most.

```bash
# Suggested execution order
bash run_trial.sh T0   # ~2 min — floor
bash run_trial.sh T1   # ~3 min — LSDB GUIDE solo
bash run_trial.sh T2   # ~3 min — HW2 solo
# Review Phase 1 outputs before proceeding
bash run_trial.sh T3
bash run_trial.sh T4
bash run_trial.sh T6   # T+D: hypothesized minimum; run before T5/T7
bash run_trial.sh T5
bash run_trial.sh T7
bash run_trial.sh T8
bash run_trial.sh TB   # bonus; run last
```

---

## Technical Notes

### `--append-system-prompt-file` vs. `--system-prompt`

Use `--append-system-prompt-file`. It adds your context on top of Claude Code's default tool guidance and coding conventions. `--system-prompt` replaces the entire system prompt, which drops tool guidance and safety instructions — not what you want here. You're only varying domain/library knowledge, not Claude's identity or permission model.

### `--no-session-persistence`

Disables session state from being written to disk. Each `run_trial.sh` invocation starts from a clean slate with no access to prior runs. This is the isolation guarantee.

### Tool restriction for low-context trials

For T0 and T4 (no library guidance), Claude may attempt to compensate by exploring the filesystem. Add `--tools "Write"` to restrict it to file writing only. This prevents it from probing data directories and bootstrapping context it wasn't given — which would be a confound. For higher-context trials (T6–T8), relax this restriction. Note which tool restriction setting was used in the trial log.


### Context size is a hard constraint

The standard context window is 200K tokens (~800KB of text). A full unprocessed
RTD or schema export will exceed this on its own. `compact_resources.sh` is not
optional — it's what keeps the ceiling trials within the window at all. After
compaction, run the token estimate check before any trial:

```bash
for f in 3_contexts/*.txt; do
  echo "$f: ~$(($(wc -c < $f) / 4)) tokens"
done
```

Any context file approaching 800KB needs further compaction before running.