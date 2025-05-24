#!/bin/bash

set -ex

docker build --tag 'irix-cross' -f Dockerfile .
docker build --tag 'irix-cross-n32' -f Dockerfile.n32 .

docker run -ti --rm -v .:/out irix-cross /bin/bash /root/build-irix-gcc.sh
docker run -ti --rm -v .:/out irix-cross-n32 /bin/bash /root/build-irix-gcc.sh config-irix65.inc
