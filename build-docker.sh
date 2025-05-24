#!/bin/bash

set -ex

docker build --tag 'irix-cross' .

docker run -ti --rm -v .:/out irix-cross /bin/bash /root/build-irix-gcc.sh
docker run -ti --rm -v .:/out irix-cross /bin/bash /root/build-irix-gcc.sh config-irix65.inc
