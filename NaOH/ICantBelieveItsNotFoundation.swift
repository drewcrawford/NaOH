//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found in the top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.

import Foundation

//SR-138 ⛏
#if os(Linux)
extension String {
    @warn_unused_result
    public func cStringUsingEncoding(encoding: NSStringEncoding) -> [CChar]? {
        let strNS = self.bridge()
        let bytes = strNS.cStringUsingEncoding(NSUTF8StringEncoding)
        let bfrPointer = UnsafeBufferPointer(start: bytes, count: strNS.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)+1)
        var arr = [CChar](bfrPointer)
        strNS.description //don't optimize out
        return arr
    }
}
#endif
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

//who defines NSTemporaryDirectory?
#if os(Linux)
    func NSTemporaryDirectory() -> String {
        return "/tmp/"
    }
#endif

#if os(Linux)
    import Glibc //⛏567
#endif

//setAttributesOfItemAtPath isn't implemented
extension NSFileManager {
    func setSWIFTBUGAttributes(attributes: [String : AnyObject], ofItemAtPath path: String) throws {
        for attribute in attributes.keys {
            switch attribute {
            case NSFilePosixPermissions:
                guard let number = attributes[attribute] as? NSNumber else {
                    fatalError("Can't set file permissions to \(attributes[attribute])")
                }
                #if os(OSX) || os(iOS)
                    let modeT = number.unsignedShortValue
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

//missing constructor
#if os(Linux)
extension NSString {
    convenience init(format: String, _ args: CVarArgType...) {
        let str = withVaList(args) { (listPtr) -> NSString in
            return NSString(format: format, arguments: listPtr)
        }
        self.init(string: str.bridge())
    }
}
#endif