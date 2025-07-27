#!/bin/bash

echo 'Starting execution of all run.sh scripts...'

find . -type f -name 'run.sh' | while read script; do
  echo "Entering directory: $(dirname -- "$script")"
  cd "$(dirname -- "$script")"
  echo "Executing script: $script"
  time ./run.sh 
  cd  "$OLDPWD"
done

echo 'All scripts executed.'
