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

extension PublicKey: CustomStringConvertible {
    public var humanReadable: String {
        get {
            return NSData(bytes: bytes, length: bytes.count).base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
        }
    }
    
    public var description: String {
        return "<PublicKey: '\(humanReadable)'>"
    }
    
    public convenience init(humanReadableString: String) {
        let data = NSData(base64EncodedString: humanReadableString, options: NSDataBase64DecodingOptions())!
        var array = [UInt8](count: data.length, repeatedValue: 0)
        data.getBytes(&array,length:data.length)
        self.init(publicKeyBytes: array)
    }
}