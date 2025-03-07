# git-pr

a git plugin that allows you to run:

```bash
git pr
```

...which will:

* create a draft pull request on github into the main branch
* assign you to it
* find a PR template file and automatically use it
  * ...or if there is no template file, will fill the PR with some default text
* optionally open your default editor to edit the PR contents before submitting

see `git pr --help` for more details.
