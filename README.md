# cached-cf-buildpacks

The issue with standart CF buildpacks that are not cached is that they need to download dependencies from the Internet during the application staging process.
If these dependencies are not available, the application staging fails.
This can be problematic in environments with restricted Internet access or when the dependencies are no longer available online.

To address this issue, we have a **temporary** repository that provides cached versions of certain buildpacks in the release section.
These cached buildpacks include all necessary dependencies, ensuring that the application staging process can complete successfully without needing to download anything from the Internet.

Please visit the release section to find and use these cached buildpacks. 


Additionally, you can prepare your own cached buildpacks for future use with the following command:
```sh
./scripts/package.sh --stack cflinuxfs3 --version <version> --cached
```
By doing this, you can ensure that all necessary dependencies are included in your buildpacks, making the application staging process more reliable and efficient.

## Build Offline Buildpacks Script

```bash
#!/bin/bash -eu

mkdir -p ./.build

package_offline_buildpack() {
    local buildpack=$1
    local version=$2
    local stack=$3
    local out_file="../.build/${buildpack}_offline-${stack}-v${version}.zip"
    ./scripts/package.sh --stack "$stack" --cached --version "$version" --output "$out_file"
}

for DIR in *-buildpack; do
    if [ -d "$DIR" ]; then
        pushd "$DIR" > /dev/null
        echo "====== $DIR"
        git pull
        if [ -f "VERSION" ]; then
            VERSION=$(cat "VERSION")
            BUILDPACK="${DIR//-/_}"
            echo "Processing buildpack: $BUILDPACK, version: $VERSION"
            package_offline_buildpack "$BUILDPACK" "$VERSION" "cflinuxfs3".
            package_offline_buildpack "$BUILDPACK" "$VERSION" "cflinuxfs4"
            echo "done."
        else
            echo "VERSION file not found in $DIR"
        fi
        popd > /dev/null
    fi
done
```


---

> @rkoster
> With the above information was able to build an offline java buildpack by running the following snippet from the root of the repo:
```
docker run -v ./:/build -it ruby:3.3 /bin/bash -c '                                                                                                                     
  cd /build && bundle \                                                                                                                                                 
  && find -type f -exec sed -i "s/buildpacks.cloudfoundry.org/pivotal-buildpacks.s3.amazonaws.com/g" {} + \                                                             
  && bundle exec rake clean package OFFLINE=true PINNED=true'
```

> @schmidtsv
> remember you can not build offline java buildpacks but the latest version and only that around release time since the dependencies are not versioned and it always pulls the latest

