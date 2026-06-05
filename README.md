# AGN Variability Pipeline — Context Engineering Experiment

This repo documents a controlled experiment: what context does an LLM need to generate a correct, performant scientific data pipeline in a single attempt, with no iteration?

---

## Background

Gordon Richards (Drexel University) built an AGN variability population demo notebook for the LSST-DA meeting at JHU, combining LINCC Frameworks tutorials into an end-to-end pipeline. The pipeline selects AGN lightcurves from Rubin LSST data, fits a damped random walk (DRW) variability model to each, and answers which sources and bands are most variable.

Claude was then used to rewrite the notebook using [LSDB](https://lsdb.readthedocs.io) — a catalog partitioning library built on Dask that enables lazy, scalable cross-matching of large astronomical catalogs. The rewrite achieved a >3× runtime speedup. But it required significant back-and-forth to get there. The key failure: Claude loaded lightcurve data before the catalog crossmatch, an expensive anti-pattern that LSDB is specifically designed to avoid. Only after being explicitly corrected did it produce a performant pipeline.

The goal of this experiment is to understand what context would have prevented that failure in the first place — and more broadly, to map the relationship between context configuration and output quality across the full pipeline task.

---

## What is context ablation?

An LLM's output is shaped by everything in its context window: documentation, examples, schema definitions, prior code. Different context produces different code. **Context ablation** is a systematic method for figuring out which inputs actually matter.

The procedure: hold the task prompt fixed across every trial, vary only the context, and compare the results. Run the same prompt with no context (baseline), then with specific combinations of resources, and measure what changes. Trials where output quality improves identify load-bearing context; trials where it doesn't reveal what was redundant or noisy.

This is the same logic as a controlled experiment — one independent variable (context configuration), one dependent variable (pipeline quality), everything else constant. The experiment is designed to find the **minimum sufficient context**: the smallest combination of resources that produces a correct, performant pipeline in a single shot.

---

## The science task

The following prompt is fed verbatim to Claude at the start of every trial. It does not change between trials.

```
Cross-match the Gaia AGN catalog with Rubin DP2. Select ≥200 band-lightcurves
(≥30 days, densest cadence). Remove flagged detections. Fit a damped random walk
(DRW) model with EzTaoX to each lightcurve. Answer: which band is most variable
on ~10-day scales? Which AGN is most variable per u/g/r/i/z/y band (bands with
>10 lightcurves only)? Plot lightcurve + EzTaoX fit for each top AGN, and assess
physical vs. instrumental variability.
```

A verified reference implementation of this pipeline ("AGN HW 2") exists and serves as the quality ceiling for evaluation. The pipeline runs on the USDF-RSP cluster at SLAC S3DF; the cluster name and DP2 data paths are provided as baseline context in every trial.

---

## Experiment design

### Resources

Candidate context resources are catalogued across three dimensions:

- **Tool (T)** — library API documentation, coding patterns, and anti-pattern guidance for LSDB and [EzTaoX](https://eztaox.readthedocs.io) (the DRW fitting library)
- **Domain (D)** — Rubin DP2 schema definitions, flag column names, and catalog access patterns specific to the RSP environment
- **Science (S)** — end-to-end AGN variability pipeline examples and DRW methodology

Two resources are always present and not ablated: a brief statement of the compute environment and the DP2 data paths on the cluster. Everything else is a candidate for ablation.

→ **[Full resource inventory](https://olivialynn.github.io/Claudify-AGN-Var/docs/resource_inventory.html)** — all 19 resources rated by expected helpfulness and context burden

### Trials

Trials are organized into three phases:

**Phase 1 — Solo probes.** Baseline (no context), the AI-targeted LSDB guide alone, and the reference pipeline alone. These run first: they're fast, cheap, and immediately establish the floor and a reference point.

**Phase 2 — Dimension isolation.** Each dimension tested independently — Full Tool, Full Domain, Full Science. This tests whether any single dimension is sufficient on its own, and which failure modes each dimension addresses.

**Phase 3 — Progressive build.** T+D (the hypothesized minimum working set), T+D+S, and the full ceiling with all resources active. If T+D works and T+S doesn't, the schema was the critical missing piece; if neither works alone but T+D does together, they're jointly necessary.

A bonus trial attempts any and all of esteemed astrophysicist Neven Caplar's relevant code repositories, as well as his AGN Variability (with LSDB) notebook.

→ **[Trial matrix](https://olivialynn.github.io/Claudify-AGN-Var/docs/trial_matrix.html)** — all 10 trials with resource inclusion and execution priority

### Execution

See the [Run Plan](https://olivialynn.github.io/Claudify-AGN-Var/docs/run_plan.md) for more information.

---

## Evaluation

Each trial produces a notebook. Notebooks are scored against the reference implementation on two axes:

- **Correctness** — does it use the right tables, columns, and quality flags? Does it answer the science questions accurately?
- **Performance** — does it avoid the lazy evaluation anti-pattern? Specifically: does it avoid loading lightcurves before the crossmatch?

Lower-context trials are expected to fail on one or both axes. The experiment succeeds when the minimum sufficient context configuration is identified — the point at which adding more context stops improving the output.
