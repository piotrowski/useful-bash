#!/bin/bash

get_and_extract_hash () {
  local hash

  if [[ $# == 0 ]]; then
    hash=$(md5sum /dev/stdin | cut -d ' ' -f 1)
  else
    hash=$(md5sum $1 | cut -d ' ' -f 1)
  fi

  echo "$hash"
}

(
  # $1 - file to check
  # $2 - link to download file

  local_md5=$(get_and_extract_hash "$1")
  curl_md5=$(curl -sL "$2" | get_and_extract_hash)

  if [[ "$local_md5" != "$curl_md5" ]]; then
    curl --output "$1" "$2"
    chmod 755 "$1"
    echo "Newest version installed."

  else
    echo "Newest version already installed."
  fi
)
