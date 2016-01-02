FROM snapplepm
MAINTAINER Drew Crawford

ENV BUILDTIME_PACKAGES="build-essential file"

WORKDIR NaOH
RUN apt-get update && \
apt-get install --no-install-recommends -y $BUILDTIME_PACKAGES
ADD . /NaOH
RUN /usr/local/bin/snapplepm/debug/swift-build

