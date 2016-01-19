# Homebrew tap for SuperNEMO
Custom Formulae and Commands for SuperNEMO's cadfaelbrew fork of
Linux/Homebrew.

# Quickstart
```
$ brew install cadfael falaise [--c++11]
```

Supply the `--c++11` flag if you want packages compiled against the C++11 Standard.

# Formulae
CadfaelBrew prefers formulae from this tap over those in its core `Library/Formula` directory.
The main formula is `cadfael`, which exists as a pure dependency formulae to install the
base set of software packages:

- Boost
- ROOT
- GSL
- CAMP
- CLHEP
- XercesC
- Geant4
- Doxygen
- Python

On Linux systems, GNU GCC and binutils are also installed to support C++11/14.
GCC is supplied as a versioned formula (plus its core dependencies) to allow 
future upgrades in a (hopefully) seamless manner via use of `keg_only`.

- Current compiler kit:
  - GCC 4.9
  - binutils [from upstream linuxbrew]
- Future compiler kit:
  - GCC 5/6
  - Dependent on ABI changes and defaults

In addition, formulae for the SuperNEMO-DBD specific software are provided:

- Bayeux C++ Core Foundation Library
- Falaise C++ Simulation/Reconstruction/Analysis Applications

All C++ based Formulae versions use the C++98 standard. However, they may be
compiled against the C++11 standard by passing the `--c++11` flag when installing, e.g.

```
$ brew install cadfael --c++11
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

