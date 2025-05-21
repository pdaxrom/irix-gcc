#!/bin/bash

set -ex

cd $(dirname $0)

TOPDIR=$PWD

MAKE_TASKS=15

TARGET_INST=/opt/cross-irix-gcc-o32

if test -e "$1"; then
    source "$1"
else
    source ${TOPDIR}/config.inc
fi

TARGET_TRIPLET=${TARGET_TRIPLET:-mips-sgi-irix6o32}

echo "Build for ${TARGET_TRIPLET}"

error() {
    shift
    echo "ERROR: $@"
    exit 1
}

SYSROOT_FILE=${SYSROOT_FILE:-files/irix62-dev.tar.xz}

if ! test -d ${TARGET_INST}/sysroot ; then
    mkdir -p ${TARGET_INST}/sysroot
    tar xf ${SYSROOT_FILE} -C ${TARGET_INST}/sysroot
fi

mkdir -p tmp
cd tmp

BINUTILS_EXT=${BINUTILS_EXT:-xz}
GCC_EXT=${GCC_EXT:-xz}

if ! test -e cross-binutils.installed; then
    test -f binutils-${BINUTILS_VERSION}.tar.${BINUTILS_EXT} ||  wget ${WGET_OPTS} https://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.${BINUTILS_EXT}
    test -d binutils-${BINUTILS_VERSION} || tar xf binutils-${BINUTILS_VERSION}.tar.${BINUTILS_EXT}

    pushd binutils-${BINUTILS_VERSION}
	if ! test -e .prepared ; then
	    for p in ${BINUTILS_PATCHES}; do
		if test -e $p ; then
		    patch -p1 < $p
		else
		    patch -p1 < ${TOPDIR}/$p
		fi
	    done

	    touch .prepared
	fi
	mkdir -p build-cross build
	cd build-cross
	eval ../configure --prefix=${TARGET_INST} --target=${TARGET_TRIPLET} --without-nls --disable-werror --with-sysroot=${TARGET_INST}/sysroot ${BINUTILS_CONF_OPTS}
	make -j $MAKE_TASKS
	make install
	strip ${TARGET_INST}/bin/* || true
	strip ${TARGET_INST}/${TARGET_TRIPLET}/bin/* || true
    popd

    touch cross-binutils.installed
fi

if ! test -e cross-gcc.installed ; then
    test -f gcc-${GCC_VERSION}.tar.${GCC_EXT} || wget ${WGET_OPTS} https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.${GCC_EXT}
    test -d gcc-${GCC_VERSION} || tar xf gcc-${GCC_VERSION}.tar.${GCC_EXT}

    pushd gcc-${GCC_VERSION}
	if ! test -e .prepared ; then
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

	    for p in ${GCC_PATCHES}; do
		if test -e $p ; then
		    patch -p1 < $p
		else
		    patch -p1 < ${TOPDIR}/$p
		fi
	    done

	    touch .prepared
	fi

	mkdir -p build-cross build
	cd build-cross
	eval ../configure --prefix=${TARGET_INST} --target=${TARGET_TRIPLET} --without-nls --with-sysroot=${TARGET_INST}/sysroot --with-gnu-as --with-gnu-ld ${GCC_CONF_OPTS}
	make -j $MAKE_TASKS
	make install-strip
    popd

    touch cross-gcc.installed
fi

echo "Done"
