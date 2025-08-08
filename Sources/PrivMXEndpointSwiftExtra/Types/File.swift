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

/// An extension for `File` to conform to the `Hashable` and `Identifiable` protocols.
/// This extension allows for comparing two `File` instances, generating unique hash values, and providing an identifier for each file.
extension privmx.endpoint.store.File: Hashable, Identifiable, @unchecked Sendable {

	/// Compares two `File` instances for equality.
	///
	/// This function compares several key properties of the two `File` instances, including `info`, `privateMeta`,
	/// `publicMeta`, `authorPubKey`, `size`, and `statusCode`.
	/// - Parameters:
	///   - lhs: The left-hand side `File` instance.
	///   - rhs: The right-hand side `File` instance.
	/// - Returns: `true` if all relevant fields of both files are equal, otherwise `false`.
	public static func == (
		lhs: privmx.endpoint.store.File,
		rhs: privmx.endpoint.store.File
	) -> Bool {
		return lhs.info == rhs.info &&
			lhs.privateMeta == rhs.privateMeta &&
			lhs.publicMeta == rhs.publicMeta &&
			lhs.authorPubKey == rhs.authorPubKey &&
			lhs.size == rhs.size &&
			lhs.statusCode == rhs.statusCode &&
			lhs.schemaVersion == rhs.schemaVersion
	}

	/// The unique identifier for the file.
	///
	/// This property returns the `fileId` from the `info` property of the file, converted to a `String`.
	public var id: String {
		String(self.info.fileId)
	}

	/// Generates a hash value for the `File` instance.
	///
	/// This function combines the `info` property into the hash to uniquely identify the file.
	/// - Parameter hasher: The `Hasher` instance used to compute the hash value.
	public func hash(into hasher: inout Hasher) -> Void {
		hasher.combine(info)
		hasher.combine(privateMeta)
		hasher.combine(publicMeta)
		hasher.combine(authorPubKey)
		hasher.combine(size)
		hasher.combine(statusCode)
		hasher.combine(schemaVersion)
	}
}


