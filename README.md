# cached-cf-buildpacks

The issue with standard Cloud Foundry (CF) buildpacks that are **not cached** is that they need to download dependencies from the Internet during the application staging process. If these dependencies are unavailable (and not cached by CF), the application staging fails.
This can be particularly problematic in environments with restricted Internet access or when some dependencies are no longer available online over time.
Therefore, it's a good practice to **prepare, cache, and upload buildpacks** with all necessary dependencies included, ensuring consistent and reliable deployments.

## Repository Structure

This repository contains:

- **[`config.env`](config.env)** — Configuration file listing buildpack repositories and settings.

- **Scripts:**
  - [`1-update-standard-repos.sh`](1-update-standard-repos.sh) - Downloads the latest versions of standard buildpack repositories.
  - [`2-check-standard-repos.sh`](2-check-standard-repos.sh) - Verifies all required dependencies for the buildpacks.
  - [`3-build-standard-cached.sh`](3-build-standard-cached.sh) - Builds cached versions of the standard buildpacks, bundling all dependencies.
  - [`4-build-java-cached.sh`](4-build-java-cached.sh) - Specialized script for building a cached version of the Java buildpack.

## Supported Buildpacks

- **standard buildpacks**:
  - `binary-buildpack`
  - `dotnet-core-buildpack`
  - `go-buildpack`
  - `nginx-buildpack`
  - `nodejs-buildpack`
  - `staticfile-buildpack`
- **`java-buildpack`**
