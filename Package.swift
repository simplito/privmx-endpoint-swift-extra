// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "privmx-endpoint-swift-extra",
    platforms: [
		.macOS(.v14),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        .library(
            name: "PrivMXEndpointSwiftExtra",
            targets: ["PrivMXEndpointSwiftExtra"]),
	],
	dependencies:[
		.package(
			url:"https://github.com/simplito/privmx-endpoint-swift",
			.upToNextMajor(from: .init(1, 6, 0))
		),
	],
    targets: [
        .target(
            name: "PrivMXEndpointSwiftExtra",
			dependencies: [.product(name: "PrivMXEndpointSwift", package: "privmx-endpoint-swift")],
			resources: [.copy("cacert.pem")],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),
	],
	cxxLanguageStandard: .cxx17
)
