class SuperluDistOpenblas < Formula
  desc "Distributed LU factorization for large linear systems"
  homepage "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/"
  url "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/superlu_dist_5.1.0.tar.gz"
  sha256 "30ac554a992441e6041c6fb07772da4fa2fa6b30714279de03573c2cad6e4b60"

  keg_only "so it can be installed alongside the default non-openblas version"

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "openblas"
  depends_on "open-mpi"
  depends_on "parmetis-openblas"

  def install
    # prevent linking errors on linuxbrew:
    ENV.deparallelize

    dylib_ext = OS.mac? ? "dylib" : "so"

    cmake_args = std_cmake_args
    cmake_args << "-DTPL_PARMETIS_LIBRARIES=#{Formula["parmetis-openblas"].opt_lib}/libparmetis.#{dylib_ext};#{Formula["metis"].opt_lib}/libmetis.#{dylib_ext}"
    cmake_args << "-DTPL_PARMETIS_INCLUDE_DIRS=#{Formula["parmetis-openblas"].opt_include};#{Formula["metis"].opt_include}"
    cmake_args << "-DCMAKE_C_FLAGS=-fPIC -O2"
    cmake_args << "-DBUILD_SHARED_LIBS=ON"
    cmake_args << "-DCMAKE_C_COMPILER=mpicc"
    cmake_args << "-DCMAKE_Fortran_COMPILER=mpif90"
    cmake_args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    cmake_args << "-DTPL_BLAS_LIBRARIES=-L#{Formula["openblas"].opt_lib} -lopenblas"

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make"
      system "make", "install"
      system "make", "test"
    end

    doc.install "DOC/ug.pdf"
    pkgshare.install "EXAMPLE"
  end

  test do
    cp pkgshare/"EXAMPLE/dcreate_matrix.c", testpath
    cp pkgshare/"EXAMPLE/pddrive.c", testpath
    cp pkgshare/"EXAMPLE/g20.rua", testpath
    system "mpicc", "-o", "pddrive", "pddrive.c", "dcreate_matrix.c", "-L#{Formula["superlu_dist"].opt_lib}", "-lsuperlu_dist"
    system "mpirun", "-np", "4", "./pddrive", "-r", "2", "-c", "2", "g20.rua"
  end
end
