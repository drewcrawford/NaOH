FROM snapplepm
MAINTAINER Drew Crawford

ENV BUILDTIME_PACKAGES="build-essential file"

WORKDIR NaOH
RUN apt-get update && \
apt-get install --no-install-recommends -y $BUILDTIME_PACKAGES

#on Linux, we must install libdispatch
ADD libdispatch.tar.xz /
RUN tar xf /libdispatch.tar.xz -C /usr/local

ADD . /NaOH
RUN /usr/local/bin/snapplepm/debug/swift-build

