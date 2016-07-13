class Igprof < Formula
  desc "The Ignominous Profiler"
  homepage "http://igprof.org"
  url "https://github.com/igprof/igprof/archive/v5.9.16.tar.gz"
  version "5.9.16"
  sha256 "cc977466b310f47bbc2967a0bb6ecd49d7437089598346e3f1d8aaf9a7555d96"

  depends_on "cmake" => :build
  depends_on "libatomic_ops"
  depends_on "libunwind"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"vvvi-build-and-copy.cc").write <<-EOS.undent
      // Store in a file vvvi-build-and-copy.cc
      // Compile: c++ -o vvvi-build-and-copy vvvi-build-and-copy.cc -ldl -lpthread
      #include <vector>
      #include <string>
      #include <dlfcn.h>

      int main (int, char **) 
      {
        union { void *ptr; void (*dump)(const char *tofile); } u;
        u.ptr = dlsym(0, "igprof_dump_now");

        typedef std::vector<int> VI;
        typedef std::vector<VI> VVI;
        std::vector<VVI> vvvi, vvvi2;
        for (int i = 0, j, k; i < 10; ++i)
          for (vvvi.push_back(VVI()), j = 0; j < 10; ++j)
            for (vvvi.back().push_back(VI()), k = 0; k < 10; ++k)
              vvvi.back().back().push_back(k);

        if (u.dump) u.dump("|gzip -9c > ig-vvvi-build.gz");

        vvvi2 = vvvi;
        if (u.dump) u.dump("|gzip -9c > ig-vvvi-copy.gz");
        return vvvi2.size();
      }
    EOS
    system ENV.cxx, "-o", "vvvi-build-and-copy", 
           testpath/"vvvi-build-and-copy.cc", "-ldl", "-lpthread"
    begin
      system "#{bin}/igprof", "-mp", "-z", "-o", "ig-vvvi-build-and-copy.gz",
             "./vvvi-build-and-copy"
    rescue
      puts "igprof emits a funky exit code that brew doesn't understand but is o.k.!"
    end
    system "#{bin}/igprof-analyse", "-d", "-v", "-g",
           "--demangle",
           "-r", "MEM_TOTAL",
           "ig-vvvi-build-and-copy.gz"
  end
end
