FROM drewcrawford/swift:latest
#install atbuild
RUN apt-get update && apt-get install git --no-install-recommends xz-utils -y
ADD https://github.com/AnarchyTools/atbuild/releases/download/0.10.0/atbuild-0.10.0-linux.tar.xz /atbuild.tar.xz
RUN tar xf atbuild.tar.xz && cp atbuild-*/atbuild /usr/local/bin/atbuild

#provide some relief for caching
#these lines can actually be commented out, but make the build process more cacheable
#speeding up build times in common cases
WORKDIR NaOH
# libsodium
ADD libsodium /NaOH/libsodium
RUN libsodium/build.sh

ADD . /NaOH
RUN atbuild check --use-overlay linux