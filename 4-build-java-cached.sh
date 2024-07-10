#!/bin/bash -eux

. config.env
echo "$WORK_DIR"
echo "$JAVA_BP_NAME:$JAVA_BP_VERSION - $JAVA_BP_REPO"

pushd "$WORK_DIR" > /dev/null

  if [ ! -d "$JAVA_BP_NAME" ]; then
    git clone "$JAVA_BP_REPO"
  fi

  pushd "$JAVA_BP_NAME" > /dev/null

    git clean -fd
    git reset --hard origin/main

    git checkout main
    git fetch origin --tags

    git pull

    git checkout "$JAVA_BP_VERSION"
    build_cmd='cd /build && bundle install && bundle exec rake clean package OFFLINE=true PINNED=true'
    podman run -v "./":/build -it ruby:3.3 /bin/bash -c "$build_cmd"
    mv "./build/${JAVA_BP_NAME}-offline-${JAVA_BP_VERSION}.zip" "../${JAVA_BP_NAME}_cached-${JAVA_BP_VERSION}.zip"
    git checkout main
    git clean -fd

  popd > /dev/null

popd > /dev/null

