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

/// An extension for `InboxEntry` to conform to the `Hashable` and `Identifiable` protocols.
/// This extension allows for comparing two `InboxEntry` instances, generating unique hash values, and providing an identifier for each file.
extension privmx.endpoint.inbox.InboxEntry: Hashable, Identifiable, @unchecked Sendable {

	/// Compares two `InboxEntry` instances for equality.
	///
	/// - Parameters:
	///   - lhs: The left-hand side `InboxEntry` instance.
	///   - rhs: The right-hand side `InboxEntry` instance.
	/// - Returns: `true` if all relevant fields of both files are equal, otherwise `false`.
	public static func == (
		lhs: privmx.endpoint.inbox.InboxEntry,
		rhs: privmx.endpoint.inbox.InboxEntry
	) -> Bool {
		return lhs.entryId == rhs.entryId &&
		lhs.inboxId == rhs.inboxId &&
		lhs.data == rhs.data &&
		lhs.createDate == rhs.createDate &&
		lhs.authorPubKey == rhs.authorPubKey &&
		privmx.compareVectors(lhs.files,rhs.files) &&
		lhs.statusCode == rhs.statusCode
		
	}

	/// The unique identifier for the entry.
	///
	/// This property returns the `entryId converted to a `String`.
	public var id: String {
		String(self.entryId)
	}

	/// Generates a hash value for the `InboxEntry` instance.
	///
	/// This function combines the `info` property into the hash to uniquely identify the file.
	/// - Parameter hasher: The `Hasher` instance used to compute the hash value.
	public func hash(into hasher: inout Hasher) -> Void {
		hasher.combine(entryId)
		hasher.combine(data)
	}
}


