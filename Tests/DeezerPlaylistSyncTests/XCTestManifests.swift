import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DeezerPlaylistSync_swiftTests.allTests),
    ]
}
#endif
