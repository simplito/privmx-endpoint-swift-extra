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


/// Umbrella protocol for EventTypes enums
public protocol PMXEventType:RawRepresentable<Int64>{}

/// Unified Event Selector Type
public struct PMXEventSelectorType:RawRepresentable, Sendable{
	/// Don't.
	static var _Platform: Self {PMXEventSelectorType(rawValue: -99999)!}
	/// Computed property returning a SelectorType corresponding to CONTEXT values
	public static var Context : Self {PMXEventSelectorType(rawValue: 0)!}
	/// Computed property returning a SelectorType corresponding to CONTAINER values (such as Thread, Store, etc.)
	public static var Container : Self {PMXEventSelectorType(rawValue: 1)!}
	/// Computed property returning a SelectorType corresponding to ITEM values (such as Message, File, etc.)
	public static var Item : Self {PMXEventSelectorType(rawValue: 2)!}
	
	public init?(rawValue: Int64) {
		switch (rawValue){
		case 0,1,2,-99999:
			self.rawValue=rawValue
		default:
			return nil
		}
	}
	
	public let rawValue: Int64
	
	public typealias RawValue = Int64
}

public enum LibEventType: Int64, PMXEventType, Sendable {
	 case LIB_CONNECTED = -1
	 case LIB_BREAK = -2
	 case LIB_DISCONNECTED = -3
	 case LIB_PLATFORM_DISCONNECTED = -4
}


extension privmx.endpoint.store.EventType:PMXEventType{}
extension privmx.endpoint.thread.EventType:PMXEventType{}
extension privmx.endpoint.kvdb.EventType:PMXEventType{}
extension privmx.endpoint.inbox.EventType:PMXEventType{}
extension privmx.endpoint.core.EventType:PMXEventType{}

/// Holds the Event Subscription request as well as the callback and assigned group
public struct PMXEventCallbackRegistration: Sendable{
	public init(
		request: PMXEventSubscriptionRequest,
		group: String,
		cb: @escaping @Sendable (Any?) -> Void
	) {
		self.cb = cb
		self.request = request
		self.group = group
	}
	
	/// Enum value representing the particular registration data
	let request: PMXEventSubscriptionRequest
	
	/// Group indicator for management of events, used when deleting events in batches
	let group: String
	
	/// Callback that will be executed whenever an appropriate event arrives
	let cb:(@Sendable @MainActor (Any?) -> Void)
}

/// Enum handling proper registrations for events.
public enum PMXEventSubscriptionRequest: Hashable, Sendable{
	public static func == (lhs: PMXEventSubscriptionRequest, rhs: PMXEventSubscriptionRequest) -> Bool {
		switch (lhs,rhs){
			case (.core(let le,let li),.core(let re,let ri)):
				le == re &&
				li == ri
			case (.library(let le),.library(let re)):
				le == re
			case (.thread(let le, let ls,let li),.thread(let re, let rs,let ri)):
				le == re &&
				ls == rs &&
				li == ri
			case (.store(let le, let ls,let li),.store(let re, let rs,let ri)):
				le == re &&
				ls == rs &&
				li == ri
			case (.inbox(let le, let ls,let li),.inbox(let re, let rs,let ri)):
				le == re &&
				ls == rs &&
				li == ri
			case (.kvdb(let le, let ls,let li),.kvdb(let re, let rs,let ri)):
				le == re &&
				ls == rs &&
				li == ri
			case (.kvdbEntry(let le, let li,let lk),.kvdbEntry(let re, let ri,let rk)):
				le == re &&
				li == ri &&
				lk == rk
			case (.custom(let ln,let lc),.custom(let rn, let rc)):
				ln == rn &&
				rc == lc
			default: false
		}
}
	public func hash(into hasher: inout Hasher) {
		switch self{
			case .core(let re,let ri):
				hasher.combine(0)
				hasher.combine(re)
				hasher.combine(ri)
			case .library(let re):
				hasher.combine(1)
				hasher.combine(re)
			case .thread(let re, let rs,let ri):
				hasher.combine(2)
				hasher.combine(re)
				hasher.combine(rs.rawValue)
				hasher.combine(ri)
			case .store(let re, let rs,let ri):
				hasher.combine(3)
				hasher.combine(re)
				hasher.combine(rs.rawValue)
				hasher.combine(ri)
			case .inbox(let re, let rs,let ri):
				hasher.combine(4)
				hasher.combine(re)
				hasher.combine(rs.rawValue)
				hasher.combine(ri)
			case .kvdb(let re, let rs,let ri):
				hasher.combine(5)
				hasher.combine(re)
				hasher.combine(rs.rawValue)
				hasher.combine(ri)
			case .kvdbEntry(let le, let li,let lk):
				hasher.combine(6)
				hasher.combine(le)
				hasher.combine(li)
				hasher.combine(lk)
			case .custom(let ln,let lc):
				hasher.combine(7)
				hasher.combine(ln)
				hasher.combine(lc)
				
		}
	}
	
	/// Events from the Thread module on a corresponding selector
	case thread(eventType: privmx.endpoint.thread.EventType, selectorType: PMXEventSelectorType, selectorId:String)
	/// Events form the Store module on a corresponding selector
	case store(eventType: privmx.endpoint.store.EventType,selectorType: PMXEventSelectorType, selectorId:String)
	/// Inbox module Events on a corresponding selector
	case inbox(eventType: privmx.endpoint.inbox.EventType,selectorType: PMXEventSelectorType, selectorId:String)
	/// Events form the KVDB module on a corresponding selector
	case kvdb(eventType: privmx.endpoint.kvdb.EventType,selectorType: PMXEventSelectorType, selectorId:String)
	case kvdbEntry(eventType: privmx.endpoint.kvdb.EventType, kvdbId:String,entryKey:String)
	/// Events form the Event module, from provided channelName
	case custom(channelName:String, contextId:String)
	/// Events that are emitted by the endpoint library itself
	case library(eventType: LibEventType)
	case core(eventType: privmx.endpoint.core.EventType, contextId:String)
	}
