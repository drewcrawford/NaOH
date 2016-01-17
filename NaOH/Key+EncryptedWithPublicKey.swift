//
//  Key+EncryptedWithPublicKey.swift
//  NaOH
//
//  Created by Drew Crawford on 8/16/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found inthe top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.

import Foundation
#if ATBUILD
    import CSodium
#endif
extension Key {
    
    /**Encrypts the receiver to another public key, from another secret key.
This operation is often useful in public/private crypto to deliver a secret key. */
    public func encrypted(toPublicKey publicKey: PublicKey, fromKey: Key, appendNonce: Bool) throws -> [UInt8] {
        precondition(appendNonce, "Not implemented")
        try! self.unlock()
        defer { try! self.lock() }
        let keyData = UnsafeMutableBufferPointer(start: self.addr, count: size)
        var key = [UInt8](keyData)
        defer {
            key.withUnsafeMutableBufferPointer({ (inout ptr: UnsafeMutableBufferPointer<UInt8>) -> () in
                sodium_memzero(ptr.baseAddress, ptr.count)
            })
        }
        let cipher = try crypto_box_appendnonce(key, to: publicKey, from: fromKey)
        return cipher
    }
    
    /**The companion initializer to key.encrypted(...) */
    public convenience init(decrypt:[UInt8], secretKey: Key, fromKey: PublicKey) throws {
        var keyData = try crypto_box_open_appendnonce(decrypt, to: secretKey, from: fromKey)
        self.init(zeroingMemory:&keyData)
    }
}
