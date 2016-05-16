require "formula"

class Qt5Base < Formula
  homepage "http://qt-project.org/"
  url "http://download.qt.io/official_releases/qt/5.6/5.6.0/submodules/qtbase-opensource-src-5.6.0.tar.gz"
  sha256 "3004d5e20413edcc763d5efeebcde6785fec863d904c77c8d87885c6eeb8a70c"

  keg_only "Qt5 conflicts with the more widely used Qt4"
  conflicts_with "qt5", :because => "Core homebrew ships a complete Qt5 install"

  depends_on :xcode => :build if OS.mac?
  depends_on "pkg-config" => :build

  option :cxx11

  def install
    args = ["-prefix", prefix,
            "-opensource",
            "-confirm-license",
            "-release",
            "-nomake", "tests",
            "-nomake", "examples"]

    if build.cxx11?
      args << "-c++11"
    else
      args << "-no-c++11"
    end

    args << "-qt-xcb" if OS.linux?

    system "./configure", *args
    # Cannot parellize build os OSX
    system "make"
    ENV.j1 if OS.mac?
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    We agreed to the Qt opensource license for you.
    If this is unacceptable you should uninstall.
    EOS
  end
end
