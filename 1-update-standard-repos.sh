#!/bin/bash -u

. config.env
mkdir -p "$WORK_DIR"

pushd "$WORK_DIR" > /dev/null
  for repo in "${REPOS[@]}"
  do
    repo_name=$(basename "$repo" .git)
    echo "Repo: $repo"
    if [ ! -d "$repo_name" ]; then
      git clone "$repo"
    fi
    pushd "$repo_name" > /dev/null
      git pull
    popd > /dev/null
  done
popd > /dev/null
