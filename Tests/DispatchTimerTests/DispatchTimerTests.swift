import XCTest
@testable import DispatchTimer

final class DispatchTimerTests: XCTestCase {
    func testNonRepeatingTimer() throws {
        let ex = expectation(description: "Should have fired timer")
        let timer = DispatchTimer(.milliseconds(50), block: { ex.fulfill() })
        wait(for: [ex], timeout: 0.1)
        timer.invalidate()
    }

    func testRepeatingTimer() throws {
        let ex = expectation(description: "Should have fired timer")
        ex.expectedFulfillmentCount = 3
        ex.assertForOverFulfill = false
        let timer = DispatchTimer(
            .milliseconds(50),
            repeat: true,
            block: { ex.fulfill() }
        )
        wait(for: [ex], timeout: 0.2)
        timer.invalidate()
    }

    func testFireAtTimer() throws {
        let ex = expectation(description: "Should have fired timer")
        let timeToFire = DispatchTime.now() + .milliseconds(50)
        let timer = DispatchTimer(
            fireAt: timeToFire,
            block: { ex.fulfill() }
        )
        XCTAssertEqual(timeToFire, timer.nextDeadline)
        wait(for: [ex], timeout: 0.1)
        timer.invalidate()
    }

    func testInvalidateCancelsTimer() throws {
        let ex = expectation(description: "Should not have fired timer")
        ex.isInverted = true
        let timer = DispatchTimer(.milliseconds(50), block: { ex.fulfill() })
        timer.invalidate()
        wait(for: [ex], timeout: 0.2)
        timer.invalidate()
    }

    func testFireAtInPastFiresImmediately() throws {
        let ex = expectation(description: "Should have fired timer")
        let timeToFire = DispatchTime.now() - .milliseconds(50)
        let timer = DispatchTimer(
            fireAt: timeToFire,
            block: { ex.fulfill() }
        )
        XCTAssertEqual(timeToFire, timer.nextDeadline)
        wait(for: [ex], timeout: 0.04)
        timer.invalidate()
    }

    static var allTests = [
        ("testNonRepeatingTimer", testNonRepeatingTimer),
        ("testRepeatingTimer", testRepeatingTimer),
        ("testFireAtTimer", testFireAtTimer),
        ("testInvalidateCancelsTimer", testInvalidateCancelsTimer),
        ("testFireAtInPastFiresImmediately", testFireAtInPastFiresImmediately),
    ]
}
