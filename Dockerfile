FROM drewcrawford/swift:latest
#install atbuild
RUN apt-get update && apt-get install --no-install-recommends xz-utils -y
ADD https://github.com/AnarchyTools/atbuild/releases/download/0.5.1/atbuild-0.5.1-linux.tar.xz /atbuild.tar.xz
RUN tar xf atbuild.tar.xz -C /usr/local

#provide some relief for caching
#these lines can actually be commented out, but make the build process more cacheable
#speeding up build times in common cases
# AnarchyDispatch
WORKDIR NaOH
ADD AnarchyDispatch /NaOH/AnarchyDispatch
ADD build.atpkg /NaOH/build.atpkg
RUN atbuild AnarchyDispatch.default
# libsodium
ADD libsodium /NaOH/libsodium
RUN atbuild libsodium


ADD . /NaOH
RUN LD_LIBRARY_PATH=AnarchyDispatch/build/lib atbuild check --overlay linux