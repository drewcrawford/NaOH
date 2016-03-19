//
//  Key+Zeroing.swift
//  NaOH
//
//  Created by Drew Crawford on 8/16/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found inthe top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  inthe LICENSE file.

import Foundation

extension Key {
    /**Creates a key from the existing memory, importing it into the NaOH memory system and zeroing out the source */
    public convenience init (inout zeroingMemory: [UInt8]) {
        self.init(uninitializedSize: zeroingMemory.count)
        zeroingMemory.withUnsafeMutableBufferPointer { (inout ptr: UnsafeMutableBufferPointer<UInt8>) -> () in
            memcpy(addrAsVoid, ptr.baseAddress, ptr.count)
            sodium_memzero(ptr.baseAddress, ptr.count)
        }
    }
}