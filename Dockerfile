from ubuntu:18.04

USER root

RUN \
    apt-get update -q && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -qy --fix-missing --no-install-recommends \
      ca-certificates \
      build-essential \
      #fakeroot \
      git \
      wget \
      curl \
      file \
      python2.7-dev \
      python3-dev \
      libssl-dev \
      libncurses5-dev \
      rsync \
      patch \
      cpio \
      gzip \
      unzip \
      bc \
      openssh-client \
      asciidoc \
      dblatex \
      graphviz \
      python-matplotlib && \
    rm -rf /var/lib/apt/lists/*  && \
    useradd -ms /bin/bash build && \
    mkdir -p /build && \
    chown -R build:build  /build

USER build

WORKDIR /build

# container just waits, by default, actual builds can be done with `docker exec`
CMD /bin/bash -c 'for ((i = 0; ; i++)); do sleep 100; done'
