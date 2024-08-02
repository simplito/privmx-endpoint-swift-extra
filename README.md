# PrivMX Endpoint Swift Extra

PrivMX Endpoint Swift Extra is an extension of [`Privmx Endpoint Swift`](https://github.com/simplito/privmx-endpoint-swift). It's extended with additional logic, that makes using our libraries simpler and less error-prone.

This package implements:

1. Enums and static fields to reduce errors while using the methods.
2. Protocols and Extensions for translating C++ values to Swift Types.
2. [`PrivmxEndpointWrapper`](https://docs.privmx.cloud/swift/api-reference/privmx-endpoint-swift-extra/classes/privmx-endpoint-wrapper) for managing connection and event loop.
3. [`PrivmxEndpointContainer`](https://docs.privmx.cloud/swift/api-reference/privmx-endpoint-swift-extra/classes/privmx-endpoint-container) for managing global sessions.
4. Classes to simplify reading/writing to files using byte arrays and Swift [`FileHandle`](https://developer.apple.com/documentation/foundation/filehandle).
—————————————————

## Installation
To use this package add it as a Dependency in your Xcode project or your `Package.swift` file.

You can do so by selecting `Add Package Dependencies...` in the Project navigator context menu and then pasting `https://github.com/simplito/privmx-endpoint-swift-extra` in `Search or Enter Package URL` field.


When you want to add it to a Swift Package of yours, add
```swift
	.package(
		url:"https://github.com/simplito/privmx-endpoint-swift-extra",
		.upToNextMajor(from: .init(1, 6, 0))
	),
```
To `dependencies` array in `Package.swift`. 

—————————————————

## Usage

Go to our [documentation](https://docs.privmx.cloud/) to learn more about PrivMX.

—————————————————


### Copyright © 2024 Simplito sp. z o.o.
### This software is Licensed under the MIT License.

### See the License for the specific language governing permissions and limitations under the License.
