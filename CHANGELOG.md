# Change Log
All notable changes to this project will be documented in this file.

This project does not follow semver.

# 1.0.6.0 - 2015-11-27

* Updating libsodium to 1.0.6.  See upstream's [changelog](https://github.com/jedisct1/libsodium/releases/tag/1.0.6)
* Add a convenience initializer for cryptobox keys
* Add sodium_random
* Rename PublicKey.publicKey to PublicKey.bytes for clarity
* Add sodium_memcmp for constant-time array compare
* Updating to "Swift 2.1" (Xcode 7.1 runtime) 
* Require OSX 10.11 El Capitan


# 1.0.3.1 - 2015-09-22

* Update to final Swift 2 runtime
* Better error reporting for common API misuse
* Support variable-sizes for password-derived private keys
* Support for crypto_stream_chacha20_xor
* Exporting crypto_secretbox_NONCESIZE

# 1.0.3.0 - 2015-08-31

Initial release