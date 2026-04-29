@testable import DispatchTimer
import XCTest

final class DispatchTimerTests: XCTestCase {
    func testNonRepeatingTimer() throws {
        let ex = expectation(description: "Should have fired timer")
        let timer = DispatchTimer(.milliseconds(50), block: { ex.fulfill() })
        wait(for: [ex], timeout: 0.2)
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
        wait(for: [ex], timeout: 0.4)
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
        wait(for: [ex], timeout: 0.2)
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
        wait(for: [ex], timeout: 0.1)
        timer.invalidate()
    }

    func testDefaultToleranceForPositiveNanosecondsIsZero() throws {
        XCTAssertEqual(
            DispatchTimer.defaultTolerance(.nanoseconds(1)),
            .nanoseconds(0)
        )
        XCTAssertEqual(
            DispatchTimer.defaultTolerance(.nanoseconds(50_000_000)),
            .nanoseconds(0)
        )
    }

    func testDefaultToleranceForNonPositiveNanosecondsIsNever() throws {
        XCTAssertEqual(
            DispatchTimer.defaultTolerance(.nanoseconds(0)),
            .never
        )
        XCTAssertEqual(
            DispatchTimer.defaultTolerance(.nanoseconds(-1)),
            .never
        )
    }

    func testDefaultToleranceForNeverIsNever() throws {
        XCTAssertEqual(
            DispatchTimer.defaultTolerance(.never),
            .never
        )
    }

    static var allTests = [
        ("testNonRepeatingTimer", testNonRepeatingTimer),
        ("testRepeatingTimer", testRepeatingTimer),
        ("testFireAtTimer", testFireAtTimer),
        ("testInvalidateCancelsTimer", testInvalidateCancelsTimer),
        ("testFireAtInPastFiresImmediately", testFireAtInPastFiresImmediately),
        (
            "testDefaultToleranceForPositiveNanosecondsIsZero",
            testDefaultToleranceForPositiveNanosecondsIsZero
        ),
        (
            "testDefaultToleranceForNonPositiveNanosecondsIsNever",
            testDefaultToleranceForNonPositiveNanosecondsIsNever
        ),
        ("testDefaultToleranceForNeverIsNever", testDefaultToleranceForNeverIsNever),
    ]
}
