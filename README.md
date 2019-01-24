# SuperNEMO-DBD/cadfael

Formulae for installing the [SuperNEMO experiment's](https://supernemo.org) offline software,
including runtime and software development kits, using the [Homebrew](https://brew.sh)/[Linuxbrew](https://linuxbrew.sh)
package managers. The software may be installed either natively on Linux/macOS,
or as a Singularity/Docker Image on any platform supporting Singularity/Docker.

The current C++/Python Toolchain comprises GCC 7 (Linux) or Apple LLVM (macOS),
Python 2.7, and all C++ binaries compiled against the ISO C++11 Standard. Data
persistency uses the ROOT 6 format.

# Prerequisites
For both native and image installs, your system will require 4GB of disk
space, plus a working network connection during installation to download
sources and binaries. We recommend use of image installs on Linux
systems that supply and support Singularity, and native from-source
builds otherwise (for example on macOS laptops). Both provide an identical
set of software, but images are easier, faster, and more reliable to both
install and use.


## For Native Installs
The following Linux or macOS base systems are required
for native installs:

- CentOS/Scientific/RedHat Linux 6 and 7
  - At a terminal prompt, run (or ask your friendly neighbourhood sysadmin to run):

  ```
  $ sudo yum install curl gcc gcc-c++ git make which libX11-devel libXext-devel libXft-devel libXpm-devel mesa-libGL-devel mesa-libGLU-devel perl-Data-Dumper perl-Thread-Queue
  ```

- Ubuntu Linux 16.04LTS, 18.04LTS
  - At a terminal prompt, run (or ask your friendly neighbourhood sysadmin to run):

  ```
  $ sudo apt-get install ca-certificates curl file g++ git locales make uuid-runtime libx11-dev libxpm-dev libxft-dev libxext-dev libglu1-mesa-dev flex texinfo
  ```

- macOS Sierra, High Sierra, or Mojave
  - Install [Xcode](https://developer.apple.com/xcode/) from the [App Store](https://itunes.apple.com/gb/app/xcode/id497799835?mt=12).


Linux distributions other than the above are not officially supported
or tested. Those derived from CentOS 7 or Ubuntu 18.04 (Debian buster/sid)
with the above package sets (or equivalent) should provide the necessary
base system.


## For Image Installs
To install images and run them in containers, either [Singularity](https://www.sylabs.io/singularity/)(Linux only)
or [Docker](https://www.docker.com)(Linux, macOS or Windows) is required.
For Docker on macOS or Windows, you will also require an X11 server if
a graphical interface is needed (*Use of this is not yet documented*).

If you are using a centrally managed Linux system, you may have Singularity
installed already (for example, it is available on SuperNEMO's Tier 1 at CC-Lyon).
Simply run

```
$ singularity --version
2.6.1-dist
```

to see if it is available. Otherwise, installation instructions are available
from the [Singularity Documentation](https://www.sylabs.io/guides/2.6/user-guide/index.html)
(note that this *does* require `root/sudo` privileges, so speak to your
friendly neighbourhood sysadmin if that isn't you).

For Docker, you can similarly check availability on your system using

```
$ docker --version
```

Docker is less likely to be present on centrally managed systems as
it requires higher permissions than Singularity. For self-managed machines,
it can be installed following the [Docker CE Guide for your platform](https://docs.docker.com/install/).
Though Docker is available on Linux, we recommend the use of Singularity
on this Platform.


# Quickstart
## Installing Natively
```
$ git clone https://github.com/Linuxbrew/brew.git snemo-sdk
$ eval $(./snemo-sdk/bin/brew shellenv)
$ brew tap SuperNEMO-DBD/cadfael
$ brew snemo-doctor
```

Use of this Tap with an existing Homebrew/Linuxbrew installation is
**not supported** because a coherent install of all packages cannot
be guaranteed. It is likely that you will see some warnings
from `brew snemo-doctor`. Unless this fails with hard errors about
missing system packages, you should proceed to the next step:

```
$ brew snemo-install-sdk
```

This step will take some time to complete as a full suite of development
tools and packages will be built from scratch. If you encounter
any errors here [raise an Issue](https://github.com/SuperNEMO-DBD/homebrew-cadfael/issues/new)
and **supply the requested information**.

Once installation is complete, test the top level `falaise` package:

```
$ brew test falaise
Testing supernemo-dbd/cadfael/falaise
==> /Users/bmorgan/Software/Cadfaelbrew.git/Cellar/falaise/3.3.0/bin/flsimulate -o test.brio
==> /Users/bmorgan/Software/Cadfaelbrew.git/Cellar/falaise/3.3.0/bin/flreconstruct -i test.brio -p urn:snemo:demonstrator:reconstruction:1.0.0 -o test.root
```

This should run successfully without any error, though some warnings may be expected on Linux
about building from source. If an error does occur, please [raise an Issue](https://github.com/SuperNEMO-DBD/homebrew-cadfael/issues/new).

## Installing Images
Using Singularity:

```
$ singularity pull docker://supernemo/falaise
WARNING: pull for Docker Hub is not guaranteed to produce the
WARNING: same image on repeated pull. Use Singularity Registry
WARNING: (shub://) to pull exactly equivalent images.
Docker image path: index.docker.io/supernemo/falaise:latest
...
WARNING: Building container as an unprivileged user. If you run this container as root
WARNING: it may be missing some functionality.
Building Singularity image...
Singularity container built: ./falaise.simg
Cleaning up...
Done. Container is at: ./falaise.simg
$ ls
falaise.simg
```

The resultant `falaise.simg` image file contains everything you need to
run the offline software, and can be stored anywhere on your system. In the following, we assume
it is located in the current working directory, but if not simply supply
the full path to the image file. To cross check the image is o.k. and
your local Singularity setup, run

```
$ singularity exec falaise.simg brew test falaise
WARNING: Not mounting current directory: user bind control is disabled by system administrator
WARNING: Non existent mountpoint (directory) in container: '/var/singularity/mnt/final/storage'
error: could not lock config file /opt/supernemo/Homebrew/.git/config: Read-only file system
Testing supernemo-dbd/cadfael/falaise
==> /opt/supernemo/Cellar/falaise/3.3.0/bin/flsimulate -o test.brio
==> /opt/supernemo/Cellar/falaise/3.3.0/bin/flreconstruct -i test.brio -p urn:snemo:demonstrator:reconstruction:1.0.0 -o test.root
$
```

The exact output you see will depend on the local Singularity configuration
and the current production release. As long as you see the last two lines
and no subsequent errors, things should be o.k. By default, Singularity pulls the `latest`
image tag, which always contains the current production release.


Using Docker:

```
$ docker pull supernemo/falaise
latest: Pulling from supernemo/falaise
...
Digest: sha256:cf39166b250e91becf7a0bfcaa1c28152a07afddd8acf788e7d3289f6b5544aa
Status: Downloaded newer image for supernemo/falaise:latest
```

Docker will manage the image files for you, and their state can
be checked at any time by running

```
$ docker images
```

As with Singularity, the `falaise` package should be tested:

```
$ docker run --rm supernemo/falaise brew test falaise
Warning: Calling HOMEBREW_BUILD_FROM_SOURCE is deprecated! Use --build-from-source instead.
Testing supernemo-dbd/cadfael/falaise
==> /opt/supernemo/Cellar/falaise/3.3.0/bin/flsimulate -o test.brio
==> /opt/supernemo/Cellar/falaise/3.3.0/bin/flreconstruct -i test.brio -p urn:snemo:demonstrator:reconstruction:1.0.0 -o test.root
$
```

The value you see for the `sha256` digest when pulling and the versions on the test
output will depend on the current production release. As with Singularity the `pull`
command downloads the default `latest` tag which always points to the current production release.


# Using the Offline Software Environment
For both native and image installs, the primary way to use the offline
software is to start a shell session which configures access to the
applications and all the tools needed to develop them.
We defer instructions on the use and development of the applications *themselves*
to those on [the offline project page](https://github.com/supernemo-dbd/Falaise).
Here we simply demonstrate how to start up the interactive shell session.

With native installs, a new shell session configured with the applications
and needed development tools is started using the `snemo-sh` subcommand
of `brew`:

```
$ $HOME/snemo-sdk/bin/brew snemo-sh
...
falaise> flsimulate --help

```

Use `exit` to close the session and return to a standard environment.
Whilst `snemo-sh` makes every effort to sanitize the environment, you
may have issues if you either start it from an already complex setup,
or if you further modify environment variables whilst in the shell.
It's recommended to add an alias in your shell's configuration file to
simplify starting up the shell session, for example

``` bash
alias snemo-session="$HOME/snemo-sdk/bin/brew snemo-sh"
```

Images may be used in a similar way, but starting a session is a
two step process. For Singularity, we use the [`shell` subcommand](https://www.sylabs.io/guides/2.6/user-guide/appendix.html#shell)
to start a bash shell in a container running the image, then start the `snemo-sh` session in this:

```
$ singularity shell falaise.simg
...
Singularity: Invoking an interactive shell within container...

Singularity falaise.simg:~> brew snemo-sh
...
falaise> flsimulate --help
...
falaise> exit
Singularity falaise.simg:~> exit
$
```

As with native installs, be extremely careful if you have highly custom or
complex environment settings, as these will be exported into the running
container and may result in errors (for example, you refer to a path which does
not exist in the image). Note the use of **two** `exit` commands here, one to exit the `snemo-sh`
session, and one to exit the container running the image. In this sense,
images behave much like a remote login session or virtual machine.
Whilst the exact behaviour inside the Container will depend on how your Singularity
install has been set up, you should at least have full read-write access to files
on your `$HOME` and `$TMP` areas on the machine running Singularity, and be able
to start graphical programs like ROOT and `flvisualize`.

You can also directly execute programs in the image using the [`exec`
subcommand](https://www.sylabs.io/guides/2.6/user-guide/appendix.html#exec-command),
e.g.

```
$ singularity exec falaise.simg flsimulate --help
...
```

Much more is possible with Singularity, with a very clear and detailed
overview available in its [online documentation](https://www.sylabs.io/guides/2.6/user-guide/index.html).


Docker images can be run either interactively:

```
$ docker run --rm -it supernemo/falaise
falaise> brew snemo-sh
...
falaise> flsimulate --help
...
falaise> exit
falaise> exit
$
```

or just to execute a command:

```
$ docker run --rm supernemo/falaise flsimulate --help
...
```

The most important distinction from Singularity is that you
**do not** have access to your `$HOME` area or other filesystems
inside the running container. Various ways are available to share
data between the host system and container, and we defer to
the [Docker documentation on this subject](https://docs.docker.com/storage/).



# Installing Additional Packages
If your work requires software packages not present in the installation,
you can install them through `brew` **if** Formulae for them exist. Note
that at present this functionality is only supported for native installs.
Use the `search` subcommand to see if the package is available:

```
$ brew search <string>
```

If no results are returned, you can request it to be added to this tap
[through an Issue](https://github.com/SuperNEMO-DBD/homebrew-cadfael/issues/new),
or you can write the Formula and submit it as a Pull Request.


If the package you need is Python-based and available through PyPi, then you
should install it using `virtualenv` and `pip` supplied with the offline
install's Python. Note here that `virtualenv` **can** be used inside a
container.

In both cases, please keep your Working Group Coordinators informed so
that dependencies and requirements for deployment can be tracked. Failure
to do so may result in delays in your work being integrated into the
production releases.


# Keeping the Offline Software Updated
All offline software packages are installed using the current release
versions approved for production work. These must be used for all simulation,
processing, and analysis production tasks. Thus you should in general
**only update when a new release is announced**.

For native installs, updating the software is done with the `snemo-update`
command

```console
$ brew snemo-update
```

This will update the Homebrew installation itself, and then upgrade
any packages for new versions are available.

For images, simply follow the same procedure as documented for
installation. For Singularity, you can either overwrite your existing
image file or create a new one.


# Extension Commands for `brew`
The following subcommands for `brew` are available once this repository
is tapped

## `snemo-doctor`
Runs a series of checks on the system and installation, warning if anything
may cause issues with installing or using packages.

## `snemo-sh`
Starts a new shell session in which the environment is configured for
using and developing the offline software.

## `snemo-install-sdk`
Installs the offline software stack from scratch into a clean Homebrew install.
It will fail if any Formulae are already installed as it cannot guarantee a
clean build otherwise.

## `snemo-update`
Updates Homebrew code and Formula definitions before upgrading any outdated
packages to latest stable versions.

## `snemo-formula-history`
SuperNEMO-supplied implementation of the old `versions` subcommand.
It is retained to help in preparing versioned snapshots.

```sh
$ brew snemo-formula-history cmake
cmake 3.13.3   8835fde8b77 homebrew/core Formula/cmake.rb
cmake 3.13.2   a712c28df66 homebrew/core Formula/cmake.rb
...
```

Each output line shows the formula name, version (including any revisions),
last commit to touch the formula at this version, the Tap hosting the Formula,
and the path to the Formula relative to the Tap root.

A complete history of the version/commits touching the formula may be
viewed by passing the `--all` argument. This can be useful for resolving
potential conflicts caused by version reverts or merges from Homebrew to
Linuxbrew as the merge commit may not show as the one where the version changed.



