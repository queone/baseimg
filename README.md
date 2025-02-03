## cntimage

Source to build custom Docker **container images**.

| Image | Descriptions |
|---|---|
| quebase | A minimalist base image built around [AlmaLinux 9](https://almalinux.org/) |
| quevault | Same as above with Hashicorp `vault` binary added to it |

To use the image, simply refer to it in your workfow `image` parameter:

```yaml
jobs:
  build-and-push:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/queone/quebase:1.0.3 # <== like this
      #image: ghcr.io/queone/quevault:1.0.3 # <== or this
    steps:
```

See [accompanying workflows](https://github.com/queone/cntimage/actions) that allow building and releasing, testing, and removing each image.

These images are registered in the [GHCR registry](https://github.blog/news-insights/product-news/introducing-github-container-registry/).


### Development Notes

Development of these images is still in flux, so many things are likely to change at the moment.
