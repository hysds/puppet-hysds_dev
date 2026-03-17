# Multi-Platform Build Updates for puppet-hysds_dev

## Summary
Updated `build_docker.sh` to support building multi-platform container images for both **linux/amd64** (x86_64) and **linux/arm64** (ARM64/aarch64) architectures.

## Changes Made

### 1. build_docker.sh
**File**: `build_docker.sh`

Added conditional logic to support both standard Docker builds and multi-platform buildx builds:

- **Environment Variables**:
  - `USE_BUILDX=1` - Enables multi-platform build mode
  - `DOCKER_BUILDX_PLATFORM` - Specifies target platforms (default: "linux/amd64,linux/arm64")

- **Behavior**:
  - When `USE_BUILDX=1`: Uses `docker buildx build` with `--platform` flag and `--push`
  - Otherwise: Uses standard `docker build` (backward compatible)

**Example Usage**:
```bash
# Standard build (x86_64 only)
./build_docker.sh latest hysds develop

# Multi-platform build
export USE_BUILDX=1
export DOCKER_BUILDX_PLATFORM="linux/amd64,linux/arm64"
./build_docker.sh latest hysds develop
```

### 2. Dockerfiles - No Changes Required ✅

Both `docker/Dockerfile` and `docker/Dockerfile.cuda` are already multi-platform compatible:

- **docker/Dockerfile**: Extends `hysds/base:${TAG}` (which is now multi-platform)
- **docker/Dockerfile.cuda**: Extends `hysds/cuda-base:${TAG}` (which is now multi-platform)
- No architecture-specific commands or dependencies
- No hardcoded x86_64 references

### 3. Manifests - No Changes Required ✅

The `manifests/init.pp` file contains no architecture-specific configurations:
- No hardcoded x86_64 packages
- No architecture-specific installations
- Works identically on both amd64 and arm64

## Prerequisites

### Base Images Must Be Multi-Platform

This repository depends on multi-platform base images from `puppet-hysds_base`:
- ✅ `hysds/base:${TAG}` - Must support both linux/amd64 and linux/arm64
- ✅ `hysds/cuda-base:${TAG}` - Must support both linux/amd64 and linux/arm64

Ensure these base images are built and pushed as multi-platform before building dev images.

## Build Order

The correct build order for multi-platform images:

1. **First**: Build base images in `puppet-hysds_base`
   ```bash
   cd /path/to/puppet-hysds_base
   export USE_BUILDX=1
   export DOCKER_BUILDX_PLATFORM="linux/amd64,linux/arm64"
   ./build_docker.sh latest hysds develop
   ```

2. **Second**: Build dev images in `puppet-hysds_dev`
   ```bash
   cd /path/to/puppet-hysds_dev
   export USE_BUILDX=1
   export DOCKER_BUILDX_PLATFORM="linux/amd64,linux/arm64"
   ./build_docker.sh latest hysds develop
   ```

## Testing Checklist

### Build Testing
- [ ] Standard build works: `./build_docker.sh test hysds develop`
- [ ] Multi-platform build works with buildx enabled
- [ ] Both hysds/dev and hysds/cuda-dev build successfully
- [ ] Images are pushed to registry with correct manifest

### Runtime Testing
- [ ] **x86_64**: Pull and run image on x86_64 host
  ```bash
  docker run --platform linux/amd64 hysds/dev:test python --version
  ```
- [ ] **ARM64**: Pull and run image on ARM64 host
  ```bash
  docker run --platform linux/arm64 hysds/dev:test python --version
  ```

### CUDA-Specific Testing (x86_64 only)
- [ ] CUDA libraries are accessible in cuda-dev image
- [ ] GPU detection works (if GPU available)

## Verify Multi-platform Images

After building, verify both architectures are present:

```bash
# Check dev image
docker buildx imagetools inspect hysds/dev:latest

# Check cuda-dev image
docker buildx imagetools inspect hysds/cuda-dev:latest
```

Expected output should show manifests for both:
- Platform: linux/amd64
- Platform: linux/arm64

## Rollback Plan

If issues arise, revert to single-platform builds by:
1. Not setting `USE_BUILDX=1` environment variable
2. The script will automatically use standard `docker build` commands

## Known Limitations

1. **CUDA on ARM64**: Limited support, may require platform-specific builds
2. **Build Time**: Multi-platform builds take significantly longer (2x+ time)
3. **Base Image Dependency**: Requires multi-platform base images to be available

## Related Files

This repository's changes work in conjunction with:
- `/Users/mcayanan/git/puppet-hysds_base/` - Base image repository (must be built first)
- `/Users/mcayanan/git/hysds-framework/.circleci/config.yml` - CircleCI configuration
- `/Users/mcayanan/git/hysds-framework/.circleci/MULTIPLATFORM_BUILD_NOTES.md` - Overall strategy

## Additional Notes

- The architecture detection and platform selection happens automatically during buildx
- Docker automatically pulls the correct architecture when running containers
- Images are tagged once but contain manifests for multiple architectures
- No changes to application code are required
