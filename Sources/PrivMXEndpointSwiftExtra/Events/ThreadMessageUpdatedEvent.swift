//
// PrivMX Endpoint Swift Extra
// Copyright © 2025 Simplito sp. z o.o.
//
// This file is part of the PrivMX Platform (https://privmx.dev).
// This software is Licensed under the MIT License.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import PrivMXEndpointSwiftNative

/// A helper extension for `ThreadMessageUpdatedEvent` to conform to the `PMXEvent` protocol.
/// This extension is designed to assist with event channels type conversions,
/// as channels are identified by strings in the Low-Level Endpoint.
extension privmx.endpoint.thread.ThreadMessageUpdatedEvent: PMXEvent, @unchecked  Sendable { 

	/// Returns the event channel as a string.
	///
	/// This implementation returns the string in the format `"thread/{threadId}/messages"`,
	/// where `threadId` is obtained from the `data.threadId` property.
	/// - Returns: A `String` representing the event channel, in this case, `"thread/{threadId}/messages"`.
	public func getChannel() -> String {
		"thread/\(self.data.info.threadId)/messages"
	}

	/// Handles the event by calling the provided callback with an optional argument.
	///
	/// This implementation passes the `data` property to the callback.
	/// - Parameter cb: A closure that accepts an optional `Any?` argument,
	///   representing the data to be passed when the event is handled.
	public func handleWith(
		cb: @escaping (@MainActor @Sendable (_ data: Any?)  async -> Void)
	) -> Void {
		Task{
			await cb(data)
		}
	}

	/// Returns the event type as a string.
	///
	/// This method returns the constant string `"threadMessageUpdated"`, identifying the type
	/// of this event as `threadMessageUpdated`.
	/// - Returns: A `String` representing the event type, in this case, `"threadMessageUpdated"`.
	public static func typeStr() -> String {
		"threadMessageUpdated"
	}
}
