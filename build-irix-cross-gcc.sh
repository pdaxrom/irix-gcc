#!/bin/bash

cd $(dirname $0)

TOPDIR=$PWD

MAKE_TASKS=5

CROSS_INST=/opt/cross-irix-o32-gcc

error() {
    shift
    echo "ERROR: $@"
    exit 1
}

mkdir -p ${CROSS_INST}/sysroot || error "Make sysroot directory"
tar xf files/dev.tar.gz -C ${CROSS_INST}/sysroot || error "Unpack sysroot"

mkdir tmp
cd tmp
test -f binutils-2.19.1.tar.bz2 ||  wget https://ftp.gnu.org/gnu/binutils/binutils-2.19.1.tar.bz2 || error "Can't download binutils"
test -f gcc-14.2.0.tar.xz || wget https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz || error "Can't download gcc"
tar xf binutils-2.19.1.tar.bz2 || error "Unpacking binutils"
tar xf gcc-14.2.0.tar.xz || error "Unpacking gcc"

cd binutils-2.19.1

patch -p1 < ${TOPDIR}/files/binutils-2.19.1-irix.diff || error "Patch binutils"

mkdir -p build-cross build

cd build-cross

../configure --prefix=${CROSS_INST} --target=mips-sgi-irix5 --without-nls --disable-werror --with-sysroot=${CROSS_INST}/sysroot --enable-lto=no || error "Configure binutils"

make -j $MAKE_TASKS || error "Build binutils"

make install || error "Install binutils"

strip ${CROSS_INST}/bin/* || true
strip ${CROSS_INST}/mips-sgi-irix5/bin/* || true

cd ../..

cd gcc-14.2.0

./contrib/download_prerequisites || error "Download gcc prerequisites"

rm -rf gettext*

cd gmp
patch -p1 < ${TOPDIR}/files/gmp-6.2.1-new.diff || error "Patching gmp"
cd ../isl
patch -p1 < ${TOPDIR}/files/isl-0.24-new.diff || error "Patching isl"
cd ..
patch -p1 < ${TOPDIR}/files/gcc-14.2.0-irix.diff || error "Patching gcc"

mkdir -p build-cross build

cd build-cross

../configure --prefix=${CROSS_INST} --target=mips-sgi-irix5 --without-nls --with-sysroot=${CROSS_INST}/sysroot --with-gnu-as --with-gnu-ld --disable-libssp --enable-languages=c,c++ --disable-lto --disable-pgo-build --disable-plugins || error "Configure gcc"

make -j $MAKE_TASKS || error "Build gcc"

make install-strip || error "Install gcc"

cd ../..

echo "Done"
