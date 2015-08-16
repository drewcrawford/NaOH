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

extension Key {
    
    /**Encrypts the receiver to another public key, from another secret key.
This operation is often useful in public/private crypto to deliver a secret key. */
    public func encrypted(toPublicKey publicKey: PublicKey, fromKey: Key) throws -> [UInt8] {
        try! self.unlock()
        defer { try! self.lock() }
        let keyData = UnsafeMutableBufferPointer(start: self.addr, count: size)
        var key = [UInt8](keyData)
        defer {
            key.withUnsafeMutableBufferPointer({ (inout ptr: UnsafeMutableBufferPointer<UInt8>) -> () in
                sodium_memzero(ptr.baseAddress, ptr.count)
            })
        }
        let cipher = try crypto_box(key, to: publicKey, from: fromKey, nonce: crypto_box_nonce())
        return cipher
    }
}
