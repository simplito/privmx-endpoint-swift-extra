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

/// A helper extension for `KvdbEntryUpdatedEvent` to conform to the `PMXEvent` protocol.
/// This extension is designed to assist with event channels type conversions,
/// as channels are identified by strings in the Low-Level Endpoint.
extension privmx.endpoint.kvdb.KvdbEntryUpdatedEvent: PMXKvdbEvent, @unchecked Sendable {
	public typealias EventType = privmx.endpoint.kvdb.EventType
	
	public static var typeNum : EventType { privmx.endpoint.kvdb.ENTRY_UPDATE}
	
	/// Returns the event channel as a string.
	///
	/// This implementation returns the string in the format `"kvdb/{kvdbId}/entries"`,
	/// where `kvdbId` is obtained from the `data.kvdbId` property.
	/// - Returns: A `String` representing the event channel, in this case, `"kvdb/{kvdbId}/entries"`.
	public func getChannel() -> String {
		"kvdb/\(self.data.info.kvdbId)/entries"
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
	/// This method returns the constant string `"kvdbEntryUpdated"`, identifying the type
	/// of this event as `kvdbEntryUpdated`.
	/// - Returns: A `String` representing the event type, in this case, `"kvdbEntryUpdated"`.
	public static func typeStr() -> String {
		"kvdbEntryUpdated"
	}
	public func getSubscriptionList(
	) -> [String] {
		return self.subscriptions.map({x in String(x)})
	}
}

