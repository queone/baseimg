## baseimg
Source to build custom Docker container images.

| Image | Descriptions |
|---|---|
| quebase | A minimalist [AlmaLinux 9](https://almalinux.org/) 9 base image |
| quevault | Same as above but with Hashicorp `vault` binary added to it |

Sample Github workflow usage:

```yaml
jobs:
  build-and-push:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/queone/quebase:1.0.5   # or quevault:1.0.5
    steps:
      ...
```

See [accompanying workflows](https://github.com/queone/baseimg/actions) that allow building and registering these images to the [GHCR registry](https://github.blog/news-insights/product-news/introducing-github-container-registry/). These workflows also allow testing and removing these images.


### Development Notes
Development of these images is still in flux, so many things are likely to change at the moment.
