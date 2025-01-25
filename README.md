# ubi9

Builds a custom [AlmaLinux 9](https://almalinux.org/) minimalist container image and stores it in the [GHCR registry](https://github.blog/news-insights/product-news/introducing-github-container-registry/). It's a small image (~200MB) which can then be used in workflows as follows: 

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
