FROM ubuntu:24.04

ENV DEBIAN_FRONTEND noninteractive

ENV INSIDE_DOCKER="yes"

WORKDIR /root

COPY files /root/files
COPY build-cross-irix-gcc.sh /root/
COPY build-irix-gcc.sh /root/
COPY config.inc /root/
COPY config-irix65.inc /root/
COPY config-n32.inc /root/

RUN apt update && apt full-upgrade -y && apt install -y build-essential texinfo autoconf2.69 wget mc libtool autopoint xz-utils
RUN /bin/bash /root/build-cross-irix-gcc.sh

ENV PATH="$PATH:/opt/irix-gcc-o32-cross/bin"

CMD ["/bin/bash"]
