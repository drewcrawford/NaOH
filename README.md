NaOH (pronounced "sodium hydroxide") is a strongly opinionated Swift binding for the security library libsodium, a fork of DJB's NaCl.

For more information about NaCl, the cryptographic technology inside NaOH, read [this whitepaper](http://nacl.cr.yp.to/securing-communication.pdf) or djb's [paper](http://cr.yp.to/highspeed/coolnacl-20120725.pdf).

NaOH is the sodium flavor trusted by Nitrogen, FISA, caffeine, and various other projects Drew works on.

# What opinions?

1.  No return value checks required.  All functions will (preferably) throw or (where that isn't possible) crash the program, rather than allow you to continue on your merry way when e.g. a key is invalid
2.  Actively thwarts buffer overflow exploits.
    1.  Keys are protected by guard pages, increasing the chance your program will crash instead of giving up a key
    2.  Keys are locked down entirely when not in critical sections, increasing the complexity of an exploitable attack
    3.  Critical memory is zeroed-on-free, even with optimizations enabled.  Although this currently isn't possible for the library's *inputs*.

# Install

[![Anarchy Tools compatible](https://img.shields.io/badge/Anarchy%20Tools-compatible-4BC51D.svg?style=flat)](http://anarchytools.org)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

You can also download an [official binary release](https://code.sealedabstract.com/drewcrawford/NaOH/tags)

# Versioning

We don't follow semver.  [Here's why](http://faq.sealedabstract.com/why_not_semver/).

# Mailing list

We use [discuss.sa](http://discuss.sealedabstract.com/c/code-sa/NaOH)