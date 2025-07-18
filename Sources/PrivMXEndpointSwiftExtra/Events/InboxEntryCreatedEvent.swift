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

/// A helper extension for `InboxEntryCreatedEvent` to conform to the `PMXEvent` protocol.
/// This extension is designed to assist with event channels type conversions,
/// as channels are identified by strings in the Low-Level Endpoint.
extension  privmx.endpoint.inbox.InboxEntryCreatedEvent: PMXEvent, @unchecked  Sendable {

	/// Handles the event by calling the provided callback with an optional argument.
	///
	/// This implementation passes the `data` property to the callback.
	/// - Parameter cb: A closure that accepts an optional `Any?` argument,
	///   representing the data to be passed when the event is handled.
	public func handleWith(
		cb: @escaping (@MainActor @Sendable (Any?) async -> Void)
	) {
		Task{
			await cb(data)
		}
	}

	/// Returns the event type as a string.
	///
	/// This method returns the constant string `"inboxEntryCreated"`, identifying the type
	/// of this event as `inboxEntryCreated`.
	/// - Returns: A `String` representing the event type, in this case, `"inboxEntryCreated"`.
	public static func typeStr() -> String {
		"inboxEntryCreated"
	}

	/// Returns the event channel as a string.
	///
	/// This implementation returns the string in the format `"inbox/{inboxId}/entries"`,
	/// where `inboxId` is obtained from the `data` property.
	/// - Returns: A `String` representing the event channel, in this case,
	///   `"inbox/{inboxId}/entries"`.
	public func getChannel() -> String {
		"inbox/\(self.data.inboxId)/entries"
	}
}

