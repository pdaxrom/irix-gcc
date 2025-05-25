TARGET_INST=/opt/irix-gcc-n32

TARGET_TRIPLET=mips-sgi-irix6n32
SYSROOT_FILE=files/irix65-dev.tar.xz

BINUTILS_VERSION=2.19.1
BINUTILS_PATCHES="files/binutils-${BINUTILS_VERSION}-irix.diff"
BINUTILS_CONF_OPTS="--enable-lto=no --enable-multilib --libdir=${TARGET_INST}/lib32"
BINUTILS_EXT=bz2

GCC_VERSION=15.1.0
GCC_PATCHES="files/gcc-${GCC_VERSION}-irix.diff files/gcc-${GCC_VERSION}-irix65-stdc++.diff files/gcc-${GCC_VERSION}-irix-n32.diff files/gcc-${GCC_VERSION}-irix65-abi64.diff"
#GCC_CONF_OPTS="--disable-libssp --enable-languages=c,c++ --disable-lto --disable-pgo-build --disable-plugins --enable-multilib --disable-werror --enable-cxx-flags=\"-U__c99 -D_SGI_COMPILING_LIBC\" --enable-maintainer-mode"
GCC_CONF_OPTS="--disable-libssp --enable-languages=c,c++ --disable-lto --disable-pgo-build --disable-plugins --enable-multilib --disable-werror --enable-cxx-flags=\"-U__c99 -D_SGI_COMPILING_LIBC\""

GDB_VERSION=7.3.1
