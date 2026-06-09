## Phil's Rush Packages

My personal [Rush](https://github.com/DannyBen/rush-cli) package repository.

If you...

* don't want to install Rush
* DO want some of these packages
* DO like living dangerously

...then you can use [my YOLO script](https://philcrockett.com/yolo/v2.sh):

```bash
curl -SsfL https://philcrockett.com/yolo/v2.sh \
    | bash -s -- <PACKAGE_NAMES...>
```

Or use my GitHub action, for example:

```yaml
jobs:
  example:
    runs-on: ubuntu-latest
    steps:
    - name: Install Rush packages
      uses: pcrockett/rush-repo
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}  # for packages that touch the GitHub API
      with:
        packages: space delimited package names
```
