#
# Minimum Docker image to build OpenWrt Images
#
FROM ubuntu:14.04
MAINTAINER Leon <leon860516@gmail.com>
RUN apt-get update && \
	apt-get install -y gcc g++ binutils patch bzip2 flex bison make \
                       autoconf gettext texinfo unzip sharutils git \
                       libncurses5-dev ncurses-term zlib1g-dev gawk \
                       libssl-dev python wget subversion xz-utils \
                       lib32gcc1 libc6-dev-i386 vim  && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak

COPY sources.list /etc/apt/sources.list
RUN mkdir -p /home/opbuild/openwrtworkspace

RUN useradd opbuild && rsync -a /etc/skel/ /home/opbuild/
RUN chown -R opbuild:opbuild /home/opbuild


VOLUME ["/home/opbuild/openwrtworkspace"]


USER opbuild
WORKDIR /home/opbuild/openwrtworkspace