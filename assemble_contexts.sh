# assemble_contexts.sh

case "$1" in
    "0")
        echo "Assembling contexts for trial 0 (Baseline only)..."
        cat 2_resources/baseline.txt > 3_contexts/T0.txt
        ;;
    "1")
        echo "Assembling contexts for trial 1 (Baseline + LSDB guide)..."
        cat 2_resources/baseline.txt \
            2_resources/lsdb_guide.txt > 3_contexts/T1.txt
        ;;
    "2")
        echo "Assembling contexts for trial 2 (Baseline + HW2)..."
        cat 2_resources/baseline.txt \
            2_resources/hw2.txt > 3_contexts/T2.txt
        ;;
    *)
        echo "Usage: $0 [0|1|2]"
        exit 1
        ;;
esac


# Phase 2: Dimension isolation

# Trial 3: Full Tool
# - LSDB guide + LSDB RTD + EZTAOX + LSDB NBS
# cat resources/baseline.txt \
#     resources/lsdb_guide.txt \
#     resources/lsdb_rtd.txt \
#     resources/eztaox.txt \
#     resources/lsdb_nbs.txt > contexts/T3.txt
