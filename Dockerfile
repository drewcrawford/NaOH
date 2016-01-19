FROM drewcrawford/swift:latest
#install atbuild
#RUN apt-get update && apt-get install --no-install-recommends xz-utils -y
ADD atbuild /usr/local/bin/atbuild
#ADD https://github.com/AnarchyTools/atbuild/releases/download/0.4.0/atbuild-0.4.0-linux.tar.xz /atbuild.tar.xz
#RUN tar xf atbuild.tar.xz -C /usr/local
ADD . /NaOH
WORKDIR NaOH
RUN LD_LIBRARY_PATH=AnarchyDispatch/build/lib atbuild run-tests --overlay linux