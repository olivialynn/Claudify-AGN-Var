`agn_variability_drw.ipynb` is written. Here's what the notebook does end-to-end:

---

### Structure

| Section | Cells | What happens |
|---|---|---|
| **0 · Setup** | imports, eztaox probe, helpers | Detects which eztaox API pattern is installed (`.ts.drw_fit`, top-level function, or class), defines `fit_drw_model` / `predict_drw_model` / `sf_at_lag` with three fallback paths |
| **1 · Load catalogs** | 3 cells | `lsdb.open_catalog` for Gaia AGN (`gaia_dr3_agn`), `DiaObject`, `DiaSource`; prints schema |
| **2 · Cross-match** | 2 cells | `gaia_agn.crossmatch(dia_object, radius_arcsec=1.0)`; auto-resolves suffixed column names |
| **3 · Load DIA sources** | 2 cells | Tries `lsdb` join first (efficient); falls back to compute-then-filter; auto-detects `midpointMjdTai` / `band` / `psfFlux` column names |
| **4 · Flag filtering** | 1 cell | Removes detections where any `pixelFlags_bad/cr/saturated/edge/…` is set; bitmask fallback if columns are absent |
| **5 · LC selection** | 2 cells | Groups by `(diaObjectId, band)`, computes span and cadence, keeps ≥ 10 obs + ≥ 30 days, then selects the 200 densest-cadence LCs |
| **6 · DRW fitting** | 1 cell | Iterates the 200 LCs; mean-subtracts, time-shifts for numerical stability, calls `fit_drw_model`, stores σ, τ, and the GP object |
| **7 · SF(10 d) ranking** | 2 cells | Computes `SF(10) = σ√2·√(1−e^{−10/τ})` normalized by median flux; bar chart per band |
| **8 · Top AGN per band** | 1 cell | For each band with ≥ 10 LCs, picks `argmax(frac_SF10)` |
| **9 · LC plots** | 1 cell | For each top AGN: errorbar lightcurve + DRW mean + ±1σ shading + standardized residuals panel; saved to `top_agn_band_{u,g,r,i,z,y}.pdf` |
| **10 · Phys vs instr** | 4 cells | (1) variability vs wavelength + slope sign test; (2) log τ histogram with physical / instrumental reference lines; (3) log flux vs log SF10 with Spearman ρ; (4) inter-band variability correlation for the band pair with most common objects |
| **11 · Summary** | 1 cell | Prints every answer the prompt asks for |

---

### Key assumptions to verify before running

- **Gaia AGN URL**: `https://data.lsdb.io/hats/gaia_dr3_agn` — the probe cell prints three alternatives if it fails.
- **eztaox API**: the probe cell in §0.1 prints what it finds; `fit_drw_model` tries three patterns automatically. If none work, edit the `_HAS_TS_MODULE` branch to match the installed version.
- **DIA Source column names**: auto-detected with a priority list; an error message names the columns it found if detection fails.
