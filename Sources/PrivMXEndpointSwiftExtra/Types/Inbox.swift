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

/// An extension for `Inbox` to conform to the `Identifiable` and `Hashable` protocols.
/// This extension allows for comparing two `Inbox` instances, generating unique hash values, and providing an identifier for each inbox.
extension privmx.endpoint.inbox.Inbox: Identifiable, Hashable {

	/// Compares two `Inbox` instances for equality.
	///
	/// This function compares multiple key properties of the two `Inbox` instances, including `inboxId`, `contextId`,
	/// `createDate`, `creator`, `privateMeta`, `publicMeta`, `filesCount`, `lastFileDate`, `lastModificationDate`,
	/// `lastModifier`, `managers`, `users`, `version`, and `statusCode`.
	/// - Parameters:
	///   - lhs: The left-hand side `Inbox` instance.
	///   - rhs: The right-hand side `Inbox` instance.
	/// - Returns: `true` if all relevant fields of both inboxs are equal, otherwise `false`.
	public static func == (
		lhs: privmx.endpoint.inbox.Inbox,
		rhs: privmx.endpoint.inbox.Inbox
	) -> Bool {
		return lhs.inboxId == rhs.inboxId &&
			   lhs.contextId == rhs.contextId &&
			   lhs.createDate == rhs.createDate &&
			   lhs.creator == rhs.creator &&
			   lhs.privateMeta == rhs.privateMeta &&
			   lhs.publicMeta == rhs.publicMeta &&
			   lhs.lastModificationDate == rhs.lastModificationDate &&
			   lhs.lastModifier == rhs.lastModifier &&
			   lhs.managers == rhs.managers &&
			   lhs.users == rhs.users &&
			   lhs.version == rhs.version &&
			   lhs.statusCode == rhs.statusCode
	}

	/// The unique identifier for the inbox.
	///
	/// This property returns the `inboxId` as a `String`, which serves as the unique identifier for the inbox.
	public var id: String {
		String(self.inboxId)
	}

	/// Generates a hash value for the `Inbox` instance.
	///
	/// This function combines several properties, including `inboxId`, `lastModificationDate`, and `version`
	/// to generate a unique hash value for the inbox.
	/// - Parameter hasher: The `Hasher` instance used to compute the hash value.
	public func hash(into hasher: inout Hasher) -> Void {
		hasher.combine(inboxId)
		hasher.combine(lastModificationDate)
		hasher.combine(version)
	}
}
