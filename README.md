## cntimage

Source to build a custom [AlmaLinux 9](https://almalinux.org/)-based, minimalist **container image**. The accompanying workflows allow testing the image and releasing it to the [GHCR registry](https://github.blog/news-insights/product-news/introducing-github-container-registry/).

### Usage

To use the image, simply refer to it in your workfow `image` parameter:

```yaml
jobs:
  build-and-push:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/queone/que-base:1.0.3 # <== like this 
    steps:
```
