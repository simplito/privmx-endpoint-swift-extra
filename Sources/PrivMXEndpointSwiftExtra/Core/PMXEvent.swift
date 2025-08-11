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
import PrivMXEndpointSwift
import PrivMXEndpointSwiftNative

/// Protocol for managing events within PrivMX Endpoint. Provides a standardized interface for handling and processing events with Swift Types.
public protocol PMXEvent: Sendable {
	
	/// Processes the event by executing a specified callback.
	///
	/// This method allows for custom processing of event data, which is passed to the callback function. The `data` parameter contains information relevant to the event,
	/// though some events may lack associated data (hence, the optional `Any?` type).
	///
	/// - Parameter cb: A closure that processes the event's data. This callback accepts an optional `Any?` parameter representing the event's data.
	func handleWith(cb: @escaping @Sendable @MainActor (Any?) async -> Void)
	
	/// Provides a string that uniquely represents the type of the event.
	///
	/// This method should return a specific string that identifies the event type, enabling consistent event categorization and processing.
	///
	/// - Returns: A `String` representing the type of the event.
	static func typeStr() -> String
	
	associatedtype EventType: PMXEventType
	static var typeNum:EventType {get}
	
	/// Unique identifier for the connection associated with this event.
	///
	/// This property stores an `Int64` identifier that can be used to associate the event with a specific connection instance.
	var connectionId: Int64 { get }
	
	/// Retrieves the communication channel associated with this event.
	///
	/// This method provides the name or identifier of the channel related to the event, which can be useful for directing or filtering event handling based on channel context.
	///
	/// - Returns: A `String` representing the event's associated channel.
	func getChannel() -> String
	
	/// Retrieves the list of Subscribtion Ids of the Event
	func getSubscribtionList()->[String]
}

public protocol PMXThreadEvent:PMXEvent{}
public protocol PMXStoreEvent:PMXEvent{}
public protocol PMXInboxEvent:PMXEvent{}
public protocol PMXKvdbEvent:PMXEvent{}
public protocol PMXCustomEvent:PMXEvent{}

public protocol PMXEventType:RawRepresentable<Int64>{}
public struct PMXEventSelectorType:RawRepresentable{
	static var Context : Self {PMXEventSelectorType(rawValue: 0)!}
	static var Container : Self {PMXEventSelectorType(rawValue: 1)!}
	static var Item : Self {PMXEventSelectorType(rawValue: 2)!}
	
	public init?(rawValue: Int64) {
		switch (rawValue){
		case 0,1,2:
			self.rawValue=rawValue
		default:
			return nil
		}
	}
	
	public var rawValue: Int64
	
	public typealias RawValue = Int64
}

extension privmx.endpoint.store.EventType:PMXEventType{}

extension privmx.endpoint.thread.EventType:PMXEventType{}

extension privmx.endpoint.kvdb.EventType:PMXEventType{}

extension privmx.endpoint.inbox.EventType:PMXEventType{}

public enum PMXEventRegistration: Hashable{
	public static func == (lhs: PMXEventRegistration, rhs: PMXEventRegistration) -> Bool {
		lhs.getEventType().typeStr() == rhs.getEventType().typeStr() &&
		lhs.getSelectorType().rawValue == rhs.getSelectorType().rawValue &&
		lhs.getSelectorID() == rhs.getSelectorID()
}
	public func hash(into hasher: inout Hasher) {
		hasher.combine(getEventType().typeStr())
		hasher.combine(getSelectorType().rawValue)
		hasher.combine(getSelectorID())
	}
	
	case thread(eventType: any PMXThreadEvent.Type, selectorType: PMXEventSelectorType, selectorId:String)
	case store(eventType: any PMXStoreEvent.Type,selectorType: PMXEventSelectorType, selectorId:String)
	case inbox(eventType: any PMXInboxEvent.Type,selectorType: PMXEventSelectorType, selectorId:String)
	case kvdb(eventType: any PMXKvdbEvent.Type,selectorType: PMXEventSelectorType, selectorId:String)
	case custom(channelName:String, contextId:String)
	
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
	func getSelectorID(
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
