set -ex

mkdir build
cd build

# vigra headers use std::bind1st, which is deprecated in clang9
if [[ ${target_platform} =~ osx-64.* ]]; then
    export CXXFLAGS="${CXXFLAGS-} -D_LIBCPP_ENABLE_CXX17_REMOVED_FEATURES -Wno-register"
fi

# Use of clock_gettime requires librt on platforms with glibc < v2.17
if [[ ${target_platform} =~ .*linux.* ]]; then
    # we need lindl for dynamic loading on linux
    # not sure how to submit patches upstsream....
    export LDFLAGS="-ldl -lrt -Wl,--as-needed"
fi

cmake ${CMAKE_ARGS} \
    -DCMAKE_BUILD_TYPE="Release"                                          \
    -DCMAKE_PREFIX_PATH=${PREFIX}                                         \
    -DCMAKE_INSTALL_PREFIX=${PREFIX}                                      \
    -DENABLE_OPENMP=ON                                                    \
    -DENABLE_OPENCL=ON                                                    \
    ..

make -j${CPU_COUNT}
make install
