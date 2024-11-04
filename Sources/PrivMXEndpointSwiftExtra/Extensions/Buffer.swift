//
// PrivMX Endpoint Swift Extra
// Copyright © 2024 Simplito sp. z o.o.
//
// This file is part of the PrivMX Platform (https://privmx.dev).
// This software is Licensed under the MIT License.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import PrivMXEndpointSwiftNative

/// An extension for `Buffer` to conform to the `Hashable` protocol.
/// This extension allows comparing two `Buffer` instances and generating a hash value
/// for usage in hash-based collections, such as dictionaries or sets.
extension privmx.endpoint.core.Buffer: Hashable {

	/// Compares two `Buffer` instances for equality.
	///
	/// This function compares the underlying byte strings of the two buffers.
	/// - Parameters:
	///   - lhs: The left-hand side `Buffer` instance.
	///   - rhs: The right-hand side `Buffer` instance.
	/// - Returns: `true` if both buffers contain the same byte string, otherwise `false`.
	public static func == (lhs: privmx.endpoint.core.Buffer, rhs: privmx.endpoint.core.Buffer) -> Bool {
		lhs.__stdStringUnsafe().pointee == rhs.__stdStringUnsafe().pointee
	}

	/// Generates a hash value for the buffer.
	///
	/// This function hashes the underlying byte string of the buffer.
	/// - Parameter hasher: The `Hasher` instance used to compute the hash value.
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.__stdStringUnsafe().pointee)
	}
	
	/// Creates a new `Data` instance from the buffer's underlying bytes.
	///
	/// This helper function converts the buffer into a `Data` object.
	/// - Returns: A new `Data` instance if the conversion is successful, otherwise `nil`.
	public func getData() -> Data? {
		guard let bufstr = self.__dataUnsafe() else {
			return nil
		}
		return Data(bytes: bufstr, count: self.size())
	}

	/// Creates a new `String` instance from the buffer's underlying bytes.
	///
	/// This helper function converts the buffer into a UTF-8 `String`.
	/// - Returns: A new `String` instance if the conversion is successful, otherwise `nil`.
	public func getString() -> String? {
		var data = Data()
		if let bufstr = self.__dataUnsafe() {
			data = Data(bytes: bufstr, count: self.size())
		}
		return String(data: data, encoding: .utf8)
	}

	/// Creates a new `Buffer` instance from a `Data` object.
	///
	/// This helper function converts the provided `Data` object into a new `Buffer` instance.
	/// - Parameter data: The `Data` object to convert.
	/// - Returns: A new `privmx.endpoint.core.Buffer` instance.
	public static func from(_ data: Data) -> privmx.endpoint.core.Buffer {
		Self.from([UInt8](data), data.count)
	}
}
