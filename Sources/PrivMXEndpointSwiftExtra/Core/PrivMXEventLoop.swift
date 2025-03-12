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

/// `PrivMXEventLoop` is responsible for asynchronously managing and processing PrivMX events.
/// It acts as an event handler, receiving, parsing, and publishing events on a background loop.
final class PrivMXEventLoop: @unchecked Sendable{
	
	// MARK: - Properties
		
	/// The handler invoked whenever an event is received.
	let eventHandler: @Sendable (PMXEvent, PMXEvent.Type, Int64) -> Void
	
	/// Indicates whether the event loop is currently listening for events.
	public var isListening: Bool = false
		
	// MARK: - Initializer
	
	/// Initializes the `PrivMXEventLoop` with an event handler.
	///
	/// - Parameter eventHandler: Closure called when an event is received.
	init(eventHandler: @escaping @Sendable (PMXEvent, PMXEvent.Type, Int64) -> Void) {
		self.eventHandler = eventHandler
	}
	
	// MARK: - Public Methods
		
	/// Starts the asynchronous background event loop, setting `isListening` to `true`.
	/// The loop will continue until a termination event (e.g., `LibBreakEvent`) is detected.
    func startBackgroundLoop() {
		if isListening {return}
		
		Task {
			isListening = true
			var shouldFinish = false
			repeat {
				shouldFinish = await self.backgroundWork()
				try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
			} while !shouldFinish
			isListening = false
		}
		
	}
	
	/// Stops the event loop by emitting a break event.
	///
	/// - Throws: An error if the break event cannot be emitted.
	public func stopListening(
	) throws -> Void {
		Task{
			try EventQueue.getInstance().emitBreakEvent()
		}
	}

	
	// MARK: - Private Methods
    
    /// Performs the main background work by waiting for, parsing, and publishing events.
    ///
    /// - Returns: A `Bool` indicating if the loop should terminate.
	private func backgroundWork() async -> Bool {
		
		guard let q = try? EventQueue.getInstance() else {return true}
		if let (event, type) = try? await self.parseEvent(q.waitEvent()) {
			await publishToMainActor(event,type: type)
			return type.typeStr() == privmx.endpoint.core.LibBreakEvent.typeStr()
		} else { return false }
	}

	/// Publishes the received event to the main actor.
	///
	/// - Parameters:
	///   - event: The received `PMXEvent`.
	///   - type: The type of the received event.
	private func publishToMainActor(_ event: PMXEvent, type: PMXEvent.Type) async {
		eventHandler(event,type,event.connectionId)
	}
	
	/// Parses the provided event holder and returns the parsed event and its type if recognized.
    ///
    /// - Parameter eh: The event holder containing raw event data.
    /// - Returns: A tuple containing the parsed event and its type, or `nil` if parsing fails.
    nonisolated private func parseEvent  (
		_ eh: privmx.endpoint.core.EventHolder
	) async  throws -> (event:any PMXEvent,type: any PMXEvent.Type)? {
		var x :any PMXEvent
		if try EventHandler.isLibConnectedEvent(eventHolder: eh){
			x = try EventHandler.extractLibConnectedEvent(eventHolder: eh)
		}else if try EventHandler.isLibDisconnectedEvent(eventHolder: eh){
			x = try EventHandler.extractLibDisconnectedEvent(eventHolder: eh)
		}else if try EventHandler.isLibPlatformDisconnectedEvent(eventHolder: eh){
			x = try EventHandler.extractLibPlatformDisconnectedEvent(eventHolder: eh)
		}else if try EventHandler.isThreadCreatedEvent(eventHolder: eh){
			x = try EventHandler.extractThreadCreatedEvent(eventHolder: eh)
		}else if try EventHandler.isThreadUpdatedEvent(eventHolder: eh){
			x = try EventHandler.extractThreadUpdatedEvent(eventHolder: eh)
		}else if try EventHandler.isThreadDeletedEvent(eventHolder: eh){
			x = try EventHandler.extractThreadDeletedEvent(eventHolder: eh)
		}else if try EventHandler.isThreadStatsEvent(eventHolder: eh){
			x = try EventHandler.extractThreadStatsEvent(eventHolder: eh)
		}else if try EventHandler.isThreadNewMessageEvent(eventHolder: eh){
			x = try EventHandler.extractThreadNewMessageEvent(eventHolder: eh)
		}else if try EventHandler.isThreadMessageDeletedEvent(eventHolder: eh){
			x = try EventHandler.extractThreadMessageDeletedEvent(eventHolder: eh)
		}else if try EventHandler.isThreadMessageUpdatedEvent(eventHolder: eh){
			x = try EventHandler.extractThreadMessageUpdatedEvent(eventHolder: eh)
		}else if try EventHandler.isStoreCreatedEvent(eventHolder: eh){
			x = try EventHandler.extractStoreCreatedEvent(eventHolder: eh)
		}else if try EventHandler.isStoreUpdatedEvent(eventHolder: eh){
			x = try EventHandler.extractStoreUpdatedEvent(eventHolder: eh)
		}else if try EventHandler.isStoreDeletedEvent(eventHolder: eh){
			x = try EventHandler.extractStoreDeletedEvent(eventHolder: eh)
		}else if try EventHandler.isStoreStatsChangedEvent(eventHolder: eh){
			x = try EventHandler.extractStoreStatsChangedEvent(eventHolder: eh)
		}else if try EventHandler.isStoreFileCreatedEvent(eventHolder: eh){
			x = try EventHandler.extractStoreFileCreatedEvent(eventHolder: eh)
		}else if try EventHandler.isStoreFileDeletedEvent(eventHolder: eh){
			x = try EventHandler.extractStoreFileDeletedEvent(eventHolder: eh)
		}else if try EventHandler.isStoreFileUpdatedEvent(eventHolder: eh){
			x = try EventHandler.extractStoreFileUpdatedEvent(eventHolder: eh)
		} else if try EventHandler.isInboxCreatedEvent(eventHolder: eh){
			x = try EventHandler.extractInboxCreatedEvent(eventHolder: eh)
		} else if try EventHandler.isInboxUpdatedEvent(eventHolder: eh){
			x = try EventHandler.extractInboxUpdatedEvent(eventHolder: eh)
		} else if try EventHandler.isInboxDeletedEvent(eventHolder: eh){
			x = try EventHandler.extractInboxDeletedEvent(eventHolder: eh)
		} else if try EventHandler.isInboxEntryCreatedEvent(eventHolder: eh){
			x = try EventHandler.extractInboxEntryCreatedEvent(eventHolder: eh)
		} else if try EventHandler.isInboxEntryDeletedEvent(eventHolder: eh){
			x = try EventHandler.extractInboxEntryDeletedEvent(eventHolder: eh)
		} else if try EventHandler.isLibBreakEvent(eventHolder: eh){
			x = try EventHandler.extractLibBreakEvent(eventHolder: eh)
		} else {
			return nil
		}
		return (event:x,type: type(of: x))
	}
	
	/// Represents a parsed event with its type and associated channel.
    private struct ParsedEvent{
		init(_ e:any PMXEvent, _ t: any PMXEvent.Type,_ c : String){
			type = t
			event = e
			channel = c
		}
		var event:any PMXEvent
		var type: any PMXEvent.Type
		var channel:String
	}
}
