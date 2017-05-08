# Homebrew tap for SuperNEMO
Custom Formulae and Commands for SuperNEMO's [cadfaelbrew fork](https://github.com/SuperNEMO-DBD/cadfaelbrew) of
Linux/Homebrew. Though designed for use with cadfaelbrew, it should work and be compatible with upstream Homebrew (macOS)
modulo version dependencies on Formulae supplied in this tap. Co-working with Linuxbrew is not yet supported.

# Quickstart
To install brew and the needed development tools for the SuperNEMO software, simply do

```
$ git clone https://github.com/SuperNEMO-DBD/brew.git cadfaelbrew
$ cd cadfaelbrew
$ ./bin/brew cadfael-bootstrap
```

The `cadfael-bootstrap` command will check for system prerequisites, and inform you of any
missing system packages and how to install these. This step is only done for the following systems:

- RHEL/CentOS/Scientific Linux 6/7
- Ubuntu Linux 14.04LTS/16.04LTS
- macOS 10.10/11/12(Mavericks/El Capitan/Sierra)

Running on a non-supported system will still proceed, but you may encounter issues (see [Troubleshooting](#troubleshooting)).
As the bootstrap step may include the install of the GCC compiler, it will take
some time to complete.

Once bootstrapping is completed, the main [Falaise](https://github.com/supernemo-dbd/Falaise) software for SuperNEMO
may be installed and tested:

```
$ ./bin/brew install falaise
$ ./bin/brew test falaise
```

As above, this will take some time to complete due to the need to install large dependencies
such as CERN ROOT and Geant4. Should any step fail to complete, see the [Troubleshooting Guide](#troubleshooting)
for help.

Once installed, no specific environment settings should be required, but you may wish to set
`PATH`, `MANPATH` and `INFOPATH` so that programs and documentation can be run/read without
using absolute paths. For example, if you have installed `brew` in `$HOME/cadfaelbrew`, add

```
export PATH=$HOME/cadfaelbrew/bin:$PATH
export MANPATH=$HOME/cadfaelbrew/share/man:$MANPATH
export INFOPATH=$HOME/cadfaelbrew/share/info:$INFOPATH
```

to your `sh` profile or rc file (e.g. `.bashrc` for the Bash shell). For C-shell, use the
`setenv` equivalents, e.g. `setenv PATH $HOME/cadfaelbrew/bin:$PATH`, in your `.(t)cshrc`
file.

Once installed, documentation on using Falaise is [available online](https://supernemo-dbd.github.io/Falaise)
and with the offline installation. In the later case, this is installed under the `share/Falaise-3.0.0/Documentation/API/html`
subdirectory of your `brew` installation. To view it, simply point your web browser to the `index.html` file
under that directory.

If you wish to contribute to Falaise development, information is available on the [project page](https://github.com/supernemo-dbd/Falaise).

## Use with existing Home/Linuxbrew Installations
If you have an existing Homebrew (macOS) install, this tap may be used directly if you don't have existing brewed versions
of Qt, Boost, CERN ROOT and Geant4. In this case, you simply need to add this tap and then follow the bootstrap/install
proceedure:

```
$ brew tap supernemo-dbd/cadfael
$ brew tap-pin supernemo-dbd/cadfael
$ brew cadfael-bootstrap-toolchain
$ brew install falaise
$ brew test falaise
```

If you see issues in the last two steps, review the [list of Formulae supplied by this tap](#supplied-formulae) and
remove any listed here and rerun `brew install falaise`.

Use this tap with an existing Linuxbrew installation is currently not supported as there may be ABI
incompatibilities between Linuxbrew's install of gcc/glibc/libstdc++ and the requirement for C++11 . On Linux,
it's therefore recommended to use SuperNEMO's fork of brew as described at the start of this section.

# Upgrading

In general, upgrading packages in `brew` should be a simple case of running

```
$ brew update
$ brew upgrade
```

If you have an existing install of `falaise` version 2 or below (run `brew info falaise` to get this information),
then the following steps are needed to upgrade to version 3:

```
$ brew unlink root5
$ brew rm falaise bayeux
$ brew update
$ brew upgrade
```

# Troubleshooting

Whilst Falaise is tested on the supported platforms listed above, it cannot cover all possible
system configurations or setups. The sections below list the most common issues, but
if these do not solve the problem or if you are in any doubt, [raise an issue](https://github.com/supernemo-dbd/homebrew-cadfael/issues).

## Missing System Requirements

Both `brew` and the `homebrew-cadfael` tap require a base set of system packages. Missing packages
on the supported platforms will be identified by running `brew cadfael-bootstrap`, and the error
message will give instructions on the commands needed to install whats's needed. If you do
not have the needed permissions on your system (`root` or `sudo`), request an administrator to
add them. All requirements are distributed and signed either by the vendor or CERN, so there should
be no issue with adding them.

On non-supported systems no checks are performed as the list of packages isn't known. The list of requirements
for Ubuntu 16.04 is listed below and may be used as a guide to what programs, headers and libraries
are needed:

- `lsb-release`
- `iputils-ping`
- `build-essential`
- `curl`
- `file`
- `git`
- `ruby`
- `m4`
- `libbz2-dev`
- `libcurl4-openssl-dev`
- `libexpat1-dev`
- `libncurses5-dev`
- `texinfo`
- `zlib1g-dev`
- `libx11-dev`
- `libxpm-dev`
- `libxft-dev`
- `libxext-dev`
- `libpng12-dev`
- `libjpeg-dev`
- `libegl1-mesa-dev`
- `libgl1-mesa-dev`
- `libglu1-mesa-dev`
- `libgles2-mesa-dev`

In general, formulae will fail to configure or build should a system requirement be missing.
We'll make every effort to support other systems, so please [raise an issue](https://github.com/supernemo-dbd/homebrew-cadfael/issues) if you need help here. However, all work in this case will only be on a
best effort basis.

## Formulae Fail to Install

On supported platforms, installation failures may occur if you have the `PATH`
and `LD_LIBRARY_PATH` (or `DYLD_LIBRARY_PATH` on macOS) environment variables containing
any custom installed software other than `brew` itself. Though `brew` is quite good at building and installing
in a pristine environment, it is best to use it within a default setup.

Generally, it is `LD_LIBRARY_PATH` (or `DYLD_LIBRARY_PATH` on macOS) that cause the
issue, so ensure these are unset.


# Supplied Formulae
## Core
Formulae from this tap are preferred over those in the `homebrew-core` tap.
Installing the ``falaise`` formula will install the core SuperNEMO software packages

- Bayeux C++ Core Foundation Library
- Falaise C++ Simulation/Reconstruction/Analysis Applications

plus their upstream dependencies:

- [Boost](http://www.boost.org)
- [ROOT](https://root.cern.ch)
- [CAMP](https://github.com/tegesoft/camp)
- [CLHEP](http://proj-clhep.web.cern.ch/proj-clhep/)
- [XercesC](http://xerces.apache.org/xerces-c/)
- [Geant4](http://geant4.cern.ch)
- [Doxygen](http://www.stack.nl/~dimitri/doxygen/)
- [Qt5](http://doc.qt.io/qt-5/)

## Development
Several additional Formulae are provided which are not installed by default. These are intended for
use by Bayeux/Falaise developers to integrate new functionality or move to newer, API incompatible,
versions of dependent packages.

- [Ponder](https://github.com/billyquith/ponder)
  - Note: This replaces the [CAMP]() package
- [Falaise_ParticleIdentification](https://github.com/xgarrido/ParticleIdentification)
  - Particle Identification plugin module for Falaise reconstruction/analysis

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
