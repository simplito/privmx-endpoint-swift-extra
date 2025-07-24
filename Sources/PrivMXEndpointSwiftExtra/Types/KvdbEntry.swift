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

/// An extension for `KvdbEntry` to conform to the `Hashable` and `Identifiable` protocols.
/// This extension allows for comparing two `KvdbEntry` instances, generating unique hash values, and providing an identifier for each file.
extension privmx.endpoint.kvdb.KvdbEntry: Hashable, Identifiable, @unchecked Sendable {

	/// Compares two `KvdbEntry` instances for equality.
	///
	/// - Parameters:
	///   - lhs: The left-hand side `KvdbEntry` instance.
	///   - rhs: The right-hand side `KvdbEntry` instance.
	/// - Returns: `true` if all relevant fields of both files are equal, otherwise `false`.
	public static func == (
		lhs: privmx.endpoint.kvdb.KvdbEntry,
		rhs: privmx.endpoint.kvdb.KvdbEntry
	) -> Bool {
		lhs.info == rhs.info &&
		lhs.data == rhs.data &&
		lhs.publicMeta == rhs.publicMeta &&
		lhs.privateMeta == rhs.privateMeta &&
		lhs.authorPubKey == rhs.authorPubKey &&
		lhs.data == rhs.data && 
		lhs.statusCode == rhs.statusCode &&
		lhs.schemaVersion == rhs.schemaVersion
	}

	/// The unique identifier for the entry.
	///
	/// This property returns a string in the  `key`.
	public var id: String {
		String(self.info.key)
	}

	/// Generates a hash value for the `KvdbEntry` instance.
	///
	/// This function combines the `info` property into the hash to uniquely identify the file.
	/// - Parameter hasher: The `Hasher` instance used to compute the hash value.
	public func hash(into hasher: inout Hasher) -> Void {
		hasher.combine(info.kvdbId)
		hasher.combine(info.key)
		hasher.combine(data)
	}
}


