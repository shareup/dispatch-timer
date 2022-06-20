@preconcurrency import Foundation
import Synchronized

public final class DispatchTimer: Sendable {
    private let source: DispatchSourceTimer
    private let block: @Sendable () -> Void

    public let isRepeating: Bool

    public var nextDeadline: DispatchTime {
        _nextDeadline.access { $0 }
    }
    private let _nextDeadline: Locked<DispatchTime>

    public init(
        _ interval: DispatchTimeInterval,
        repeat shouldRepeat: Bool = false,
        block: @escaping @Sendable () -> Void
    ) {
        self.source = DispatchSource.makeTimerSource()
        self.block = block
        self.isRepeating = shouldRepeat

        let deadline = DispatchTime.now().advanced(by: interval)
        _nextDeadline = Locked(deadline)
        let repeating: DispatchTimeInterval = shouldRepeat ? interval : .never
        source.schedule(
            deadline: deadline,
            repeating: repeating,
            leeway: Self.defaultTolerance(interval)
        )

        source.setEventHandler { [weak self] in
            guard let self = self else { return }
            self.fire()

            guard shouldRepeat else { return }
            self._nextDeadline.access {
                $0 = DispatchTime.now().advanced(by: interval)
            }
        }
        source.activate()
    }

    public init(
        fireAt deadline: DispatchTime,
        block: @escaping @Sendable () -> Void
    ) {
        self.source = DispatchSource.makeTimerSource()
        self.block = block
        self.isRepeating = false
        _nextDeadline = Locked(deadline)

        let interval = DispatchTime.now().distance(to: deadline)

        source.schedule(
            deadline: deadline,
            repeating: .never,
            leeway: Self.defaultTolerance(interval)
        )

        source.setEventHandler { [weak self] in self?.fire() }
        source.activate()
    }

    public func invalidate() {
        source.cancel()
    }

    deinit {
        source.cancel()
    }
}

private extension DispatchTimer {
    static func defaultTolerance(_ interval: DispatchTimeInterval) -> DispatchTimeInterval {
        switch interval {
        case .seconds(let amount):
            guard amount > 0 else { return .never }
            return .milliseconds(oneTenthOfOneThousand(of: amount))
        case .milliseconds(let amount):
            guard amount > 0 else { return .never }
            return .microseconds(oneTenthOfOneThousand(of: amount))
        case .microseconds(let amount):
            guard amount > 0 else { return .never }
            return .nanoseconds(oneTenthOfOneThousand(of: amount))
        case .nanoseconds, .never:
            return .never
        @unknown default:
            return .never
        }
    }

    func fire() {
        block()
        if !isRepeating { source.cancel() }
    }
}

private func oneTenthOfOneThousand(of amount: Int) -> Int {
    return Int((Double(amount * 1000) * 0.1).rounded())
}
