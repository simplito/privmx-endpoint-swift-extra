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

/// An extension for `privmx.endpoint.thread.Message` to conform to the `Identifiable` and `Hashable` protocols.
/// This extension provides an identifier for each message and allows for comparing and hashing messages.
extension privmx.endpoint.thread.Message: Identifiable, Hashable, @unchecked Sendable {

	/// The unique identifier for the message.
	///
	/// This property returns the `id` from the `info` property of the message.
	public var id: String {
		info.id
	}

	/// Compares two `Message` instances for equality.
	///
	/// This function compares all relevant fields of the `Message` object, including `info`, `data`,
	/// `privateMeta`, `publicMeta`, and `authorPubKey`.
	/// - Parameters:
	///   - lhs: The left-hand side `Message` instance.
	///   - rhs: The right-hand side `Message` instance.
	/// - Returns: `true` if all relevant fields of both messages are equal, otherwise `false`.
	public static func == (
		lhs: privmx.endpoint.thread.Message,
		rhs: privmx.endpoint.thread.Message
	) -> Bool {
		lhs.info == rhs.info &&
		lhs.data == rhs.data &&
		lhs.privateMeta == rhs.privateMeta &&
		lhs.publicMeta == rhs.publicMeta &&
		lhs.authorPubKey == rhs.authorPubKey &&
		lhs.schemaVersion == rhs.schemaVersion
	}

	/// Generates a hash value for the `Message` instance.
	///
	/// This function combines the `info` property into the hash to uniquely identify the message.
	/// - Parameter hasher: The `Hasher` instance used to compute the hash value.
	public func hash(into hasher: inout Hasher) -> Void {
		hasher.combine(info)
	}
}
