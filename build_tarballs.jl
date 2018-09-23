# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "Minuit2Builder"
version = v"0.0.1"

# Collection of sources required to build Minuit2Builder
sources = [
    "https://github.com/jstrube/Minuit2.git" =>
    "32b4337fab6aca8cde5a0e18dfd9e05130eb7184",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain ../Minuit2
VERBOSE=ON cmake --build . --config Release --target install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, libc=:glibc)
]

platforms = expand_gcc_versions(platforms)

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libMinuit2", Symbol(""))
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

