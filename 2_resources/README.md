# AGN Variability Pipeline — Context Ablation: Resource Inventory

19 resources · 17 ablation candidates · 1 bonus · 1 baseline

**Dimensions:** T = Tool (library API, coding patterns) · D = Domain (data schema, environment, catalog structure) · S = Science (methodology, physical interpretation)

**Size / Noise:** S = small, M = medium, L = large · L = low noise, M = medium, H = high noise. Favorable = small size, low noise.

---

## Critical

| Resource | Description | Dim | Size | Noise | Key Contribution | Notes / Caveats |
|---|---|---|---|---|---|---|
| `LSDB_GUIDE.md` | AI-targeted canonical LSDB reference | T | S | L | Lazy eval patterns, performance anti-patterns, AI-specific guidance | Standalone trial candidate. Highest signal-per-token of any resource. Test before bundling with other LSDB docs. |
| `AGN HW 2` | Pre-built pipeline matching exactly the target task | T D S | M | L | Complete target pipeline — the ceiling condition | Test as a solo trial first. Effectively the answer key. Highest expected single-resource impact. |
| `DP2 schema (sdm-schemas)` | sdm-schemas.lsst.io — full DP2 column definitions | D | L | H | Exact column names, flag definitions for quality cuts | Very large unfiltered. Consider curated excerpt of DiaObject / DiaSource only. Alternatively, encourage LSDB schema inspection tools. |

---

## High

| Resource | Description | Dim | Size | Noise | Key Contribution | Notes / Caveats |
|---|---|---|---|---|---|---|
| `LSDB API docs (RTD)` | ReadTheDocs API reference built from docs/ | T | M | L | Complete function signatures and class reference | Overlaps substantially with GUIDE.md. Test separately to determine if GUIDE.md alone suffices. |
| `LSDB AGN/Gaia notebooks` | Science pipeline notebooks incl. Gaia catalog access | T D | M | L | Gaia crossmatch pattern, AGN-specific LSDB usage | Covers the Gaia catalog access concern. More targeted than general notebooks. Partially overlaps RSP DP1 notebook. |
| `EzTaoX API docs (RTD)` | ReadTheDocs reference covering API and methodology | T | M | L | DRW fitting interface, output parameters, methodology motivation | Methodology coverage reportedly solid in RTD. May be sufficient without the paper. Test paper as marginal add-on. |
| `EzTaoX example notebooks` | Example notebooks for DRW fitting workflows | T | S | L | Concrete DRW fitting code and direct call patterns | Most directly actionable EzTaoX content. Strong candidate for bundling with API docs as a single unit. |
| `RSP LSDB notebook (DP1)` | 102_5_LSDB_data_access.ipynb — lsst/tutorial-notebooks | D | M | M | Rubin data access via LSDB, catalog path structure | DP1 schema — flag column names and catalog paths may differ from DP2. Audit before including. |
| `AGN Variability DP1 (LSDB)` | End-to-end AGN pipeline rewritten with LSDB | T S | M | L | Correct library + full science structure, end-to-end | DP1 schema, but LSDB patterns and science structure are directly applicable. High value. |

---

## Medium

| Resource | Description | Dim | Size | Noise | Key Contribution | Notes / Caveats |
|---|---|---|---|---|---|---|
| `LSDB general notebooks` | General-purpose LSDB example notebooks (GitHub/RTD) | T | L | M | Coding patterns across a broad range of LSDB use cases | Needs curation — many notebooks irrelevant to this task. High noise if included wholesale. |
| `EzTaoX paper` | Peer-reviewed methodology paper for EzTaoX / DRW | S | L | H | Deep DRW methodology, physical interpretation of τ and SF∞ | Test against RTD-only to assess marginal value for science answer quality. Dense academic text. |
| `AGN Variability DP1 (non-LSDB)` | End-to-end AGN notebook using older library stack | S | M | M | Science flow, analysis structure, plot layout | Uses a different library stack. Risk of contaminating LSDB patterns with non-LSDB approaches. |
| `Kelly et al. 2009` | Foundational DRW paper for AGN variability modeling | S | L | H | DRW motivation, foundational τ and SF∞ interpretation | Dense academic text. Worth testing only if science answer quality is insufficient with EzTaoX docs alone. |
| `MacLeod et al. 2010` | AGN variability statistics and DRW validation | S | L | H | AGN variability statistics, DRW empirical validation | Partially redundant with Kelly 2009. Test together with Kelly, or not at all. |

---

## Low

| Resource | Description | Dim | Size | Noise | Key Contribution | Notes / Caveats |
|---|---|---|---|---|---|---|
| `HATS IVOA note` | IVOA technical note defining HATS catalog format | T | M | H | Format specification for LSDB's underlying catalog format | Mostly theoretical. Unlikely to improve pipeline code quality for this task. |
| `HATS GitHub package` | hats Python package repo (LSDB dependency) | T | S | L | Confirms HATS as LSDB dependency; versioning info | Awareness context only. Rarely needed explicitly in pipeline code. |
| `S3DF cluster docs` | SLAC S3DF documentation (s3df.slac.stanford.edu) | D | M | H | Cluster environment, job submission specifics | Cluster env is already covered by the baseline statement. Only useful if the pipeline needs explicit cluster job management. |

---

## Bonus Trial (TBD)

| Resource | Description | Dim | Size | Noise | Key Contribution | Notes / Caveats |
|---|---|---|---|---|---|---|
| `Caplar repos (TBD)` | Selected Neven Caplar AGN variability repos | T S | ? | ? | AGN variability code, possibly DRW-adjacent analysis | Identify specific relevant notebooks first. Bonus trial only. |

---

## Always in Context — Not Ablated

| Resource | Description | Dim | Size | Noise | Key Contribution | Notes / Caveats |
|---|---|---|---|---|---|---|
| `USDF-RSP statement + data paths` | Cluster name, S3DF, and /sdf/data/rubin/… paths | baseline | S | L | Tells Claude the compute environment and where the data lives | Not ablated. Present in every trial. |