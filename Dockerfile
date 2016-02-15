FROM drewcrawford/swift:latest
#install atbuild
RUN apt-get update && apt-get install --no-install-recommends xz-utils -y
ADD https://github.com/AnarchyTools/atbuild/releases/download/0.7.1/atbuild-0.7.1-linux.tar.xz /atbuild.tar.xz
RUN tar xf atbuild.tar.xz -C /usr/local

#provide some relief for caching
#these lines can actually be commented out, but make the build process more cacheable
#speeding up build times in common cases
WORKDIR NaOH
# libsodium
ADD libsodium /NaOH/libsodium
RUN atbuild libsodium


ADD . /NaOH
RUN atbuild check --use-overlay linux