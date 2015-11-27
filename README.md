NaOH (pronounced "sodium hydroxide") is a strongly opinionated Swift binding for the security library libsodium, a fork of DJB's NaCl.

NaOH is the sodium flavor trusted by Nitrogen, FISA, caffeine, and various other projects Drew works on.

# What opinions?

1.  No return value checks required.  All functions will (preferably) throw or (where that isn't possible) crash the program, rather than allow you to continue on your merry way when e.g. a key is invalid
2.  Actively thwarts buffer overflow exploits.
    1.  Keys are protected by guard pages, increasing the chance your program will crash instead of giving up a key
    2.  Keys are locked down entirely when not in critical sections, increasing the complexity of an exploitable attack
    3.  Critical memory is zeroed-on-free, even with optimizations enabled.  Although this currently isn't possible for the library's *inputs*.

# Install

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

add

```
git "https://code.sealedabstract.com/drewcrawford/NaOH.git"
```

to your Cartfile.

You can also download an [official binary release](https://code.sealedabstract.com/drewcrawford/NaOH/tags)

# Releasing

We use libsodium's numbers, with a 4th section tracking changes only this project makes.  e.g.

        1.0.3.0
    sodium--^ ^---us

Note that our API is incomplete and is subject to change.  In particular, we don't follow semver.

# Mailing list

We use [discuss.sa](http://discuss.sealedabstract.com/c/code-sa/NaOH)