#!/bin/bash

set -ex

cd $(dirname $0)

TOPDIR=$PWD

MAKE_TASKS=5

CROSS_INST=/opt/cross-irix-o32-gcc
TARGET_INST=/opt/irix-o32-gcc

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

export PATH=${CROSS_INST}/bin:$PATH

cd tmp

cd binutils-${BINUTILS_VERSION}

mkdir -p build

cd build

../configure --prefix=${TARGET_INST} --target=${TARGET_TRIPLET} --host=${TARGET_TRIPLET} --without-nls --disable-werror --enable-shared ${BINUTILS_CONF_OPTS}

make -j $MAKE_TASKS || error "Build binutils"

make install || error "Install binutils"

${TARGET_TRIPLET}-strip ${TARGET_INST}/bin/* || true
${TARGET_TRIPLET}-strip ${TARGET_INST}/${TARGET_TRIPLET}/bin/* || true

cd ../..

cd gcc-${GCC_VERSION}

mkdir -p build

cd build

mkdir gcc
cat > gcc/config.cache <<EOF
ac_cv_c_bigendian=${ac_cv_c_bigendian=yes}
EOF

../configure --prefix=${TARGET_INST} --host=${TARGET_TRIPLET} --without-nls --with-gnu-as --with-gnu-ld --enable-shared ${GCC_CONF_OPTS} \
 CC_FOR_TARGET=${TARGET_TRIPLET}-gcc \
 CXX_FOR_TARGET=${TARGET_TRIPLET}-g++

make -j $MAKE_TASKS || error "Build gcc"

make install-strip || error "Install gcc"

cd ../..

OUT_FILENAME=$(basename ${TARGET_INST})

tar zcf ${OUT_FILENAME}.tar.gz ${TARGET_INST}

test -d /out && cp -f ${OUT_FILENAME}.tar.gz /out

echo "Done"
