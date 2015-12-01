# Homebrew tap for SuperNEMO
Custom Formulae and Commands for SuperNEMO's cadfaelbrew fork of
Linux/Homebrew.

# Quickstart
```
$ brew install cadfael falaise
```

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

In addition, formulae for the SuperNEMO-DBD specific software are provided:

- Bayeux C++ Core Foundation Library
- Falaise C++ Simulation/Reconstruction/Analysis Applications


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
Linuxbrew.

