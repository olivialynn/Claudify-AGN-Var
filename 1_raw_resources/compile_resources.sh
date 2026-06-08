#!/bin/bash

# This will be an evolving script, to compile certain sets of raw resources into
# single resource files.


case "$1" in
    HW2)
        # This directory contains 4 notebook to be combine, with their file titles 
        # written above the content. We want to combine them into a single file at
        # resources/HW2.txt, with the file titles as section headers.

        SUBDIR="HW2"
        OUTPUT="../2_resources/HW2.txt"
        
        # Truncate/create the output file
        : > "$OUTPUT"

        # Iterate over all files in the subdirectory, append their names and 
        # contents to the output file
        find "$SUBDIR" -type f | while IFS= read -r file; do
            echo "$file" >> "$OUTPUT"
            cat "$file" >> "$OUTPUT"
            echo >> "$OUTPUT"
        done
        ;;

    *)
        echo "Command omitted, or not (yet) supported."
        echo "Usage: $0 HW2"
        exit 1
        ;;
esac


