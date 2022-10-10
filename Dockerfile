FROM ubuntu:xenial

MAINTAINER Alper Kucukural <alper.kucukural@umassmed.edu>
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y dist-upgrade
 
# Install apache, PHP, and supplimentary programs. curl and lynx-cur are for debugging the container.
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install git wget vim gcc make

RUN export VERSION=1.13 OS=linux ARCH=amd64 && \
    wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz && \
    tar -C /usr/local -xzvf go$VERSION.$OS-$ARCH.tar.gz && \
    rm go$VERSION.$OS-$ARCH.tar.gz && \
    export PATH=$PATH:/usr/local/go/bin && \
    export VERSION=3.7.4 && \
    wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz && \
    tar -xzf singularity-${VERSION}.tar.gz && \
    cd singularity && ./mconfig --without-suid && make -C ./builddir && make -C ./builddir install

RUN mkdir -p /usr/local/bin && cd /usr/local/bin && wget https://s3-us-west-1.amazonaws.com/sailor-1.0.4/sailor-1.0.4
RUN chmod 755 /usr/local/bin/sailor-1.0.4