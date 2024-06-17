set -ex

mkdir build
cd build

# vigra headers use std::bind1st, which is deprecated in clang9
if [[ ${target_platform} =~ osx-64.* ]]; then
    export CXXFLAGS="${CXXFLAGS-} -D_LIBCPP_ENABLE_CXX17_REMOVED_FEATURES -Wno-register"
fi

# Combine both if statements into one
if [[ ${target_platform} == "linux-ppc64le" || ${target_platform} == "linux-aarch64" ]]; then
    ENABLE_OPENCL=OFF
else
    ENABLE_OPENCL=ON
fi

cmake ${CMAKE_ARGS} \
    -DCMAKE_BUILD_TYPE="Release"                                          \
    -DCMAKE_PREFIX_PATH=${PREFIX}                                         \
    -DCMAKE_INSTALL_PREFIX=${PREFIX}                                      \
    -DENABLE_OPENMP=ON                                                    \
    -DENABLE_OPENCL=${ENABLE_OPENCL}                                      \
    ..

make -j${CPU_COUNT}
make install
