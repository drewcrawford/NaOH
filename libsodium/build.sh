#!/bin/bash
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
    rm src/libsodium/.libs/libsodium.dylib
fi
