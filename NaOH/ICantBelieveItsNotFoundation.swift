//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found in the top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.

import Foundation


//SR-138 ⛏
extension NSString {
    var toString: String {
        #if os(Linux)
            return self.bridge()
        #else
            return self as String
        #endif
    }
}

//setAttributesOfItemAtPath isn't implemented
//https://github.com/apple/swift-corelibs-foundation/pull/243
extension NSFileManager {
    func setSWIFTBUGAttributes(_ attributes: [String : AnyObject], ofItemAtPath path: String) throws {
        for attribute in attributes.keys {
            switch attribute {
            case NSFilePosixPermissions:
                guard let number = attributes[attribute] as? NSNumber else {
                    fatalError("Can't set file permissions to \(attributes[attribute])")
                }
                #if os(OSX) || os(iOS)
                    #if swift(>=3.0)
                        let modeT = number.uint16Value
                    #else
                        let modeT = number.unsignedShortValue
                    #endif
                #elseif os(Linux)
                    let modeT = number.unsignedIntValue
                #endif
                if chmod(path, modeT) != 0 {
                    fatalError("errno \(errno)")
                }
            default:
                fatalError("Attribute type not implemented: \(attribute)")
            }
        }
    }
}

#if os(Linux)
extension NSFileManager {
    func enumerator(atPath path: String) -> NSDirectoryEnumerator? {
        return self.enumeratorAtPath(path)
    }
    func createSymbolicLink(atPath path: String, withDestinationPath destPath: String) throws {
        return try self.createSymbolicLinkAtPath(path, withDestinationPath: destPath)
    }
    func createDirectory(atPath path: String, withIntermediateDirectories createIntermediates: Bool,  attributes: [String : AnyObject]? = [:]) throws {
        return try self.createDirectoryAtPath(path, withIntermediateDirectories: createIntermediates, attributes: attributes)
    }
    func attributesOfItem(atPath path: String) throws -> [String : Any] {
        return try self.attributesOfItemAtPath(path)
    }
    func removeItem(atPath path: String) throws {
        return try self.removeItemAtPath(path)
    }
    func fileExists(atPath path: String) -> Bool {
        return self.fileExistsAtPath(path)
    }
}
#endif
