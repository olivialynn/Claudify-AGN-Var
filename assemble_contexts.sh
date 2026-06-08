#!/bin/bash
# assemble_contexts.sh
# Assembles 3_contexts/T*.txt from baseline.txt and 2_resources/processed/.
# Run this once before any trials, and again if resources are updated.

# --- Resource designations ---
LSDB_GUIDE=2_resources/processed/lsdb_guide.txt
LSDB_RTD=2_resources/processed/lsdb_rtd.txt
EZTAOX=2_resources/processed/eztaox.txt
DP2_SCHEMA=2_resources/processed/dp2_schema.txt
RSP_LSDB_NB=2_resources/processed/rsp_lsdb_nb.txt
LSDB_NBS=2_resources/processed/lsdb_nbs.txt
AGN_VAR_NB=2_resources/processed/agn_var_nb.txt
HW2=2_resources/processed/hw2.txt
CAPLAR=2_resources/processed/caplar.txt
BASE=baseline.txt

# --- Phase 1: Solo probes ---
echo "Trial: T0. Write the final notebook to 4_outputs/T0_notebook.ipynb." > 3_contexts/T0.txt
cat $BASE >> 3_contexts/T0.txt

echo "Trial: T1. Write the final notebook to 4_outputs/T1_notebook.ipynb." > 3_contexts/T1.txt
cat $BASE $LSDB_GUIDE >> 3_contexts/T1.txt

echo "Trial: T2. Write the final notebook to 4_outputs/T2_notebook.ipynb." > 3_contexts/T2.txt
cat $BASE $HW2 >> 3_contexts/T2.txt

# --- Phase 2: Dimension isolation ---
echo "Trial: T3. Write the final notebook to 4_outputs/T3_notebook.ipynb." > 3_contexts/T3.txt
cat $BASE $LSDB_GUIDE $LSDB_RTD $EZTAOX $LSDB_NBS >> 3_contexts/T3.txt  # Full Tool

echo "Trial: T4. Write the final notebook to 4_outputs/T4_notebook.ipynb." > 3_contexts/T4.txt
cat $BASE $DP2_SCHEMA $RSP_LSDB_NB >> 3_contexts/T4.txt                  # Full Domain

echo "Trial: T5. Write the final notebook to 4_outputs/T5_notebook.ipynb." > 3_contexts/T5.txt
cat $BASE $AGN_VAR_NB >> 3_contexts/T5.txt                               # Full Science

# --- Phase 3: Progressive build ---
echo "Trial: T6. Write the final notebook to 4_outputs/T6_notebook.ipynb." > 3_contexts/T6.txt
cat $BASE $LSDB_GUIDE $LSDB_RTD $EZTAOX $LSDB_NBS \
    $DP2_SCHEMA $RSP_LSDB_NB >> 3_contexts/T6.txt                        # T + D

echo "Trial: T7. Write the final notebook to 4_outputs/T7_notebook.ipynb." > 3_contexts/T7.txt
cat $BASE $LSDB_GUIDE $LSDB_RTD $EZTAOX $LSDB_NBS \
    $DP2_SCHEMA $RSP_LSDB_NB $AGN_VAR_NB >> 3_contexts/T7.txt            # T + D + S

echo "Trial: T8. Write the final notebook to 4_outputs/T8_notebook.ipynb." > 3_contexts/T8.txt
cat $BASE $LSDB_GUIDE $LSDB_RTD $EZTAOX $LSDB_NBS \
    $DP2_SCHEMA $RSP_LSDB_NB $AGN_VAR_NB $HW2 >> 3_contexts/T8.txt       # Full ceiling

# --- Bonus ---
echo "Trial: TB. Write the final notebook to 4_outputs/TB_notebook.ipynb." > 3_contexts/TB.txt
cat $BASE $LSDB_GUIDE $LSDB_RTD $EZTAOX $LSDB_NBS \
    $DP2_SCHEMA $RSP_LSDB_NB $AGN_VAR_NB $HW2 $CAPLAR >> 3_contexts/TB.txt

echo "Assembled context files:"
wc -l 3_contexts/*.txt