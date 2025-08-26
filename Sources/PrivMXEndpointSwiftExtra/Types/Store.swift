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

/// An extension for `Store` to conform to the `Identifiable` and `Hashable` protocols.
/// This extension allows for comparing two `Store` instances, generating unique hash values, and providing an identifier for each store.
extension privmx.endpoint.store.Store: Identifiable, Hashable, @unchecked Sendable {

	/// Compares two `Store` instances for equality.
	///
	/// This function compares multiple key properties of the two `Store` instances, including `storeId`, `contextId`,
	/// `createDate`, `creator`, `privateMeta`, `publicMeta`, `filesCount`, `lastFileDate`, `lastModificationDate`,
	/// `lastModifier`, `managers`, `users`, `version`, and `statusCode`.
	/// - Parameters:
	///   - lhs: The left-hand side `Store` instance.
	///   - rhs: The right-hand side `Store` instance.
	/// - Returns: `true` if all relevant fields of both stores are equal, otherwise `false`.
	public static func == (
		lhs: privmx.endpoint.store.Store,
		rhs: privmx.endpoint.store.Store
	) -> Bool {
		return lhs.storeId == rhs.storeId &&
			   lhs.contextId == rhs.contextId &&
			   lhs.createDate == rhs.createDate &&
			   lhs.creator == rhs.creator &&
			   lhs.privateMeta == rhs.privateMeta &&
			   lhs.publicMeta == rhs.publicMeta &&
			   lhs.filesCount == rhs.filesCount &&
			   lhs.lastFileDate == rhs.lastFileDate &&
			   lhs.lastModificationDate == rhs.lastModificationDate &&
			   lhs.lastModifier == rhs.lastModifier &&
			   lhs.managers == rhs.managers &&
			   lhs.users == rhs.users &&
			   lhs.version == rhs.version &&
			   lhs.statusCode == rhs.statusCode &&
			   lhs.schemaVersion == rhs.schemaVersion
	}

	/// The unique identifier for the store.
	///
	/// This property returns the `storeId` as a `String`, which serves as the unique identifier for the store.
	public var id: String {
		String(self.storeId)
	}

	/// Generates a hash value for the `Store` instance.
	///
	/// This function combines several properties, including `storeId`, `lastModificationDate`, and `version`
	/// to generate a unique hash value for the store.
	/// - Parameter hasher: The `Hasher` instance used to compute the hash value.
	public func hash(into hasher: inout Hasher) -> Void {
		hasher.combine(storeId)
		hasher.combine(contextId)
		hasher.combine(createDate)
		hasher.combine(creator)
		hasher.combine(privateMeta)
		hasher.combine(publicMeta)
		hasher.combine(filesCount)
		hasher.combine(lastFileDate)
		hasher.combine(lastModificationDate)
		hasher.combine(lastModifier)
		hasher.combine(managers)
		hasher.combine(users)
		hasher.combine(version)
		hasher.combine(statusCode)
		hasher.combine(schemaVersion)
	}
}
