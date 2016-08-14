#
# Minimum Docker image to build OpenWrt Images
#
FROM ubuntu:14.04
MAINTAINER Leon <leon860516@gmail.com>

#切换源到阿里云aliyun
#RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak
#COPY sources.list /etc/apt/sources.list

#取消root密码
RUN echo "opbuild ALL=NOPASSWD: ALL" > /etc/sudoers.d/opbuild

#安装基础环境并清理缓存
RUN apt-get update && \
	apt-get install -y gcc g++ binutils patch bzip2 flex bison make \
                       autoconf gettext texinfo unzip sharutils git \
                       libncurses5-dev ncurses-term zlib1g-dev gawk \
                       libssl-dev python wget subversion xz-utils \
                       lib32gcc1 libc6-dev-i386 vim screen && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#创建用户目录
RUN mkdir -p /home/opbuild/openwrtworkspace && mkdir -p /home/opbuild/exchangefolder
#添加用户opbuild
RUN useradd opbuild && rsync -a /etc/skel/ /home/opbuild/
#修正目录所有者
RUN chown -R opbuild:opbuild /home/opbuild
#挂载交换目录用于和宿主机交换文件
VOLUME ["/home/opbuild/exchangefolder"]
#切换用户&切换工作目录
USER opbuild
WORKDIR /home/opbuild/openwrtworkspace
RUN git clone https://github.com/openwrt/openwrt.git openwrt
WORKDIR /home/opbuild/openwrtworkspace/openwrt
RUN ./scripts/feeds update -a
