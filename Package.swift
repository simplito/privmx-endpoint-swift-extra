// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "privmx-endpoint-swift-extra",
    platforms: [
        .macOS(.v14),
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "PrivMXEndpointSwiftExtra",
            targets: ["PrivMXEndpointSwiftExtra"]),
	],
	dependencies:[
		.package(url:"https://github.com/simplito/privmx-endpoint-swift",
				 .upToNextMinor(from: .init(2, 3, 0,prereleaseIdentifiers: ["rc1"]))
				 ),
	],
    targets: [
        .target(
            name: "PrivMXEndpointSwiftExtra",
			dependencies: [.product(name: "PrivMXEndpointSwift", package: "privmx-endpoint-swift")],
            swiftSettings: [
				.interoperabilityMode(.Cxx),
						   ]
        ),
	],
	cxxLanguageStandard: .cxx17
)
