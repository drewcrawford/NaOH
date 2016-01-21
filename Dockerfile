FROM drewcrawford/swift:latest
#install atbuild
RUN apt-get update && apt-get install --no-install-recommends xz-utils -y
ADD https://github.com/AnarchyTools/atbuild/releases/download/0.5.0/atbuild-0.5.0-linux.tar.xz /atbuild.tar.xz
#RUN tar xf atbuild.tar.xz -C /usr/local
ADD . /NaOH
WORKDIR NaOH
RUN LD_LIBRARY_PATH=AnarchyDispatch/build/lib atbuild check --overlay linux