# ubi9

Builds a custom AlmaLinux 9 minimal Docker image. It's a small image (~200MB) which can then be used in workflows as follows: 

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
