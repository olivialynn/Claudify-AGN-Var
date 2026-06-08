Notebook written to `T2_agn_drw_variability.ipynb`. Here's what each section does and what to watch for when you run it:

**Cells 1–2** — imports and a Dask client (8 workers × 8 GB; tune to your allocation).

**Cells 3–4** — loads `dia_object_collection` and auto-detects the nested sources column. **Check the printed schema** and adjust `NESTED_COL`, `TIME_COL`, `FLUX_COL`, `BAND_COL` if your v30_0_6 schema differs.

**Cell 5** — queries `gaiadr3.qso_candidates` (P_qso > 0.9) via astroquery. **Update `RA_MIN/MAX`, `DEC_MIN/MAX`** after looking at the coverage map from Cell 4.

**Cells 6–7** — LSDB crossmatch at 1 arcsec, then computes the matched DataFrame.

**Cells 8–9** — unpacks nested sources, applies pixel flags, splits by band, keeps lightcurves with ≥ 30-day baseline, sorts by cadence density and selects the top 200+.

**Cell 10** — calls `eztaox` via a three-attempt adapter (`DRW().fit` → `fit_drw` → `carma_fit`). If all three fail you'll see the error logged; adjust `_call_eztaox` to match the installed API. Computes SF(10 d) = σ√(2(1−e^{−10/τ})) for each fit.

**Cell 11** — bar chart of median SF(10 d) per band; prints the most variable band.

**Cell 12** — identifies the top AGN per band (bands with > 10 converged fits only).

**Cell 13** — plots each top AGN's lightcurve with the analytic DRW GP posterior mean ± 1σ envelope. Title flags unconstrained τ.

**Cell 14** — four-panel diagnostic: τ distribution, bluer-is-brighter Spearman test, τ/baseline quality, and fractional amplitude σ/|⟨flux⟩|. Prints the final summary with an interpretive note that short commissioning baselines (< 90 days) make τ estimates unreliable for typical AGN (τ_AGN ~ 200–500 days >> baseline), so SF(10 d) is a lower bound until Year-1 data are available.
