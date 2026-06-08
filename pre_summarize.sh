#!/bin/bash
# pre_summarize.sh — run once before any trials

for resource in ./2_resources/full/R*.txt; do
  name=$(basename $resource .txt)
  summary_file="./2_resources/summarized/${name}_summary.txt"
  
  if [ ! -f "$summary_file" ]; then
    echo "Summarizing $name..."
    claude -p "Summarize the following resource, preserving all detail relevant " \
        "to the following task: $(cat science_task.txt). Return a concise summary " \
        "that captures all information that could be useful for the task, without " \
        omitting any details that might be relevant. Format the summary as a markdown " \
        "file with clear section headers and bullet points where appropriate."

$(cat $resource)" > "$summary_file"
  fi
done