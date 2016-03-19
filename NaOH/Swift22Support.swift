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

//note that we can't use #if swift(<=3.0) here because this project has to compile back to Swift 2.1
#if !ATBUILD //all atbuild platforms have the stdlib Swift 3 syntax
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
#if !ATBUILD || os(Linux)
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
    extension NSData {
        @nonobjc
        func write(toFile path: String, options writeOptionsMask: NSDataWritingOptions = []) throws {
            try self.writeToFile(path, options: writeOptionsMask)
        }
        @nonobjc
        func base64EncodedString(options: NSDataBase64EncodingOptions = []) -> String {
            return self.base64EncodedStringWithOptions(options)
        }
    }
#endif