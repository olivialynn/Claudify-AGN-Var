# The Run Plan

## Directory setup
```
experiment/
  resources/            # raw downloaded resources, one dir each
    lsdb_guide/
    lsdb_rtd/
    eztaox/
    dp2_schema/
    ...
  contexts/             # assembled per-trial — your IV, checked into git
    T0_baseline.txt     # just the env/paths statement
    T1_lsdb_guide.txt   # baseline + LSDB_GUIDE.md contents
    T2_hw2.txt          # baseline + HW2 pipeline
    T3_full_tool.txt    # baseline + all Tool resources concatenated
    ...
  science_task.txt      # the fixed prompt — never changes
  outputs/
    T0_notebook.ipynb
    T1_notebook.ipynb
    ...
  run_trial.sh
```
## Generating the context files
```bash
# assemble.sh
cat resources/baseline.txt > contexts/T0.txt

cat resources/baseline.txt \
    resources/lsdb_guide.txt > contexts/T1.txt

cat resources/baseline.txt \
    resources/hw2.txt > contexts/T2.txt

cat resources/baseline.txt \
    resources/lsdb_guide.txt \
    resources/lsdb_rtd.txt \
    resources/eztaox.txt \
    resources/lsdb_nbs.txt > contexts/T3.txt
# ...and so on
```

## Running the trials
Suggested in a run script such as:
```bash
#!/bin/bash
TRIAL=$1  # e.g. 1
claude \
  --bare \
  --append-system-prompt-file ./contexts/T${TRIAL}.txt \
  --no-session-persistence \
  --dangerously-skip-permissions \
  --tools "Write" \
  --verbose \
  -p "$(cat science_task.txt)" | tee outputs/${TRIAL}_raw.txt 2>&1
```
Then `bash run_trial.sh T1`, `bash run_trial.sh T2`, etc. The `--max-budget-usd` guard is useful since lower-context trials may spin on useless tool calls.


## The flags explained
### Why `--bare` matters here
`--bare` enables minimal mode: it skips auto-discovery of hooks, skills, plugins, MCP servers, auto memory, and CLAUDE.md. Without it, Claude will read any CLAUDE.md in the working directory or parent directories — which is uncontrolled context leakage that would invalidate your trial boundaries. With `--bare`, the only context above the task prompt is what you explicitly inject via the system prompt file. 

<div class="alert alert-warning">
<b>Actually:</b> Never mind about this flag - it was causing claude to give "not logged in" errors. Omitting, as we have no CLAUDE.md file in this repo.
</div>

### Why not `--add-dir`: the core problem with the directory approach
`--add-dir` grants Claude file access to those directories, but doesn't deterministically load them into context — Claude would have to choose to Read them. For an ablation experiment, you want to know precisely what's in context, not infer it from Claude's browsing behavior. That's a confound.

### The right mechanism: `--append-system-prompt-file`
Assemble one context file per trial. That file is your independent variable — it's exactly what gets injected, documented, and diffed between trials.

### Why `--append` vs `--system-prompt`
Use the append flag when Claude should remain a coding assistant that also follows your extra rules. Appending preserves the default tool guidance, safety instructions, and coding conventions, so you only supply what differs. Use a replacement flag when the surface, identity, or permission model differs from Claude Code's — replacing drops all of the default prompt, including tool guidance and safety instructions. 

For this task, keep the default tool guidance. You want Claude Code acting like a competent code-generating agent; you're only varying what domain/library knowledge it has. `--append-system-prompt-file` is the right call.

### Using `-p` for a "new agent per trial"
Each claude `-p` ... invocation is a completely fresh agent with no memory of prior runs. `--no-session-persistence` disables session persistence so sessions are not saved to disk and cannot be resumed. Combine that with `--bare` and you have genuine isolation. 

### On tool restriction
For T0 (baseline) and other lower-context trials where Claude might try to compensate by exploring the filesystem, you can add `--tools "Write"` to restrict it to only writing files. That prevents it from probing the data directories and bootstrapping context it wasn't given. For the higher-context trials where you actually want it to produce a runnable notebook, you might relax this. Worth noting in your trial log either way.

## Questions and concerns (about large contexts)
**Will it fit?**  
Probably yes. Claude's context window is 200K tokens, and even a substantial RTD is unlikely to overflow that on its own. The ceiling trial with everything stacked might get uncomfortable, but it's not the binding constraint.

**Will it hurt the experiment?**  
Yes, if you dump full RTDs unmodified. This is the real concern. Your resource inventory already flagged it: the DP2 schema is explicitly marked "Very large unfiltered — consider curated excerpt." The same logic applies to the RTDs. A very long, loosely relevant document buries the signal. The model will tend to underweight material in the middle of a long context, and you lose the ability to attribute trial performance to anything specific — you can't tell whether a trial improved because of section X or despite sections Y and Z. That's a confound in the IV itself.

The LSDB_GUIDE.md is rated Critical partly because it's small and low-noise — it was specifically designed as a dense, targeted AI reference to solve exactly this problem. The RTDs weren't designed that way.

**What to do instead:**  
Curate excerpts rather than dumping full docs. For each RTD, figure out which functions and classes the reference pipeline actually calls, then extract just those API surfaces. For LSDB RTD, that's probably lsdb.catalog, lsdb.crossmatch, lsdb.Catalog.query_catalog, the relevant filtering methods, and the lazy evaluation / compute() patterns. For EzTaoX RTD, it's the DRW fitting interface and output parameters. You don't need the installation guide, the changelog, the contributor docs, or anything else.
The practical way to scope this: open HW2, list every LSDB and EzTaoX function call in the notebook, then pull only the RTD pages that document those calls. That gives you a curated excerpt that's directly load-bearing for the task, small enough to be signal rather than noise, and honest about what you've included.
This also improves the experiment. If T3 (Full Tool) performs well with a curated LSDB RTD excerpt, you have a much cleaner story than if it performs well with 80 pages of docs where you're not sure what did the work.