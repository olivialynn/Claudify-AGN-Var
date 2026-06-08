# AGN Variability Pipeline ○ Context Ablation: Trial Matrix

10 trials · 3 phases · 1 bonus · 9 resource bundles

**Resource columns** are grouped by dimension: Tool (T) · Domain (D) · Mixed (T+D or T+S) · All dims · Bonus.
● = included · ○ = excluded

---

## Phase 1 - Solo Probes

| Trial | Label | LSDB GUIDE (T) | LSDB RTD (T) | EZ RTD+NB (T) | DP2 SCH (D) | RSP LSDB NB (D) | LSDB NBs (T+D) | AGN VAR NB (T+S) | HW2 (All) | CAP (Bonus) | Priority | Purpose |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T0 | Baseline only | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | Essential | Floor: what does Claude produce with no context at all? |
| T1 | +LSDB GUIDE only | ● | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | Essential | Does the AI-targeted guide alone prevent the lazy eval anti-pattern? |
| T2 | +HW2 only | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ● | ○ | Essential | Reference: how does Claude use the target pipeline as a template with nothing else? |

---

## Phase 2 - Dimension Isolation

| Trial | Label | LSDB GUIDE (T) | LSDB RTD (T) | EZ RTD+NB (T) | DP2 SCH (D) | RSP LSDB NB (D) | LSDB NBs (T+D) | AGN VAR NB (T+S) | HW2 (All) | CAP (Bonus) | Priority | Purpose |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T3 | Full Tool | ● | ● | ● | ○ | ○ | ● | ○ | ○ | ○ | Essential | All Tool resources; no schema or science example |
| T4 | Full Domain | ○ | ○ | ○ | ● | ● | ○ | ○ | ○ | ○ | Essential | All Domain resources; no library guidance or science example |
| T5 | Full Science | ○ | ○ | ○ | ○ | ○ | ○ | ● | ○ | ○ | Recommended | Science example only (AGN VAR NB); no explicit API docs |

---

## Phase 3 - Progressive Build

| Trial | Label | LSDB GUIDE (T) | LSDB RTD (T) | EZ RTD+NB (T) | DP2 SCH (D) | RSP LSDB NB (D) | LSDB NBs (T+D) | AGN VAR NB (T+S) | HW2 (All) | CAP (Bonus) | Priority | Purpose |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T6 | T + D | ● | ● | ● | ● | ● | ● | ○ | ○ | ○ | Essential | Hypothesized minimum working set: correct library use + correct schema |
| T7 | T + D + S | ● | ● | ● | ● | ● | ● | ● | ○ | ○ | Recommended | Tests whether the science example improves quality above T+D alone |
| T8 | Full ceiling | ● | ● | ● | ● | ● | ● | ● | ● | ○ | Essential | All resources active; true ceiling condition |

---

## Bonus

| Trial | Label | LSDB GUIDE (T) | LSDB RTD (T) | EZ RTD+NB (T) | DP2 SCH (D) | RSP LSDB NB (D) | LSDB NBs (T+D) | AGN VAR NB (T+S) | HW2 (All) | CAP (Bonus) | Priority | Purpose |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| TB | +Caplar | ● | ● | ● | ● | ● | ● | ● | ● | ● | Bonus | Ceiling + Caplar repos ○ run last; he'd get a kick out of it |

---

## Resource Key

| Abbreviation | Full name |
|---|---|
| LSDB GUIDE | LSDB_GUIDE.md - AI-targeted canonical reference |
| LSDB RTD | LSDB API docs (ReadTheDocs) |
| EZ RTD+NB | EzTaoX API docs + example notebooks |
| DP2 SCH | DP2 schema - curated excerpt (sdm-schemas.lsst.io) |
| RSP LSDB NB | RSP LSDB data access notebook (DP1) |
| LSDB NBs | LSDB AGN/Gaia science notebooks |
| AGN VAR NB | AGN Variability DP1 - LSDB edition |
| HW2 | AGN HW 2 - pre-built target pipeline (answer key) |
| CAP | Caplar repos (TBD) |