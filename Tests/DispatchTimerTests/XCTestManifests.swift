import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        [
            testCase(DispatchTimerTests.allTests),
        ]
    }
#endif
