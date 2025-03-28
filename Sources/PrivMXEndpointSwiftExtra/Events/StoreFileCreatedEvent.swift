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

/// A helper extension for `StoreFileCreatedEvent` to conform to the `PMXEvent` protocol.
/// This extension is designed to assist with event channels type conversions,
/// as channels are identified by strings in the Low-Level Endpoint.
extension privmx.endpoint.store.StoreFileCreatedEvent: PMXEvent {

	/// Returns the event channel as a string.
	///
	/// This implementation returns the string in the format `"store/{storeId}/files"`,
	/// where `storeId` is obtained from the `data.info.storeId` property.
	/// - Returns: A `String` representing the event channel, in this case, `"store/{storeId}/files"`.
	public func getChannel() -> String {
		"store/\(self.data.info.storeId)/files"
	}

	/// Returns the event type as a string.
	///
	/// This method returns the constant string `"storeFileCreated"`, identifying the type
	/// of this event as `storeFileCreated`.
	/// - Returns: A `String` representing the event type, in this case, `"storeFileCreated"`.
	public static func typeStr() -> String {
		"storeFileCreated"
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
}

extension privmx.endpoint.store.StoreFileCreatedEvent: @unchecked  Sendable {
}

