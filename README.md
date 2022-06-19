# DispatchTimer

`DispatchTimer` is a [GCD-powered timer](https://developer.apple.com/documentation/dispatch/dispatchsourcetimer) with a similar API to [`Timer`](https://developer.apple.com/documentation/foundation/timer) (née `NSTimer`). `DispatchTimer`'s big advantage over `Timer` is it doesn't need a `RunLoop` to fire, which means you can use `DispatchTimer` on background threads without any problems. The disadvantage of `DispatchTimer` is you need to retain a reference to it or it won't fire.

## Installation

To use `DispatchTimer` with the Swift Package Manager, add a dependency to your `Package.swift` file:

```swift
dependencies: [
  .package(url: "https://github.com/shareup/dispatch-timer.git", from: "2.0.0"),
],
```

## Usage

```swift
let oneoff = DispatchTimer(.milliseconds(50), block: { print("fired") })

let repeating = DispatchTimer(
  .milliseconds(50),
  repeat: true,
  block: { print("fired") }
)

let fireAt = DispatchTimer(
    fireAt: DispatchTime.now() + .milliseconds(50),
    block: { print("fired") }
)
```

## License

The license for `DispatchTimer` is the standard MIT license. You can find it in the `LICENSE` file.
