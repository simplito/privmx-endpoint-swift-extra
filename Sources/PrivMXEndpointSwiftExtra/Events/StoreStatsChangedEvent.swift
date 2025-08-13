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

/// A helper extension for `StoreStatsChangedEvent` to conform to the `PMXEvent` protocol.
/// This extension is designed to assist with event channels type conversions,
/// as channels are identified by strings in the Low-Level Endpoint.
extension privmx.endpoint.store.StoreStatsChangedEvent: PMXStoreEvent, @unchecked  Sendable { 
	public typealias EventType = privmx.endpoint.store.EventType
	
	public static var typeNum : EventType { privmx.endpoint.store.STORE_STATS}
	
	/// Returns the event channel as a string.
	///
	/// This implementation returns the constant string `"store"`,
	/// identifying the channel associated with `StoreStatsChangedEvent`.
	/// - Returns: A `String` representing the event channel, in this case, `"store"`.
	public func getChannel() -> String {
		"store"
	}

	/// Returns the event type as a string.
	///
	/// This method returns the constant string `"storeStatsChanged"`, identifying the type
	/// of this event as `storeStatsChanged`.
	/// - Returns: A `String` representing the event type, in this case, `"storeStatsChanged"`.
	public static func typeStr() -> String {
		"storeStatsChanged"
	}

	/// Handles the event by calling the provided callback with an optional argument.
	///
	/// This implementation passes the `data` property to the callback.
	/// - Parameter cb: A closure that accepts an optional `Any?` argument,
	///   representing the data to be passed when the event is handled.
	public func handleWith(
		cb: @escaping (@MainActor @Sendable (_ data: Any?) async -> Void)
	) -> Void {
		Task{
			await cb(data)
		}
	}
	
	public func getSubscriptionList(
	) -> [String] {
		return self.subscriptions.map({x in String(x)})
	}
}
