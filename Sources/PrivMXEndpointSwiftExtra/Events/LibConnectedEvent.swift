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

/// A helper extension for `LibConnectedEvent` to conform to the `PMXEvent` protocol.
/// This extension is designed to assist with event channels type conversions,
/// as channels are identified by strings in the Low-Level Endpoint.
extension privmx.endpoint.core.LibConnectedEvent: PMXLibraryEvent, @unchecked  Sendable { 

	/// Returns the event type as a string.
	///
	/// This method returns the constant string `"libConnected"`, identifying the type
	/// of this event as `libConnected`.
	/// - Returns: A `String` representing the event type, in this case, `"libConnected"`.
	public static func typeStr() -> String {
		"libConnected"
	}

	/// Handles the event by calling the provided callback with an optional argument.
	///
	/// This implementation always passes `nil` to the callback.
	/// - Parameter cb: A closure that accepts an optional `Any?` argument,
	///   representing the data to be passed when the event is handled.
	public func handleWith(
		cb: @escaping(@Sendable @MainActor (_ data: Any?) async  -> Void)
	) -> Void {
		Task{
			await cb(nil)
		}
	}
	
	public func getSubscriptionList(
	) -> [String] {
		privmx.endpoint.wrapper._get_subIds_from(self).map({x in String(x)}) + [String(LibEventType.LIB_CONNECTED.rawValue)]
	}
}
