#!/bin/bash

set -ex

cd $(dirname $0)

TOPDIR=$PWD

if test -e "$1"; then
    source "$1"
else
    source ${TOPDIR}/config.inc
fi

MAKE_TASKS=${MAKE_TASKS:-15}

TARGET_INST=${TARGET_INST:-/opt/irix-gcc}

CROSS_INST=${TARGET_INST}-cross

TARGET_TRIPLET=${TARGET_TRIPLET:-mips-sgi-irix6o32}

echo "Build for ${TARGET_TRIPLET}"

error() {
    shift
    echo "ERROR: $@"
    exit 1
}

export PATH=${CROSS_INST}/bin:$PATH

cd tmp

if ! test -e binutils.installed ; then
    pushd binutils-${BINUTILS_VERSION}
    mkdir -p build
    cd build

    eval ../configure --prefix=${TARGET_INST} --target=${TARGET_TRIPLET} --host=${TARGET_TRIPLET} --without-nls --disable-werror --enable-shared ${BINUTILS_CONF_OPTS}

    make -j $MAKE_TASKS || error "Build binutils"

    make install || error "Install binutils"

    ${TARGET_TRIPLET}-strip ${TARGET_INST}/bin/* || true
    ${TARGET_TRIPLET}-strip ${TARGET_INST}/${TARGET_TRIPLET}/bin/* || true

    test -d ${TARGET_INST}/lib && ${TARGET_TRIPLET}-strip ${TARGET_INST}/lib/*.so* || true
    test -d ${TARGET_INST}/lib32 && ${TARGET_TRIPLET}-strip ${TARGET_INST}/lib32/*.so* || true
    test -d ${TARGET_INST}/lib64 && ${TARGET_TRIPLET}-strip ${TARGET_INST}/lib64/*.so* || true

    popd
    touch binutils.installed
fi

if ! test -e gcc.installed ; then
    pushd gcc-${GCC_VERSION}
    mkdir -p build
    cd build
    mkdir gcc
    cat > gcc/config.cache <<EOF
ac_cv_c_bigendian=${ac_cv_c_bigendian=yes}
EOF

    eval ../configure --prefix=${TARGET_INST} --host=${TARGET_TRIPLET} --without-nls --with-gnu-as --with-gnu-ld --enable-shared ${GCC_CONF_OPTS} \
        CC_FOR_TARGET=${TARGET_TRIPLET}-gcc \
        CXX_FOR_TARGET=${TARGET_TRIPLET}-g++

    make -j $MAKE_TASKS || error "Build gcc"

    make install-strip || error "Install gcc"

    popd
    touch gcc.installed
fi

if ! test -e gdb.installed ; then
    pushd gdb-${GDB_VERSION}
    mkdir -p build
    cd build

    ../configure --prefix=${TARGET_INST} --host=${TARGET_TRIPLET} --disable-werror --disable-multibyte --cache-file=config.cache CC="${TARGET_TRIPLET}-gcc -std=gnu99"

    make MAKEINFO=true -j $MAKE_TASKS

    make MAKEINFO=true install

    ${TARGET_TRIPLET}-strip ${TARGET_INST}/bin/gdb ${TARGET_INST}/bin/gdbtui ${TARGET_INST}/bin/run

    popd
    touch gdb.installed
fi

OUT_FILENAME=$(basename ${TARGET_INST})

tar zcf ${OUT_FILENAME}.tar.gz ${TARGET_INST}

test -d /out && cp -f ${OUT_FILENAME}.tar.gz /out

echo "Done"
