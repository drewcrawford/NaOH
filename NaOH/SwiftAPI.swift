//
//  SwiftAPI.swift
//  NaOH
//
//  Created by Drew Crawford on 8/15/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found in the top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.

import Foundation
#if os(Linux)
    import Dispatch
#endif

private let initialized: Bool = {
    if sodium_init() != 0 {
        preconditionFailure("Initialization failure")
    }
    return true
}()

func sodium_init_wrap() {
    let _ = initialized
}


func debugValue(value: UnsafePointer<UInt8>, size: Int) -> String {
    var value = value
    var str = ""
    for i in 0..<size {
        str += String(format: "%02X", arguments: [value.pointee]) as String
        if i != size - 1 { value = value.successor() }
    }
    return str
}

@available(iOS 9.3, *)
public enum NaOHError: Error {
    case OOM
    case ProtectionError
    case HashError
    case CryptoSecretBoxError
    case FilePermissionsLookSuspicious
    case CryptoBoxError
    case WontOverwriteKey
    case CryptoSignError
}

