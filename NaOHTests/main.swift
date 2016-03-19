import XCTest
XCTMain([
    testCase(CryptoSecretBoxTests.allTests),
    testCase(KeyTests.allTests),
    testCase(KeyFileTests.allTests),
    testCase(CryptoBoxTests.allTests),
    testCase(CryptoStreamTests.allTests),
    testCase(MemCmpTests.allTests),
    testCase(GenericHashTests.allTests),
    testCase(IncrementTests.allTests)
])