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

import PrivMXEndpointSwiftNative
import PrivMXEndpointSwift

/// Holds the Event Subscription request as well as the callback and assigned group
public struct PMXEventRegistration: Sendable{
	/// Callback that will be executed whenever an appropriate event arrives
	let cb:(@Sendable @MainActor (Any?) -> Void)
	
	/// Enum value representing the particular registration data
	let registration: PMXEventSubscriptionRequest
	
	/// Group indicator for management of events, used when deleting events in batches
	let group: String
}


/// Enum handling proper registrations for events.
public enum PMXEventSubscriptionRequest: Hashable, Sendable{
	public static func == (lhs: PMXEventSubscriptionRequest, rhs: PMXEventSubscriptionRequest) -> Bool {
		lhs.getEventType().typeStr() == rhs.getEventType().typeStr() &&
		lhs.getSelectorType().rawValue == rhs.getSelectorType().rawValue &&
		lhs.getSelectorId() == rhs.getSelectorId()
}
	public func hash(into hasher: inout Hasher) {
		hasher.combine(getEventType().typeStr())
		hasher.combine(getSelectorType().rawValue)
		hasher.combine(getSelectorId())
	}
	
	/// Events from the Thread module on a corresponding selector
	case thread(eventType: any PMXThreadEvent.Type, selectorType: PMXEventSelectorType, selectorId:String)
	/// Events form the Store module on a corresponding selector
	case store(eventType: any PMXStoreEvent.Type,selectorType: PMXEventSelectorType, selectorId:String)
	/// Inbox module Events on a corresponding selector
	case inbox(eventType: any PMXInboxEvent.Type,selectorType: PMXEventSelectorType, selectorId:String)
	/// Events form the KVDB module on a corresponding selector
	case kvdb(eventType: any PMXKvdbEvent.Type,selectorType: PMXEventSelectorType, selectorId:String)
	/// Events form the Event module, from provided channelName
	case custom(channelName:String, contextId:String)
	
	/// Retreives the PMXEventSelectorType of the request.
	func getSelectorType(
	) -> PMXEventSelectorType{
		return switch(self){
			case .thread(_,let selectorType,_),
					.inbox(_,let selectorType,_),
					.kvdb(_,let selectorType,_),
					.store(_,let selectorType,_):
				selectorType
			case .custom(_,_):
				PMXEventSelectorType.Context
		}
	}
	
	/// Retreives the id of the request, if `self` == `.custom` the selector is always equal to `PMXEventSelectorType.Context`
	func getSelectorId(
	) -> String{
		return switch(self){
			case .thread(_,_,let selectorId),
					.inbox(_,_,let selectorId),
					.kvdb(_,_,let selectorId),
					.store(_,_,let selectorId),
					.custom(_,let selectorId):
				selectorId
		}
	}
	
	/// Retrieves the associated Event type of the request
	func getEventType(
	) -> any PMXEvent.Type {
		switch(self){
			case .thread(let et,_, _):
				et
			case .store(let et,_, _):
				et
			case .inbox(let et,_, _):
				et
			case .kvdb(let et,_, _):
				et
			case .custom(_,_):
				privmx.endpoint.event.ContextCustomEvent.self
		}
	}
}
