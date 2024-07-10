#!/bin/bash -u

. config.env

function check_dep(){
  manifest="$1"
  dependencies=$(yq eval '.dependencies[] | .uri + " " + .sha256' $manifest)
  echo "$dependencies" | while read -r uri sha256; do
    if [ -n "$uri" ] && [ -n "$sha256" ]; then
        temp_file=$(mktemp)
        if curl -sfL "$uri" -o "$temp_file"; then
            computed_sha256=$(sha256sum "$temp_file" | awk '{print $1}')
            if [ "$computed_sha256" == "$sha256" ]; then
                echo "OK dep: $uri, hash: $sha256"
            else
                echo "!!! ERR dep: $uri, Computed hash: $computed_sha256 != expected: $sha256"
            fi
        else
            echo "!!! ERR dep $uri doesn't exist"
        fi
        rm -f "$temp_file"
    fi
  done
}

for repo in "${REPOS[@]}"
do
  repo_name=$(basename "$repo" .git)
  manifest_path="$WORK_DIR/$repo_name/manifest.yml"
  version_path="$WORK_DIR/$repo_name/VERSION"

  if [ -f "$manifest_path" ]; then
    echo " "
    echo "checking $repo_name $manifest_path ..."
    bp_ver=$(cat "$version_path")
    echo "version: $bp_ver"
    echo " "
    check_dep "$manifest_path"
    echo " "
  else
    echo "is not a buildpack $repo_name, not found: $manifest_path"
  fi

done
