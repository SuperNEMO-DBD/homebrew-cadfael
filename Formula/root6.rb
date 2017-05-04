class Root6 < Formula
  desc "CERN C++ Data Analysis and Persistency Libraries"
  homepage "http://root.cern.ch"
  url "http://root.cern.ch/download/root_v6.08.06.source.tar.gz"
  mirror "https://fossies.org/linux/misc/root_v6.08.06.source.tar.gz"
  version "6.08.06"
  sha256 "ea31b047ba6fc04b0b312667349eaf1498a254ccacd212144f15ffcb3f5c0592"
  head "http://root.cern.ch/git/root.git"

  depends_on "cmake" => :build
  depends_on "gsl" => :recommended
  depends_on "openssl" => :optional
  depends_on "sqlite" => :recommended
  depends_on :python => :recommended
  # For LZMA
  depends_on "xz"

  # For XML on Linux
  depends_on "libxml2" if OS.linux?

  needs :cxx11

  def cmake_opt(opt, pkg = opt)
    "-D#{opt}=#{(build.with? pkg) ? "ON" : "OFF"}"
  end

  def install
    # brew audit doesn't like non-executables in bin
    # so we will move {thisroot,setxrd}.{c,}sh to libexec
    # (and change any references to them)
    inreplace Dir["config/roots.in", "config/thisroot.*sh",
                  "etc/proof/utils/pq2/setup-pq2",
                  "man/man1/setup-pq2.1", "README/INSTALL", "README/README"],
      /bin.thisroot/, "libexec/thisroot"

    mkdir "cmake-build" do
      system "cmake", "..",
        # Disable everything that might be ON by default...
        # minimal/gminimal don't allow override...
        "-Dalien=OFF",
        "-Dasimage=OFF",
        "-Dastiff=OFF",
        "-Dbonjour=OFF",
        "-Dcastor=OFF",
        "-Dchirp=OFF",
        "-Ddavix=OFF",
        "-Ddcache=OFF",
        "-Dfitsio=OFF",
        "-Dgfal=OFF",
        "-Dglite=OFF",
        "-Dgviz=OFF",
        "-Dhdfs=OFF",
        "-Dkrb5=OFF",
        "-Dldap=OFF",
        "-Dmonalisa=OFF",
        "-Dmysql=OFF",
        "-Dodbc=OFF",
        "-Doracle=OFF",
        "-Dpgsql=OFF",
        "-Dpythia6=OFF",
        "-Dpythia8=OFF",
        "-Dqt=OFF",
        "-Drfio=OFF",
        "-Dsapdb=OFF",
        "-Dsrp=OFF",
        # Now the stuff we want
        "-Dfail-on-missing=ON",
        "-Dgnuinstall=ON",
        "-Dexplicitlink=ON",
        "-Drpath=ON",
        "-Dsoversion=ON",
        "-Dbuiltin_asimage=ON",
        "-Dasimage=ON",
        "-Dbuiltin_fftw3=ON",
        "-Dbuiltin_freetype=ON",
        "-Droofit=ON",
        "-Dgdml=ON",
        "-Dminuit2=ON",
        cmake_opt("python"),
        cmake_opt("ssl", "openssl"),
        cmake_opt("sqlite", "sqlite3"),
        cmake_opt("xrootd"),
        cmake_opt("mathmore", "gsl"),
        cmake_opt("tbb"),
        *std_cmake_args
      system "make", "install"
    end

    libexec.mkpath
    mv Dir["#{bin}/*.*sh"], libexec
  end

  def caveats; <<-EOS.undent
    Because ROOT depends on several installation-dependent
    environment variables to function properly, you should
    add the following commands to your shell initialization
    script (.bashrc/.profile/etc.), or call them directly
    before using ROOT.

    For bash users:
      . $(brew --prefix root6)/libexec/thisroot.sh
    For zsh users:
      pushd $(brew --prefix root6) >/dev/null; . libexec/thisroot.sh; popd >/dev/null
    For csh/tcsh users:
      source `brew --prefix root6`/libexec/thisroot.csh
    EOS
  end

  test do
    (testpath/"test.C").write <<-EOS.undent
      #include <iostream>
      void test() {
        std::cout << "Hello, world!" << std::endl;
      }
    EOS
    (testpath/"test.bash").write <<-EOS.undent
      . #{libexec}/thisroot.sh
      root -l -b -n -q test.C
    EOS
    assert_equal "\nProcessing test.C...\nHello, world!\n",
      `/bin/bash test.bash`
  end
end
