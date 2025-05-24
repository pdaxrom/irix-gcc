TARGET_INST=/opt/irix-gcc-n32

TARGET_TRIPLET=mips-sgi-irix6n32

BINUTILS_VERSION=2.19.1
BINUTILS_PATCHES="files/binutils-${BINUTILS_VERSION}-irix.diff"
BINUTILS_CONF_OPTS="--enable-lto=no --enable-multilib --libdir=${TARGET_INST}/lib32"
BINUTILS_EXT=bz2

GCC_VERSION=15.1.0
GCC_PATCHES="files/gcc-${GCC_VERSION}-irix.diff files/gcc-${GCC_VERSION}-irix-n32.diff"
#GCC_CONF_OPTS="--disable-libssp --enable-languages=c,c++ --disable-lto --disable-pgo-build --disable-plugins --enable-multilib --disable-werror --enable-maintainer-mode"
GCC_CONF_OPTS="--disable-libssp --enable-languages=c,c++ --disable-lto --disable-pgo-build --disable-plugins --enable-multilib --disable-werror"

GDB_VERSION=7.3.1
