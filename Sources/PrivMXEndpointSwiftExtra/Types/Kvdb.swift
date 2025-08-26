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
import Cxx
import CxxStdlib
import PrivMXEndpointSwiftNative

/// An extension for `Kvdb` to conform to the `Identifiable` and `Hashable` protocols.
/// This extension allows for comparing two `Kvdb` instances, generating unique hash values, and providing an identifier for each kvdb.
extension privmx.endpoint.kvdb.Kvdb: Identifiable, Hashable, @unchecked Sendable {

	/// Compares two `Kvdb` instances for equality.
	///
	/// - Parameters:
	///   - lhs: The left-hand side `Kvdb` instance.
	///   - rhs: The right-hand side `Kvdb` instance.
	/// - Returns: `true` if all relevant fields of both kvdbs are equal, otherwise `false`.
	public static func == (
		lhs: privmx.endpoint.kvdb.Kvdb,
		rhs: privmx.endpoint.kvdb.Kvdb
	) -> Bool {
		return lhs.kvdbId == rhs.kvdbId &&
			   lhs.contextId == rhs.contextId &&
			   lhs.createDate == rhs.createDate &&
			   lhs.creator == rhs.creator &&
			   lhs.lastModifier == rhs.lastModifier &&
			   lhs.lastModificationDate == rhs.lastModificationDate &&
			   lhs.entries == rhs.entries &&
			   lhs.lastEntryDate == rhs.lastEntryDate &&
			   lhs.publicMeta == rhs.publicMeta &&
			   lhs.privateMeta == rhs.privateMeta &&
			   lhs.users == rhs.users &&
			   lhs.managers == rhs.managers &&
			   lhs.version == rhs.version &&
			   lhs.statusCode == rhs.statusCode &&
			   lhs.schemaVersion == rhs.schemaVersion
	}

	/// The unique identifier for the kvdb.
	///
	/// This property returns the `kvdbId` as a `String`, which serves as the unique identifier for the kvdb.
	public var id: String {
		String(self.kvdbId)
	}

	/// Generates a hash value for the `Kvdb` instance.
	///
	/// This function combines several properties, including `kvdbId`, `lastModificationDate`, `lastEntryDate`, and `version`
	/// to generate a unique hash value for the kvdb.
	/// - Parameter hasher: The `Hasher` instance used to compute the hash value.
	public func hash(into hasher: inout Hasher) -> Void {
		hasher.combine(kvdbId)
		hasher.combine(contextId)
		hasher.combine(createDate)
		hasher.combine(creator)
		hasher.combine(lastModifier)
		hasher.combine(lastModificationDate)
		hasher.combine(entries)
		hasher.combine(lastEntryDate)
		hasher.combine(publicMeta)
		hasher.combine(privateMeta)
		hasher.combine(users)
		hasher.combine(managers)
		hasher.combine(version)
		hasher.combine(statusCode)
		hasher.combine(schemaVersion)
	}
}
