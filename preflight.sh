#!/bin/bash
cd libsodium
#rm -rf libsodium #remove any old tarball extract
mkdir libsodium
tar xf libsodium*.tar.gz -C ./libsodium --strip-components=1
cd libsodium
./configure
make