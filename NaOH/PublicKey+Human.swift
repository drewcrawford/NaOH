//
//  PublicKey+Human.swift
//  NaOH
//
//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found in the top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.

import Foundation

@available(iOS 9.3, *, *)
extension PublicKey  {
    public var humanReadable: String {
        get {
            return NSData(bytes: bytes, length: bytes.count).base64EncodedString(NSDataBase64EncodingOptions())
        }
    }
}