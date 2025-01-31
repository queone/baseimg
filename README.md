# cntimage

Source code to build a custom [AlmaLinux 9](https://almalinux.org/)-based, minimalist **container image**. The accompaying [Build and Push GHCR](https://github.com/queone/cntimage/actions/workflows/build-and-push-image.yml)workflow must be run to then store it in the [GHCR registry](https://github.blog/news-insights/product-news/introducing-github-container-registry/).

## Usage

```yaml
...
jobs:
  build-and-push:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/queone/cntimage:latest # <== like this 
    steps:
...
```

