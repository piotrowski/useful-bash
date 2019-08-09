#!/bin/bash
(

  if [[ $# -ne 2 ]]; then
    echo You should provide two arguments: ./find-remove-biggest-catalog PATH DEPTH
    exit 1
  fi
  currentBiggestCatal=$1
  maxDepth=$2

  currentDepth=0

  shouldGoDeeper=true
  while $shouldGoDeeper; do
    currentDepth=$((currentDepth+1))
    currentBiggestCatal=$(sudo du -a --max-depth=1 $currentBiggestCatal | sort -nr | awk 'NR==2{print $2}')

    if [[ -f $currentBiggestCatal ]]; then
      size=$(ls -lh "$currentBiggestCatal" | awk '{print $5, $6}')
      echo "$currentBiggestCatal is biggest file in current directory. Size: $size"
      shouldGoDeeper=false
    elif [[ $maxDepth == $currentDepth ]]; then
      echo "$currentBiggestCatal is biggest file in current directory. Size:"
      du -h --summarize $currentBiggestCatal
      shouldGoDeeper=false
    fi
  done

  read -r -p "Do you want to remove following directory? $currentBiggestCatal [y/N]: " response

  case "$response" in
    [yY][eE][sS]|[yY])
        rm -r $currentBiggestCatal
        echo "Removed"
      ;;
    *)
      echo "No removing"
      ;;
  esac
)
