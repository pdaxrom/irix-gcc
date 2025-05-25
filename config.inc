TARGET_INST=/opt/irix-gcc-o32

BINUTILS_VERSION=2.19.1
BINUTILS_PATCHES="files/binutils-${BINUTILS_VERSION}-irix.diff"
BINUTILS_CONF_OPTS="--enable-lto=no --enable-multilib"
BINUTILS_EXT=bz2

GCC_VERSION=15.1.0
GCC_PATCHES="files/gcc-${GCC_VERSION}-irix.diff"
#GCC_CONF_OPTS="--disable-libssp --enable-languages=c,c++ --disable-lto --disable-pgo-build --disable-plugins --enable-multilib --disable-werror --enable-maintainer-mode"
GCC_CONF_OPTS="--disable-libssp --enable-languages=c,c++ --disable-lto --disable-pgo-build --disable-plugins --enable-multilib --disable-werror"

GDB_VERSION=7.3.1
GDB_CONF_OPTS="--enable-64-bit-bfd --enable-targets=mips-sgi-irix6n32,mips-sgi-irix6o32,mips-sgi-irix65 --disable-sim"
