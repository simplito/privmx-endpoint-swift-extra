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

/// A helper extension for `ThreadDeletedEvent` to conform to the `PMXEvent` protocol.
/// This extension is designed to assist with event channels type conversions,
/// as channels are identified by strings in the Low-Level Endpoint.
extension privmx.endpoint.thread.ThreadDeletedEvent: PMXEvent {

	/// Returns the event channel as a string.
	///
	/// This implementation returns the constant string `"thread"`,
	/// identifying the channel associated with `ThreadDeletedEvent`.
	/// - Returns: A `String` representing the event channel, in this case, `"thread"`.
	public func getChannel() -> String {
		"thread"
	}

	/// Handles the event by calling the provided callback with an optional argument.
	///
	/// This implementation passes the `data` property to the callback.
	/// - Parameter cb: A closure that accepts an optional `Any?` argument,
	///   representing the data to be passed when the event is handled.
	public func handleWith(
		cb: @escaping ((_ data: Any?) -> Void)
	) -> Void {
		cb(data)
	}

	/// Returns the event type as a string.
	///
	/// This method returns the constant string `"threadDeleted"`, identifying the type
	/// of this event as `threadDeleted`.
	/// - Returns: A `String` representing the event type, in this case, `"threadDeleted"`.
	public static func typeStr() -> String {
		"threadDeleted"
	}
}

extension privmx.endpoint.thread.ThreadDeletedEvent: @unchecked  Sendable {
}
