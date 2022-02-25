// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GABoardGameGeek",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "GABoardGameGeek",
            targets: ["GABoardGameGeek"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.5.0")),
        .package(url: "https://github.com/drmohundro/SWXMLHash.git", .upToNextMajor(from: "6.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "GABoardGameGeek",
            dependencies: ["Alamofire", "SWXMLHash"]),
        .testTarget(
            name: "GABoardGameGeekTests",
            dependencies: ["GABoardGameGeek"]),
    ]
)
