#!/bin/bash

cd $(dirname $0)

TOPDIR=$PWD

MAKE_TASKS=5

TARGET_INST=/opt/irix-o32-gcc

error() {
    shift
    echo "ERROR: $@"
    exit 1
}

cd tmp

cd binutils-2.19.1

mkdir -p build

cd build

../configure --prefix=${TARGET_INST} --target=mips-sgi-irix5 --host=mips-sgi-irix5 -build=x86_64-linux-gnu --without-nls --disable-werror --enable-shared

make -j $MAKE_TASKS || error "Build binutils"

make install || error "Install binutils"

mips-sgi-irix5-strip ${TARGET_INST}/bin/* || true
mips-sgi-irix5-strip ${TARGET_INST}/mips-sgi-irix5/bin/* || true

cd ../..

cd gcc-14.2.0

mkdir -p build

cd build

mkdir gcc
cat > gcc/config.cache <<EOF
ac_cv_c_bigendian=${ac_cv_c_bigendian=yes}
EOF

../configure --prefix=${TARGET_INST} --host=mips-sgi-irix5 -build=x86_64-linux-gnu --without-nls --with-gnu-as --with-gnu-ld --disable-libssp \
 --enable-languages=c,c++ --disable-nls --enable-pgo-build=no --enable-lto=no --enable-shared \
 CC_FOR_TARGET=mips-sgi-irix5-gcc \
 CXX_FOR_TARGET=mips-sgi-irix5-g++

make -j $MAKE_TASKS || error "Build gcc"

make install-strip || error "Install gcc"

cd ../..

tar zcf irix-o32-gcc.tar.gz ${TARGET_INST}

test -d /out && cp -f irix-o32-gcc.tar.gz /out

echo "Done"
