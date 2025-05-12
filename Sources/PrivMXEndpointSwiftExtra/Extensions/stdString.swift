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

public extension std.string{
	
	/// Checks if the string is in Hex format.
	/// - Returns: result of the check.
	func isHex(
	) throws -> Bool {
		try Hex.is(data: self)
	}
	
	/// Checks if the string is in Base32 format.
	/// - Returns: result of the check.
	func isBase32(
	) throws -> Bool {
		try Base32.is(data: self)
	}
	
	/// Checks if the string is in Base64 format.
	/// - Returns: result of the check.
	func isBase64(
	) throws -> Bool {
		try Base64.is(data: self)
	}
	
	/// Removes all whitespace from the left of `self`.
	mutating func rtrim(
	) throws -> Void {
		try Utils.rtrim(data: &self)
	}

	/// Removes all whitespace from the left of `self`.
	mutating func ltrim(
	) throws -> Void {
		try Utils.ltrim(data: &self)
	}
	
	/// Removes all trailing whitespace.
	///
	/// - Returns: a copy of this string with trailing whitespace removed
	func trimmed(
	) throws -> std.string {
		try Utils.trim(data: self)
	}
}
