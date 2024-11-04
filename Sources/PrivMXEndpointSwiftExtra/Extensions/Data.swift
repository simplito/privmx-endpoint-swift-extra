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
import PrivMXEndpointSwift


/// An extension for `Data` that provides helper methods for converting between `Data`
/// and `privmx.endpoint.core.Buffer` as well as C++ `std.string`.
extension Data {

	/// Converts the contents of this `Data` instance into a `privmx.endpoint.core.Buffer`.
	///
	/// This helper function creates a `Buffer` instance from the bytes of the `Data` object.
	/// - Returns: A `privmx.endpoint.core.Buffer` instance representing the data.
	public func asBuffer() -> privmx.endpoint.core.Buffer {
		let pointer = [UInt8](self)
		let dataSize = self.count
		let resultCppString = privmx.endpoint.core.Buffer.from(pointer, dataSize)
		return resultCppString
	}

	/// Initializes a `Data` object from the bytes of a `privmx.endpoint.core.Buffer`.
	///
	/// This initializer converts the contents of the provided `Buffer` into a `Data` instance.
	/// - Parameters:
	///   - buffer: The `privmx.endpoint.core.Buffer` to convert to `Data`.
	/// - Throws: `PrivMXEndpointError.otherFailure` if the `Buffer` is `nil`.
	public init(from buffer: privmx.endpoint.core.Buffer) throws {
		guard let cDataPtr = buffer.__dataUnsafe() else {
			var err = privmx.InternalError()
			err.name = "Data Error"
			err.message = "Data was nil"
			throw PrivMXEndpointError.otherFailure(err)
		}
		let dataSize = buffer.size()
		self.init(bytes: cDataPtr, count: dataSize)
	}

	/// Converts the underlying `Data` to a C++ `std.string`.
	///
	/// This helper function creates a `std.string` representation of the `Data` object
	/// by interpreting the data as a C string.
	/// - Returns: A `std.string` representation of the `Data` contents.
	public func rawCppString() -> std.string {
		let cString = self.withUnsafeBytes {
			(ptr: UnsafeRawBufferPointer) -> UnsafePointer<CChar> in
			return ptr.bindMemory(to: CChar.self).baseAddress!
		}
		return std.string(cString)
	}

	/// Initializes a `Data` object from a C++ `std.string`.
	///
	/// This initializer creates a `Data` instance by converting the provided C++ `std.string`
	/// into a UTF-8 encoded `Data` object.
	/// - Parameters:
	///   - str: The C++ `std.string` to convert to `Data`.
	/// - Returns: A `Data` representation of the given `std.string`.
	public init(from str: std.string) {
		self = "\(str)".data(using: .utf8) ?? Data()
	}
}
