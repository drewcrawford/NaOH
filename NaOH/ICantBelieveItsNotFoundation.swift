//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found in the top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.

import Foundation

//SR-138
#if os(Linux)
extension String {
    @warn_unused_result
    public func cStringUsingEncoding(encoding: NSStringEncoding) -> [CChar]? {
        let strNS = self.bridge()
        let bytes = strNS.cStringUsingEncoding(NSUTF8StringEncoding)
        let bfrPointer = UnsafeBufferPointer(start: bytes, count: strNS.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        var arr = [CChar](bfrPointer)
        strNS.description //don't optimize out
        return arr
    }
}
#endif


