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

/// An extension for `ServerMessageInfo` to conform to the `Hashable` and `Identifiable` protocols.
/// This extension provides a unique identifier for each message and allows comparing and hashing message info.
extension privmx.endpoint.thread.ServerMessageInfo: Hashable, Identifiable {

	/// Compares two `ServerMessageInfo` instances for equality.
	///
	/// This function compares the `messageId`, `threadId`, `createDate`, and `author` fields of the two instances.
	/// - Parameters:
	///   - lhs: The left-hand side `ServerMessageInfo` instance.
	///   - rhs: The right-hand side `ServerMessageInfo` instance.
	/// - Returns: `true` if all relevant fields of both instances are equal, otherwise `false`.
	public static func == (lhs: privmx.endpoint.thread.ServerMessageInfo, rhs: privmx.endpoint.thread.ServerMessageInfo) -> Bool {
		return lhs.messageId == rhs.messageId &&
			   lhs.threadId == rhs.threadId &&
			   lhs.createDate == rhs.createDate &&
			   lhs.author == rhs.author
	}

	/// The unique identifier for the message.
	///
	/// This property returns the `messageId` converted to a `String` to serve as the unique identifier.
	public var id: String {
		String(messageId)
	}

	/// Generates a hash value for the `ServerMessageInfo` instance.
	///
	/// This function combines the `messageId` and `threadId` properties into the hash to uniquely identify the message info.
	/// - Parameter hasher: The `Hasher` instance used to compute the hash value.
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.messageId)
		hasher.combine(self.threadId)
	}
}
