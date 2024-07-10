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


