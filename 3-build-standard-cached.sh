#!/bin/bash -eu

. config.env
echo "$CF_STACK"

build_cached_standard_buildpack() {
    local bp_dir=$1
    local buildpack=$2
    local version=$3
    local stack=$4
    local out_filename=$5

    pushd "$bp_dir" > /dev/null
      ./scripts/package.sh --stack "$stack" --cached --version "$version" --output "../$out_filename"
      echo "done: $out_filename"
    popd > /dev/null
}

for repo in "${REPOS[@]}"
do
  repo_name=$(basename "$repo" .git)
  manifest_path="$WORK_DIR/$repo_name/manifest.yml"
  version_path="$WORK_DIR/$repo_name/VERSION"

  if [ -f "$manifest_path" ]; then
    bp_version=$(cat "$version_path")
    bp_out_filename="${repo_name}_cached-${CF_STACK}-v${bp_version}.zip"
    if [ -f "${WORK_DIR}/$bp_out_filename" ]; then
      echo "file already exists ${WORK_DIR}/$bp_out_filename ..."
    else
      echo " "
      echo "building $repo_name $manifest_path ..."
      echo "version: $bp_version"
      echo " "
      build_cached_standard_buildpack "$WORK_DIR/$repo_name" "$repo_name" "$bp_version" "$CF_STACK" "$bp_out_filename"
      echo " "
    fi
  else
    echo "is not a standard buildpack $repo_name, not found: $manifest_path"
  fi

done
