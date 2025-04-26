FROM ubuntu:24.04

ENV DEBIAN_FRONTEND noninteractive

ENV INSIDE_DOCKER="yes"

WORKDIR /root

COPY files /root/files
COPY build-irix-cross-gcc.sh /root/
COPY build-irix-gcc.sh /root/

RUN apt update && apt full-upgrade -y && apt install -y build-essential texinfo autoconf2.69 wget mc libtool autopoint
RUN /bin/bash /root/build-irix-cross-gcc.sh

ENV PATH="$PATH:/opt/cross-irix-o32-gcc/bin"

CMD ["/bin/bash"]
