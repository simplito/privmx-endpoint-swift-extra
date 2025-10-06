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
		to users: [privmx.endpoint.core.UserWithPubKey],
		on channelName: String,
		containing eventData: Data
	) throws -> Void {
		try emitEvent(
			contextId: std.string(contextId),
			users: privmx.UserWithPubKeyVector(users),
			channelName: std.string(channelName),
			eventData: eventData.asBuffer())
	}
	
	/// Subscribe for the events on the given subscription queries. Use the `buildSubscriptionQuery(channelName:selectorType:selectorId:)` method to generate properly formatted subscription query.
	///
	/// - Parameter subscriptionQueries: list of queries
	///
	/// - Throws: When subscribing for events fails.
	///
	/// - Returns: list of subscriptionIds in maching order to subscriptionQueries.
	func subscribeFor(
		_ subscriptionQueries: [String]
	) throws -> [String] {
		var sqv = privmx.SubscriptionQueryVector()
		sqv.reserve(subscriptionQueries.count)
		for q in subscriptionQueries{
			sqv.push_back(std.string(q))
		}
		return try self.subscribeFor(subscriptionQueries:sqv).map({x in String(x)})
	}
	
	/// Unsubscribe from events for the given subscriptionId.
	///
	/// - Parameter subscriptionIds: list of subscriptionId
	///
	/// - Throws: When unsubscribing fails.
	func unsubscribeFrom(
		_ subscriptionIds: [String]
	) throws -> Void {
		var sid = privmx.SubscriptionIdVector()
		sid.reserve(subscriptionIds.count)
		for i in subscriptionIds{
			sid.push_back(std.string(i))
		}
		try self.unsubscribeFrom(subscriptionIds: sid)
	}
	
	/// Generate subscription Query for the Custom events.
	///
	/// - Parameter channelName: name of the Custom event channel
	/// - Parameter selectorType: scope on which you listen for events
	/// - Parameter selectorId: ID of the selector
	///
	/// - Throws: When building the subscription Query fails.
	///
	/// - Returns: a properly formatted event subscription request.
	func buildSubscriptionQuery(
		forChannel channelName: String,
		selectorType: privmx.endpoint.event.EventSelectorType,
		selectorId: String
	) throws -> String {
		try String(self.buildSubscriptionQuery(channelName: std.string(channelName),
											   selectorType: selectorType,
											   selectorId: std.string(selectorId)))
	}
}
