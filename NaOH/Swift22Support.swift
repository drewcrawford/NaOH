//
//  Swift22Support.swift
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

#if swift(>=3.0)
#else
    extension Array {
        mutating func append<S : SequenceType where S.Generator.Element == Element>  (contentsOf newElements: S)  {
            self.appendContentsOf(newElements)
        }
        init(repeating: Element, count: Int) {
            self.init(count: count, repeatedValue: repeating)
        }
    }
    typealias ErrorProtocol = ErrorType
    func unsafeBitCast<T, U>(x: T, to: U.Type) -> U {
        return unsafeBitCast(x, to)
    }
    
    extension UnsafePointer {
        var pointee: Memory { return self.memory }
    }
#endif

#if !swift(>=3.0)
//we must define Foundation fallbacks
    
    //oddly enough, this is a "foundation" fallback
    extension String {
        func cString(usingEncoding encoding: NSStringEncoding) -> [CChar]? {
            return self.cStringUsingEncoding(encoding)
        }
    }
    
    extension NSFileManager {
        @nonobjc
        func fileExists(atPath path: String) -> Bool {
            return self.fileExistsAtPath(path)
        }
        @nonobjc
        func removeItem(atPath path: String) throws {
            return try self.removeItemAtPath(path)
        }
        @nonobjc
        func copyItem(atPath srcPath: String, toPath dstPath: String) throws {
            return try self.copyItemAtPath(srcPath, toPath: dstPath)
        }
        //this function in particular returns [String: Any] on Linux
        #if os(Linux)
        @nonobjc
        func attributesOfItem(atPath path: String) throws -> [String : Any] {
            return try self.attributesOfItemAtPath(path)
        }
        #else
        @nonobjc
        func attributesOfItem(atPath path: String) throws -> [String : AnyObject] {
            return try self.attributesOfItemAtPath(path)
        }
        #endif
    }

#endif

#if !swift(>=3.0)
extension NSNumber {
    @nonobjc
    convenience init(value: Int16) {
        self.init(short: value)
    }
    @nonobjc
    convenience init(value: UInt16) {
        self.init(unsignedShort: value)
    }
    var uint16Value: UInt16 { return self.unsignedShortValue }
}
#endif

#if !swift(>=3.0)  || os(Linux)
extension NSFileManager {
    @nonobjc
    class func `default`() -> NSFileManager {
        return self.defaultManager()
    }
}
#endif

#if !swift(>=3.0)
extension NSData {
    convenience init?(base64Encoded base64String: String, options: NSDataBase64DecodingOptions) {
        self.init(base64EncodedString: base64String, options: options)
    }
}
extension NSData {
    @nonobjc
    func write(toFile path: String, options writeOptionsMask: NSDataWritingOptions = []) throws {
        try self.writeToFile(path, options: writeOptionsMask)
    }
    @nonobjc
    func base64EncodedString(_ options: NSDataBase64EncodingOptions = []) -> String {
        return self.base64EncodedStringWithOptions(options)
    }
}
extension NSMutableData {
    @nonobjc
    func append(_ other: NSData) {
        self.appendData(other)
    }
}
#endif

#if !swift(>=3.0)
extension String {
    func cString(using using: NSStringEncoding) -> [CChar]? {
        return self.cString(usingEncoding: using)
    }
}
#endif