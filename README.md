# Homebrew tap for SuperNEMO
Custom Formulae and Commands for SuperNEMO's [cadfaelbrew fork](https://github.com/SuperNEMO-DBD/cadfaelbrew) of
Linux/Homebrew. Though designed for use with cadfaelbrew, it should
work and be compatible with upstream linuxbrew/homebrew modulo version dependencies on Formulae.

# Quickstart
If you have an existing Homebrew (macOS) install, simply do

```
$ brew tap supernemo-dbd/cadfael
$ brew cadfael-bootstrap-toolchain
$ brew install falaise
```

Use this tap with an existing Linuxbrew installation is currently not supported as there may be clashes between 
Linuxbrew's install of gcc/glibc and the CERN ROOT dependency. On Linux, it's therefore recommended to use SuperNEMO's fork of brew:

```
$ git clone https://github.com/SuperNEMO-DBD/brew.git cadfaelbrew
$ cd cadfaelbrew
$ ./bin/brew cadfael-bootstrap
$ ./bin/brew install falaise
```

# Formulae
## Core
CadfaelBrew prefers formulae from this tap over those in its core `Library/Formula` directory.
Installing the ``falaise`` formula will install the core SuperNEMO software packages

- Bayeux C++ Core Foundation Library
- Falaise C++ Simulation/Reconstruction/Analysis Applications

plus their upstream dependencies:

- [Boost](http://www.boost.org)
- [ROOT](https://root.cern.ch)
- [GSL](http://www.gnu.org/software/gsl/)
- [CAMP](https://github.com/tegesoft/camp)
- [CLHEP](http://proj-clhep.web.cern.ch/proj-clhep/)
- [XercesC](http://xerces.apache.org/xerces-c/)
- [Geant4](http://geant4.cern.ch)
- [Doxygen](http://www.stack.nl/~dimitri/doxygen/)
- [Python](https://www.python.org)

## Development
Several additional Formulae are provided which are not installed by default. These are intended for
use by Bayeux/Falaise developers to integrate new functionality or move to newer, API incompatible,
versions of dependent packages.

- [Qt5](http://doc.qt.io/qt-5/)
- [Ponder](https://github.com/billyquith/ponder)
  - Note: This replaces the [CAMP]() package

## Python
Installing Falaise will also install (via the ROOT dependency) a brewed copy of Python. This includes
the `pip` and `setuptools` packages, so you may also install any compatible Python package from [PyPI](https://pypi.python.org/pypi) if you need this.

## Other
A wide range of packages are available through `brew`, and you can search for these via the `search` subcommand, e.g.

```console
$ brew search foo
```

If you find a package you need is not present, add a request for it in the [Issue Tracker](https://github.com/SuperNEMO-DBD/homebrew-cadfael/issues)

# Note on C/C++ Standards
Bayeux/Falaise are compiled against the C++11 standard by default to ensure
forward/binary compatibility with current developments of plugin code.

Installing Bayeux/Falaise will automatically install all their dependencies
against the same standard. However, if you are installing other Formulae by
hand, you will need to supply the `--c++11` flag to activate compilation of
that Formulae against C++11, e.g.

```
$ brew install boost --c++11
```

The options available for building a Formula can be checked using Brew's `info`
subcommand:

```
$ brew info <formulaname>
```

# Commands
## `brew-versions.rb`
Cadfael-supplied implementation of the old `versions` subcommand. This
has been removed the boneyard upstream, but we'd like to keep the
functionality so that formula version histories can be queried. This
is needed to reliably produce versioned snapshot releases.

The command will automatically be available to `brew` once this repository
is tapped. It is used by passing a formula name(s) to the command:

```sh
$ brew versions cmake
cmake 3.2.3    2b43509 Library/Formula/cmake.rb
cmake 3.2.2    a5392d6 Library/Formula/cmake.rb
...
```

Each output line shows the formula name, version (including any revisions),
last commit to touch the formula at this version and the Formula filepath
(relative to `HOMEBREW_REPOSITORY`).

A complete history of the version/commits touching the formula may be
viewed by passing the `--all` argument. This can be useful for resolving
potential conflicts caused by version reverts or merges from Homebrew to
Linuxbrew as the merge commit may not show as the one where the version changed.

## ``brew-cadfael-bootstrap-toolchain.rb``
Installs needed and recommended compiler/development tools:

- Linux Only
  - GCC 4.9
  - patchelf
- All Platforms
  - python
  - cmake
  - ninja
  - git-flow-avh

GCC is only installed if the system does not provide GCC 4.9 or better. GCC in
this tap is supplied as a versioned formulae to allow easier future upgrades,
and the system compiler is preferred if possible to give the
simplest integration.

This command is used instead of a formula as Homebrew doesn't directly support
"dependency only" formulae, and we also want precise control over the
installation order.
