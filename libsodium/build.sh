#!/bin/bash
#install dependencies only if we don't have them
deps=("make" "sed" "curl" "ca-certificates")
ln -s `pwd`/libsodium $ATBUILD_USER_PATH/libsodium
install_deps() {
    apt-get update
    apt-get install --no-install-recommends -y ${deps[@]}
}
if [ `uname` == "Linux" ]; then
    dpkg -s "${deps[@]}" >/dev/null 2>&1 || install_deps
fi
cd libsodium
if [ ! -f libsodium.tar.gz ]; then
    curl -L https://github.com/jedisct1/libsodium/releases/download/1.0.7/libsodium-1.0.7.tar.gz -o libsodium.tar.gz
fi
if [ ! -f libsodium ]; then
    mkdir -p libsodium
    tar xf libsodium.tar.gz -C libsodium --strip-components=1
fi

cd libsodium
if [ ! -f Makefile ]; then
    ./configure
fi
if [ ! -f src/libsodium/.libs/libsodium.a ]; then
    make -j8
fi
