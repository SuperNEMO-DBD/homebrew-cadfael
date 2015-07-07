require 'formula'

class UniversalPython < Requirement
  satisfy(:build_env => false) { archs_for_command("python").universal? }

  def message; <<-EOS.undent
    A universal build was requested, but Python is not a universal build

    Boost compiles against the Python it finds in the path; if this Python
    is not a universal build then linking will likely fail.
    EOS
  end
end

class UniversalPython3 < Requirement
  satisfy(:build_env => false) { archs_for_command("python3").universal? }

  def message; <<-EOS.undent
    A universal build was requested, but Python 3 is not a universal build

    Boost compiles against the Python 3 it finds in the path; if this Python
    is not a universal build then linking will likely fail.
    EOS
  end
end

class Boost < Formula
  homepage 'http://www.boost.org'
  url 'https://downloads.sourceforge.net/project/boost/boost/1.55.0/boost_1_55_0.tar.bz2'
  sha1 'cef9a0cc7084b1d639e06cd3bc34e4251524c840'
  revision 2

  head 'https://github.com/boostorg/boost.git'

  bottle do
    cellar :any
    revision 4
    sha1 "81b8843487a6f0017fac77b4bf58bdc20f3298fa" => :mavericks
    sha1 "40089f76eddb25ac418032fa0055b6f0b6d76847" => :mountain_lion
    sha1 "da4fb2a221fd83f50741f757eefe4bc38b5e910c" => :lion
  end

  env :userpaths

  option :universal
  option 'with-icu', 'Build regexp engine with icu support'
  option 'with-single', 'Enable building single-threading variant'
  option 'with-static', 'Enable building static library variant'
  option 'with-mpi', 'Build with MPI support'
  option :cxx11

  depends_on :python => :optional
  depends_on :python3 => :optional
  depends_on UniversalPython if build.universal? and build.with? "python"
  depends_on UniversalPython3 if build.universal? and build.with? "python3"

  if build.with?("python3") && build.with?("python")
    odie "boost: --with-python3 cannot be specified when using --with-python"
  end

  if build.with? 'icu'
    if build.cxx11?
      depends_on 'icu4c' => 'c++11'
    else
      depends_on 'icu4c'
    end
  end

  if build.with? 'mpi'
    if build.cxx11?
      depends_on 'open-mpi' => 'c++11'
    else
      depends_on :mpi => [:cc, :cxx, :optional]
    end
  end

  stable do
    # Patches boost::atomic for LLVM 3.4 as it is used on OS X 10.9 with Xcode 5.1
    # https://github.com/Homebrew/homebrew/issues/27396
    # https://github.com/Homebrew/homebrew/pull/27436
    patch :p2 do
      url "https://github.com/boostorg/atomic/commit/6bb71fdd.diff"
      sha1 "ca8679011d5293a7fd02cb3b97dde3515b8b2b03"
    end

    patch :p2 do
      url "https://github.com/boostorg/atomic/commit/e4bde20f.diff"
      sha1 "b68f5536474c9f543879698299bd4975538a89eb"
    end

    # Patch fixes upstream issue reported here (https://svn.boost.org/trac/boost/ticket/9698).
    # Will be fixed in Boost 1.56 and can be removed once that release is available.
    # See this issue (https://github.com/Homebrew/homebrew/issues/30592) for more details.

    patch :p2 do
      url "https://github.com/boostorg/chrono/commit/143260d.diff"
      sha1 "2600214608e7706116831d6ffc302d099ba09950"
    end

    # Patch boost::serialization for Clang
    # https://svn.boost.org/trac/boost/ticket/8757
    patch :p1 do
      url "https://gist.githubusercontent.com/philacs/375303205d5f8918e700/raw/d6ded52c3a927b6558984d22efe0a5cf9e59cd8c/0005-Boost.S11n-include-missing-algorithm.patch"
      sha1 "a37552d48e5c1c0507ee9d48fb82a3fa5e3bc9fa"
    end
  end

  fails_with :llvm do
    build 2335
    cause "Dropped arguments to functions when linking with boost"
  end

  def install
    # https://svn.boost.org/trac/boost/ticket/8841
    if build.with? 'mpi' and build.with? 'single'
      raise <<-EOS.undent
        Building MPI support for both single and multi-threaded flavors
        is not supported.  Please use '--with-mpi' together with
        '--without-single'.
      EOS
    end

    if build.cxx11? and build.with? 'mpi' and (build.with? 'python' \
                                               or build.with? 'python3')
      raise <<-EOS.undent
        Building MPI support for Python using C++11 mode results in
        failure and hence disabled.  Please don't use this combination
        of options.
      EOS
    end

    ENV.universal_binary if build.universal?

    # Force boost to compile using the appropriate GCC version.
    open("user-config.jam", "a") do |file|
      if OS.mac?
        file.write "using darwin : : #{ENV.cxx} ;\n"
      else
        file.write "using gcc : : #{ENV.cxx} ;\n"
      end
      file.write "using mpi ;\n" if build.with? 'mpi'

      # Link against correct version of Python if python3 build was requested
      if build.with? 'python3'
        py3executable = `which python3`.strip
        py3version = `python3 -c "import sys; print(sys.version[:3])"`.strip
        py3prefix = `python3 -c "import sys; print(sys.prefix)"`.strip

        file.write <<-EOS.undent
          using python : #{py3version}
                       : #{py3executable}
                       : #{py3prefix}/include/python#{py3version}m
                       : #{py3prefix}/lib ;
        EOS
      end
    end

    # we specify libdir too because the script is apparently broken
    bargs = ["--prefix=#{prefix}", "--libdir=#{lib}"]

    if build.with? 'icu'
      icu4c_prefix = Formula['icu4c'].opt_prefix
      bargs << "--with-icu=#{icu4c_prefix}"
    else
      bargs << '--without-icu'
    end

    # Handle libraries that will not be built.
    without_libraries = []

    # The context library is implemented as x86_64 ASM, so it
    # won't build on PPC or 32-bit builds
    # see https://github.com/Homebrew/homebrew/issues/17646
    if Hardware::CPU.ppc? || Hardware::CPU.is_32_bit? || build.universal?
      without_libraries << "context"
      # The coroutine library depends on the context library.
      without_libraries << "coroutine"
    end

    # Boost.Log cannot be built using Apple GCC at the moment. Disabled
    # on such systems.
    without_libraries << "log" if ENV.compiler == :gcc || ENV.compiler == :llvm
    without_libraries << "python" if (build.without? 'python' \
                                      and build.without? 'python3')
    without_libraries << "mpi" if build.without? 'mpi'

    bargs << "--without-libraries=#{without_libraries.join(',')}"

    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            "-d2",
            "-j#{ENV.make_jobs}",
            "--layout=tagged",
            "--user-config=user-config.jam",
            "install"]

    if build.with? "single"
      args << "threading=multi,single"
    else
      args << "threading=multi"
    end

    if build.with? "static"
      args << "link=shared,static"
    else
      args << "link=shared"
    end

    args << "address-model=32_64" << "architecture=x86" << "pch=off" if build.universal?

    # Trunk starts using "clang++ -x c" to select C compiler which breaks C++11
    # handling using ENV.cxx11. Using "cxxflags" and "linkflags" still works.
    if build.cxx11?
      args << "cxxflags=-std=c++11"
      if ENV.compiler == :clang
        args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++"
      end
    end

    system "./bootstrap.sh", *bargs
    system "./b2", *args
  end

  def caveats
    s = ''
    # ENV.compiler doesn't exist in caveats. Check library availability
    # instead.
    if Dir["#{lib}/libboost_log*"].empty?
      s += <<-EOS.undent

      Building of Boost.Log is disabled because it requires newer GCC or Clang.
      EOS
    end

    if Hardware::CPU.ppc? || Hardware::CPU.is_32_bit? || build.universal?
      s += <<-EOS.undent

      Building of Boost.Context and Boost.Coroutine is disabled as they are
      only supported on x86_64.
      EOS
    end

    s
  end
end
