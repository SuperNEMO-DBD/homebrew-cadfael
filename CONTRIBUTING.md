# Contributing to Cadfael

[Cadfael](https://github.com/supernemo-dbd/homebrew-cadfael) is a [Homebrew](https://github.com/Homebrew/brew) tap of Formulae for installing
specific packages (and versions of) software for the SuperNEMO experiment.

To contribute a new formula or a new version of an existing formula, please submit your pull request here, though note these may be forwarded upstream to Linuxbrew/Homebrew if needed.

Patches to fix issues particular to Linux should not affect the behaviour of the formula on Mac. Use `if OS.mac?` and `if OS.linux?` as necessary to preserve the existing behaviour on Mac.

# Contributing to Homebrew

### Report a bug

* run `brew update` (twice)
* run and read `brew doctor`
* read [the Troubleshooting Checklist](http://docs.brew.sh/Troubleshooting.html)
* open an issue here

### Submit a version upgrade for the `foo` formula

* check if the same upgrade has been already submitted by [searching the open pull requests for `foo`](https://github.com/Homebrew/homebrew-core/pulls?utf8=✓&q=is%3Apr+is%3Aopen+foo).
* `brew bump-formula-pr --strict foo` with `--url=...` and `--sha256=...` or `--tag=...` and `--revision=...` arguments.

### Add a new formula for `foo` version `2.3.4` from `$URL`

* read [the Formula Cookbook](http://docs.brew.sh/Formula-Cookbook.html) or: `brew create $URL` and make edits
* `brew install --build-from-source foo`
* `brew audit --new-formula foo`
* `git commit` with message formatted `foo 2.3.4 (new formula)`
* open a pull request

### Contribute a fix to the `foo` formula

* `brew edit foo` and make edits
* leave the [`bottle`](http://www.rubydoc.info/github/Homebrew/brew/master/Formula#bottle-class_method) as-is
* `brew uninstall --force foo`, `brew install --build-from-source foo`, `brew test foo`, and `brew audit --strict foo`
* `git commit` with message formatted `foo: fix <insert details>`
* open a pull request


Thanks!
