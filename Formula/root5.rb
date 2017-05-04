class Root5 < Formula
   homepage "http://root.cern.ch"

   stable do
     version "5.34.36"
     sha256 "fc868e5f4905544c3f392cc9e895ef5571a08e48682e7fe173bd44c0ba0c7dcd"
     url "https://root.cern.ch/download/root_v#{version}.source.tar.gz"
     mirror "http://ftp.riken.jp/pub/ROOT/root_v#{version}.source.tar.gz"
   end
   revision 1

   head do
     url "https://github.com/root-mirror/root.git", :branch => "v5-34-00-patches"
   end

   keg_only "Conflicts with production version ROOT6"

   depends_on "cmake" => :build
   option :cxx11

   depends_on "openssl"
   depends_on "gsl" => :recommended
   depends_on :python => :recommended

   def install
     # When building the head, temp patch for ROOT-8032
     if build.head? || build.devel?
       inreplace "cmake/modules/RootBuildOptions.cmake", "thread|cxx11|cling|builtin_llvm|builtin_ftgl|explicitlink", "thread|cxx11|cling|builtin_llvm|builtin_ftgl|explicitlink|python|mathmore|asimage|gnuinstall|rpath|soversion|opengl|builtin_glew"
     end

     mkdir "hb-build-root" do
       ENV.cxx11 if build.cxx11?

       # Defaults
       args = std_cmake_args
       args << "-Dgnuinstall=ON"
       args << "-DCMAKE_INSTALL_SYSCONFDIR=etc/root"
       args << "-Dgminimal=ON"
       args << "-Dx11=OFF" if OS.mac?
       args << "-Dcocoa=ON" if OS.mac?
       args << "-Dlibcxx=ON" if OS.mac?
       args << "-Dfortran=OFF"
       args << "-Drpath=ON"
       args << "-Dsoversion=ON"
       args << "-Dasimage=ON"
       args << "-Dbuiltin_asimage=ON"
       args << "-Dbuiltin_freetype=ON"
       args << "-Dopengl=ON"
       args << "-Dbuiltin_glew=ON"

       # Options
       args << "-Dcxx11=ON" if build.cxx11?
       args << "-Dpython=".concat((build.with? "python") ? "ON" : "OFF")
       args << "-Dmathmore=".concat((build.with? "gsl") ? "ON" : "OFF")

       system "cmake", "../", *args
       system "make"
       system "make", "install"
     end
   end
end

