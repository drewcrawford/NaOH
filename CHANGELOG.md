# Change Log
All notable changes to this project will be documented in this file.

This project does not follow semver.

# 1.5 - 2016-11-03

* Add CryptoSecretBoxSecretKey random constructor
* (AT) no longer downloading test dependencies with atpm by default
* (AT) improvements for xcode-emit

# 1.4.1 - 2016-10-13

* Deployment target is now iOS 8

# 1.4.0 - 2016-09-15

* Deployment target is now iOS 9
* APIs continue to be only supported on iOS 9.3 and later.  
* Swift 3 compatibility
* Swift 2 support is dropped for 1.4+.  Please use a previous version for Swift 2.

# 1.2.2 - 2016-04-06

* Deployment target is now iOS 8
* However, APIs are only supported on iOS 9.3.  For more information, see https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20160404/014171.html

# 1.2.1 - 2016-04-04

Add a missing constructor

# 1.2 - 2016-04-01

This build has important breaking changes, but the API is now more secure and you should upgrade.

* `Key` is now unavailable
* Use a specific key type [CryptoBoxSecretKey, CryptoSecretBoxSecretKey, ChaCha20SecretKey] instead.  Function parameters take a particular key type, so look at the functions you call for guidance.
* If no specific key type is appropriate, try `SecretKey`, which is a generic protocol
* Support for application-specific custom key types was removed.

The intent of these changes is to make it easier to write safe, clear code that is easy to reason about.

Other changes in this release:

* Implemented `crypto_sign_detached` and `crypto_sign_verify_detached`
* Resolved a rare race condition
* Improved mitigation of side-channel attacks
* `savetoFile` now works as expected for public keys

# 1.1 - 2016-03-22

* We're changing our versioning scheme, to use [my standard versioning](http://faq.sealedabstract.com/why_not_semver/).  Major for major changes, minor for minor changes, patch for patches.  We no longer track upstream versions in our versioning.
* Xcode 7.3 / iOS 9 / Swift 2.2 support.
* We now support Linux when built through [atbuild](http://anarchytools.org).  Linux binary builds are not yet officially released.

# 1.0.7.1 - 2015-12-18

* iOS support

# 1.0.7.0 - 2015-12-14

* Add genericHash for arrays
* Convert to Integer192Bit for nonce arguments.  Integer192 has its own constant-time incrementation function.
* Updating to Xcode 7.2
* Update to libsodium 1.0.7.  See upstream's [changelog](https://github.com/jedisct1/libsodium/releases/tag/1.0.7).

# 1.0.6.1 - 2015-12-07

* Adding PublicKey.humanReadable and corresponding constructor
* Updating to Xcode 7.1.1

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