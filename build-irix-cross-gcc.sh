#!/bin/bash

set -ex

cd $(dirname $0)

TOPDIR=$PWD

MAKE_TASKS=5

CROSS_INST=/opt/cross-irix-o32-gcc

if test -e "$1"; then
    source "$1"
else
    source ${TOPDIR}/config.inc
fi

if [ "$TARGET_TRIPLET" = "" ]; then
    TARGET_TRIPLET=mips-sgi-irix5
fi

echo "Build for ${TARGET_TRIPLET}"

error() {
    shift
    echo "ERROR: $@"
    exit 1
}

mkdir -p ${CROSS_INST}/sysroot
tar xf files/irix62-dev.tar.bz2 -C ${CROSS_INST}/sysroot

mkdir -p tmp
cd tmp
test -f binutils-${BINUTILS_VERSION}.tar.bz2 ||  wget ${WGET_OPTS} https://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.bz2
test -f gcc-${GCC_VERSION}.tar.bz2 || wget ${WGET_OPTS} https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.bz2
tar xf binutils-${BINUTILS_VERSION}.tar.bz2
tar xf gcc-${GCC_VERSION}.tar.bz2

cd binutils-${BINUTILS_VERSION}

test -e ${TOPDIR}/files/binutils-${BINUTILS_VERSION}-irix.diff && patch -p1 < ${TOPDIR}/files/binutils-${BINUTILS_VERSION}-irix.diff

mkdir -p build-cross build

cd build-cross

../configure --prefix=${CROSS_INST} --target=${TARGET_TRIPLET} --without-nls --disable-werror --with-sysroot=${CROSS_INST}/sysroot ${BINUTILS_CONF_OPTS}

make -j $MAKE_TASKS

make install

strip ${CROSS_INST}/bin/* || true
strip ${CROSS_INST}/${TARGET_TRIPLET}/bin/* || true

cd ../..

cd gcc-${GCC_VERSION}

if test -e ./contrib/download_prerequisites ; then
    ./contrib/download_prerequisites
fi

rm -rf gettext*

if test -d gmp ; then
    pushd gmp
    patch -p1 < ${TOPDIR}/files/gmp-6.2.1-new.diff
    popd
fi

if test -d isl ; then
    pushd isl
    patch -p1 < ${TOPDIR}/files/isl-0.24-new.diff
    popd
fi

test -e ${TOPDIR}/files/gcc-${GCC_VERSION}-irix.diff && patch -p1 < ${TOPDIR}/files/gcc-${GCC_VERSION}-irix.diff

mkdir -p build-cross build

cd build-cross

../configure --prefix=${CROSS_INST} --target=${TARGET_TRIPLET} --without-nls --with-sysroot=${CROSS_INST}/sysroot --with-gnu-as --with-gnu-ld --disable-libssp --enable-languages=c,c++ --disable-lto --disable-pgo-build --disable-plugins ${GCC_CONF_OPTS}

make -j $MAKE_TASKS

make install-strip

cd ../..

echo "Done"
