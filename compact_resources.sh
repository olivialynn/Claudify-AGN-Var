#!/bin/bash
# compact_resources.sh
# Compacts all resources in 2_resources/full/ into 2_resources/processed/.
# Target: each processed file well under 800KB (~200K tokens).
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
    2> 4_outputs/compact_${name%.txt}_raw.md
  echo "  $(wc -c < 2_resources/full/$name) bytes → $(wc -c < 2_resources/processed/$name) bytes"
done

echo ""
echo "Size check (target: each file well under 800KB):"
for f in 2_resources/processed/*.txt; do
  size=$(wc -c < $f)
  name=$(basename $f)
  if [ $size -gt 700000 ]; then
    echo "  WARNING $name: ${size} bytes — may need further compaction"
  else
    echo "  OK      $name: ${size} bytes"
  fi
done