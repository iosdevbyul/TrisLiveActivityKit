# TrisLiveActivityKit

A reusable Swift Package for managing iOS Live Activities with ActivityKit.

**Requirements:** iOS 17+, Swift 5.9+, Xcode with an iOS 17+ SDK.

## Features

- Start a local Live Activity and obtain its identifier.
- Update or end an Activity by identifier and typed `ActivityAttributes`.
- Discover existing activity identifiers after app relaunch.
- Check whether Live Activities are enabled.
- Dependency-inject the `LiveActivityServiceProtocol` in app code and tests.
- No dependencies on WakTrainer, HealthKit, or other applications.

## Integration

Add the repository as a Swift Package dependency:

```text
https://github.com/iosdevbyul/TrisLiveActivityKit
```

Create your own attributes in a module accessible to **both** the app and its Widget Extension:

```swift
import ActivityKit

struct DeliveryAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var status: String
    }

    let orderID: String
}
```

Use the service in your application:

```swift
import TrisLiveActivityKit

let service = LiveActivityService()
let id = try service.start(
    attributes: DeliveryAttributes(orderID: "123"),
    state: .init(status: "Preparing")
)

try await service.update(
    id: id,
    as: DeliveryAttributes.self,
    state: .init(status: "On the way")
)

try await service.end(
    id: id,
    as: DeliveryAttributes.self,
    finalState: .init(status: "Delivered")
)
```

The host app **must** set `NSSupportsLiveActivities = YES` in its Info.plist and include a Widget Extension that declares an `ActivityConfiguration(for: DeliveryAttributes.self)`. The extension is required even when this package provides the ActivityKit management logic.

The service uses **local ActivityKit updates**. It does not implement push tokens, remote APNs updates, automatic background execution, or workout persistence. iOS may suspend an app, so updates are not guaranteed while the app is suspended. Apps must restore their own session state and reconcile activity identifiers when launched again.

## Development

Create a branch from `main`, implement and test changes, open a PR, wait for CI, merge, then release with a semantic version tag. The included GitHub Actions workflow runs an iOS Simulator build and tests.
