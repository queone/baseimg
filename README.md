# ubi9

Source code to build a custom [AlmaLinux 9](https://almalinux.org/) minimalist container image. The accompaying workflow must be run to then store it in the [GHCR registry](https://github.blog/news-insights/product-news/introducing-github-container-registry/). It's a small image (~200MB) which can then be used in workflows as follows: 

```yaml
...
jobs:
  build-and-push:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/queone/ubi9:latest
    steps:
...
```

sdfa
