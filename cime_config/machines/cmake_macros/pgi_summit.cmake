if (NOT DEBUG)
  string(APPEND CFLAGS " -O2")
  string(APPEND CXXFLAGS " -O2")
  if (COMP_NAME STREQUAL eam)
    string(APPEND FFLAGS " -O1 -Mnovect -DSUMMITDEV_PGI")
  else()
    string(APPEND FFLAGS " -O2 -DSUMMITDEV_PGI")
  endif()
endif()
if (COMP_NAME STREQUAL cice)
  string(APPEND FFLAGS " -Mnovect")
endif()
string(APPEND SLIBS " -L$ENV{PNETCDF_PATH}/lib -lpnetcdf -L$ENV{HDF5_PATH}/lib -lhdf5_hl -lhdf5 -L$ENV{NETCDF_C_PATH}/lib -lnetcdf -L$ENV{NETCDF_FORTRAN_PATH}/lib -lnetcdff -L$ENV{ESSL_PATH}/lib64 -lessl -L$ENV{OLCF_NETLIB_LAPACK_ROOT}/lib64 -llapack")
set(MPICXX "mpiCC")
set(PIO_FILESYSTEM_HINTS "gpfs")
set(SFC "pgfortran")
set(NETCDF_C_PATH "$ENV{NETCDF_C_PATH}")
set(NETCDF_FORTRAN_PATH "$ENV{NETCDF_FORTRAN_PATH}")
set(PNETCDF_PATH "$ENV{PNETCDF_PATH}")
string(APPEND KOKKOS_OPTIONS " -DKokkos_ARCH_POWER9=On")
