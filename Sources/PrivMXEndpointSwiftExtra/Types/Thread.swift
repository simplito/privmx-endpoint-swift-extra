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

/// An extension for `Thread` to conform to the `Identifiable` and `Hashable` protocols.
/// This extension allows for comparing two `Thread` instances, generating unique hash values, and providing an identifier for each thread.
extension privmx.endpoint.thread.Thread: Identifiable, Hashable, @unchecked Sendable {

	/// Compares two `Thread` instances for equality.
	///
	/// This function compares multiple key properties of the two `Thread` instances, including `threadId`, `contextId`,
	/// `createDate`, `creator`, `lastModifier`, `lastModificationDate`, `messagesCount`, `lastMsgDate`, `publicMeta`,
	/// `privateMeta`, `users`, `managers`, `version`, and `statusCode`.
	/// - Parameters:
	///   - lhs: The left-hand side `Thread` instance.
	///   - rhs: The right-hand side `Thread` instance.
	/// - Returns: `true` if all relevant fields of both threads are equal, otherwise `false`.
	public static func == (
		lhs: privmx.endpoint.thread.Thread,
		rhs: privmx.endpoint.thread.Thread
	) -> Bool {
		return lhs.threadId == rhs.threadId &&
			   lhs.contextId == rhs.contextId &&
			   lhs.createDate == rhs.createDate &&
			   lhs.creator == rhs.creator &&
			   lhs.lastModifier == rhs.lastModifier &&
			   lhs.lastModificationDate == rhs.lastModificationDate &&
			   lhs.messagesCount == rhs.messagesCount &&
			   lhs.lastMsgDate == rhs.lastMsgDate &&
			   lhs.publicMeta == rhs.publicMeta &&
			   lhs.privateMeta == rhs.privateMeta &&
			   lhs.users == rhs.users &&
			   lhs.managers == rhs.managers &&
			   lhs.version == rhs.version &&
			   lhs.statusCode == rhs.statusCode
	}

	/// The unique identifier for the thread.
	///
	/// This property returns the `threadId` as a `String`, which serves as the unique identifier for the thread.
	public var id: String {
		String(self.threadId)
	}

	/// Generates a hash value for the `Thread` instance.
	///
	/// This function combines several properties, including `threadId`, `lastModificationDate`, `lastMsgDate`, and `version`
	/// to generate a unique hash value for the thread.
	/// - Parameter hasher: The `Hasher` instance used to compute the hash value.
	public func hash(into hasher: inout Hasher) -> Void {
		hasher.combine(threadId)
		hasher.combine(lastModificationDate)
		hasher.combine(lastMsgDate)
		hasher.combine(version)
	}
}
