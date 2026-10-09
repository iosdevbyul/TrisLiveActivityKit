// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TrisLiveActivityKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "TrisLiveActivityKit", targets: ["TrisLiveActivityKit"])
    ],
    targets: [
        .target(name: "TrisLiveActivityKit"),
        .testTarget(name: "TrisLiveActivityKitTests", dependencies: ["TrisLiveActivityKit"])
    ]
)
