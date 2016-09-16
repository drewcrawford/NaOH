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
            return self._bridgeToSwift()
        #else
            return self as String
        #endif
    }
}

