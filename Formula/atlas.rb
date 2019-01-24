class Atlas < Formula
  desc "Automatically Tuned Linear Algebra Software (BLAS implementation)"
  homepage "http://math-atlas.sourceforge.net/"
  url "https://sourceforge.net/projects/math-atlas/files/Stable/3.10.3/atlas3.10.3.tar.bz2"
  sha256 "2688eb733a6c5f78a18ef32144039adcd62fabce66f2eb51dd59dde806a6d2b7"

  devel do
    url "https://sourceforge.net/projects/math-atlas/files/Developer%20%28unstable%29/3.11.41/atlas3.11.41.tar.bz2"
    sha256 "477d567a8d683e891d786e9e8bb6ad6659daa9ba18e8dd0e2f70b7a54095f8de"
  end

  keg_only :provided_by_macos,
           "macOS provides BLAS and LAPACK in the Accelerate framework"  

  # ATLAS authors "strongly recommend GNU gcc over Clang/LLVM".
  # We need gcc for gfortran anyway.
  depends_on "gcc"

  resource "lapack" do
    url "http://www.netlib.org/lapack/lapack-3.8.0.tar.gz"
    sha256 "12334"
  end

  def install
    mkdir "build" do
      lapack = resource("lapack").fetch

      ENV.deparallelize
      system "../configure",
        "--prefix=#{prefix}",
        "-D", "c", "-DWALL",
        "--shared",
        "--with-netlib-lapack-tarfile=#{lapack}",
        "-v", "2"

      system "make", "--print-directory"
      system "make", "check"
      system "make", "ptcheck"
      system "make", "time"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.f90").write <<~EOS
    program main
      print *, 'Hello, world!'
    end program main
    EOS
    system "gfortran", "-o", "test", "test.f90",
      "-L#{lib}", "-llapack", "-lblas"
    system "./test"
  end
end
