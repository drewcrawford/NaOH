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
#if ATBUILD
    import CSodium
    import AnarchyDispatch
#endif

func sodium_init_wrap() {
    struct Static {
        static var onceToken : dispatch_once_t = 0
    }
    dispatch_once(&Static.onceToken) {
        if sodium_init() != 0 {
            preconditionFailure("Initialization failure")
        }
    }
}


func debugValue(var value: UnsafePointer<UInt8>, size: Int) -> String {
    var str = ""
    for i in 0..<size {
        str += String(format: "%02X", arguments: [value.memory]) as String
        if i != size - 1 { value = value.successor() }
    }
    return str
}


public enum NaOHError: ErrorType {
    case OOM
    case ProtectionError
    case HashError
    case CryptoSecretBoxError
    case FilePermissionsLookSuspicious
    case CryptoBoxError
    case WontOverwriteKey
}

