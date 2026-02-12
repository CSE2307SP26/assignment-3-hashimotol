#! /bin/bash

EXPECTED="$1"
OUTPUT="$2"
DEADLINE="2026-02-12 10:00:00 -0600"
ORG="CSE2307SP26"
BASE_DIR=$(pwd)

while read key; do
  git clone https://github.com/$ORG/$key.git &> /dev/null
  cd "$key"

 
  commit=$(git rev-list -1 --before="$DEADLINE" origin/cipher)

  if [ -z "$commit" ]; then
    echo "$key 0"
    cd ..
    continue
  fi

  git checkout -q "$commit"

  javac Cipher.java
  java Cipher > "$OUTPUT"


  if [ -f "$OUTPUT" ]; then
    result=$(diff "$BASE_DIR/$EXPECTED" "$OUTPUT")
    if [ -z "$result" ]; then
      echo "$key 1"
    else
      echo "$key 0"
    fi
  fi
  cd ..
done