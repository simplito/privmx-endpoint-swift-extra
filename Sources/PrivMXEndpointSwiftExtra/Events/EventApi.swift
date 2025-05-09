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

import PrivMXEndpointSwiftNative
import PrivMXEndpointSwift
import Foundation

public extension EventApi{
	
	/// Emits a new Custom Event
	///
	/// - Parameter contextId: id of the Context in which the Event will be emited
	/// - Parameter channelName: channel name on which the event will be emitted
	/// - Parameter eventData: arbitrary payload of the Event
	/// - Parameter users: users that will receive the Event
	///
	/// - Throws: When emitting the event fails
	func emitEvent(
		in contextId: String,
		on channelName: String,
		containing eventData: Data,
		to users: [privmx.endpoint.core.UserWithPubKey]
	) throws -> Void {
		try emitEvent(
			contextId: std.string(contextId),
			users: privmx.UserWithPubKeyVector(users),
			channelName: std.string(channelName),
			eventData: eventData.asBuffer())
	}
	
	/// Subscribes to Custom Events in a specific Context, that arrive on a specific, named Channel
	///
	/// - Parameter contextId: id of the Context
	/// - Parameter channelName: arbitrary name of the channel
	///
	/// - Throws: When subscribing fails
	func subscribeForCustomEvents(
		in contextId: String,
		onChannel channelName: String
	) throws -> Void {
		try subscribeForCustomEvents(
			contextId:std.string(contextId),
			channelName:std.string(channelName))
	}
	
	/// Unsbscribes from Custom Events in a specific Context, that arrive on a specific, named Channel
	///
	/// - Parameter contextId: id of the Context
	/// - Parameter channelName: arbitrary name of the channel
	///
	/// - Throws: When unsubscribing fails
	func unsubscribeFromCustomEvents(
		in contextId:String,
		onChannel channelName: String
	) throws -> Void {
		try unsubscribeFromCustomEvents(
			contextId: std.string(contextId),
			channelName: std.string(channelName))
	}
}
