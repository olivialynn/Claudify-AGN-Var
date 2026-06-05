# assemble_contexts.sh


# Phase 1: Solo probes

# Trial 0: Baseline only
cat resources/baseline.txt > contexts/T0.txt

# Trial 1: Baseline + LSDB guide
# cat resources/baseline.txt \
#     resources/lsdb_guide.txt > contexts/T1.txt

# # Trial 2: Baseline + HW2
# cat resources/baseline.txt \
#     resources/hw2.txt > contexts/T2.txt


# Phase 2: Dimension isolation

# Trial 3: Full Tool
# - LSDB guide + LSDB RTD + EZTAOX + LSDB NBS
# cat resources/baseline.txt \
#     resources/lsdb_guide.txt \
#     resources/lsdb_rtd.txt \
#     resources/eztaox.txt \
#     resources/lsdb_nbs.txt > contexts/T3.txt
