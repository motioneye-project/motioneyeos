# This Dockerfile generates the docker image that gets used by Gitlab CI
# To build it:
#   sudo docker build -t buildroot/base support/docker
#   sudo docker push buildroot/base

FROM debian:stretch-20171210
LABEL maintainer="Buildroot mailing list <buildroot@buildroot.org>" \
      vendor="Buildroot" \
description="Container with everything needed to run Buildroot"

# Setup environment
ENV DEBIAN_FRONTEND noninteractive

# The container has no package lists, so need to update first
RUN dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
        build-essential cmake libc6:i386 gcc-multilib \
        bc ca-certificates file locales rsync \
        cvs bzr git mercurial subversion wget \
        cpio unzip \
        libncurses5-dev \
        python-nose2 python-pexpect qemu-system-arm qemu-system-x86 && \
    apt-get -y autoremove && \
    apt-get -y clean

# To be able to generate a toolchain with locales, enable one UTF-8 locale
RUN sed -i 's/# \(en_US.UTF-8\)/\1/' /etc/locale.gen && \
    /usr/sbin/locale-gen

RUN useradd -ms /bin/bash br-user && \
    chown -R br-user:br-user /home/br-user

USER br-user
WORKDIR /home/br-user
ENV HOME /home/br-user
ENV LC_ALL en_US.UTF-8
