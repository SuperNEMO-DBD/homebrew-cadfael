class Geant4 < Formula
  homepage "http://geant4.cern.ch"
  url "http://geant4.cern.ch/support/source/geant4.9.6.p04.tar.gz"
  version "9.6.4"
  sha256 "997220a5386a43ac8f533fc7d5a8360aa1fd6338244d17deeaa583fb3a0f39fd"
  revision 1

  patch do
    url "https://files.warwick.ac.uk/supernemo/files/Cadfael/distfiles/geant4-9.6.4-data-export.patch"
    sha256 "6d7b50f504b53c924dfae28562726b839e191c4c78139dfa33040dfd460aebed"
  end

  depends_on "cmake" => :build
  depends_on "clhep"
  depends_on "xerces-c" => :recommended

  def install
    mkdir 'geant4-build' do
      args = std_cmake_args
      args << "-DCMAKE_INSTALL_LIBDIR=lib"
      args << "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
      args << "-DGEANT4_INSTALL_DATA=ON"
      args << "-DGEANT4_USE_SYSTEM_CLHEP=ON"
      args << "-DGEANT4_USE_SYSTEM_EXPAT=ON"
      #args << "-DGEANT4_USE_SYSTEM_ZLIB=ON"

      args << "-DGEANT4_USE_GDML=ON" if build.with? "xerces-c"

      system "cmake", "../", *args
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
