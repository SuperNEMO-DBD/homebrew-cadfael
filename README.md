# Homebrew tap for SuperNEMO
Custom Formulae and Commands for SuperNEMO's cadfaelbrew fork of
Linux/Homebrew.

# Quickstart
```
$ brew tap supernemo-dbd/cadfael
$ brew install cadfael falaise [--c++11]
```

Supply the `--c++11` flag if you want packages compiled against the C++11 Standard.

# Formulae
CadfaelBrew prefers formulae from this tap over those in its core `Library/Formula` directory.
The main formula is `cadfael`, which exists as a pure dependency formulae to install the
needed and recommended compiler/development tools:

- Linux Only
  - binutils 
  - GCC 4.9
  - patchelf
- All Platforms
  - ninja

The binutils/GCC combination is only installed if the system does not provide GCC
4.9 or better. GCC in this tap is supplied as a versioned formulae to allow easier
future upgrades, and the system compiler is preferred if possible to give the 
simplest integration.

Installing the falaise formula will install the core SuperNEMO software packages

- Bayeux C++ Core Foundation Library
- Falaise C++ Simulation/Reconstruction/Analysis Applications

plus their upstream dependencies:

- Bayeux
- Boost
- ROOT
- GSL
- CAMP
- CLHEP
- XercesC
- Geant4
- Doxygen
- Python

In addition, formulae for the SuperNEMO-DBD specific software are provided:
All C++ based Formulae versions use the C++98 standard by default. However, they may be
compiled against the C++11 standard by passing the `--c++11` flag when installing, e.g.

```
$ brew install falaise --c++11
```

Note that this is only a convenience to permit testing against the newer
standard - C++11 compatibile code is not allowed in SuperNEMO code until version 3
of Bayeux/Falaise.


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

