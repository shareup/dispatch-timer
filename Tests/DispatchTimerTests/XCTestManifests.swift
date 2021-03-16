import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DispatchTimerTests.allTests),
    ]
}
#endif
