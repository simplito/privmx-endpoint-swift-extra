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

extension EventApi{
	public func emitEvent(
		contextId: String,
		channelName: String,
		eventData: Data,
		users: [privmx.endpoint.core.UserWithPubKey]
	) throws -> Void {
		try emitEvent(
			contextId: std.string(contextId),
			channelName: std.string(channelName),
			eventData: eventData.asBuffer(),
			users: privmx.UserWithPubKeyVector(users))
	}
	
	public func subscribeForCustomEvents(
		in contextId: String,
		fromChannel channelName: String
	) throws -> Void {
		try subscribeForCustomEvents(
			contextId:std.string(contextId),
			channelName:std.string(channelName))
	}
	
	public func unsubscribeFromCustomEvents(
		in contextId:String,
		fromChannel channelName: String
	) throws -> Void {
		try unsubscribeFromCustomEvents(
			contextId: std.string(contextId),
			channelName: std.string(channelName))
	}
}
