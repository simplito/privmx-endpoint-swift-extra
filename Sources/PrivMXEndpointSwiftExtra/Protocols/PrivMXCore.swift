//
// PrivMX Endpoint Swift Extra
// Copyright © 2024 Simplito sp. z o.o.
//
// This file is part of the PrivMX Platform (https://privmx.cloud).
// This software is Licensed under the MIT License.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import PrivMXEndpointSwiftNative
import PrivMXEndpointSwift

/// Protocol declaring methods of CoreApi, with Swift Types
public protocol PrivMXCore{
	
	
	/// Sets path to .pem file with certificates.
	///
	/// - Parameter path: Path to the .pem file
	///
	/// - Throws: When the operation fails
	static func setCertsPath(
		_ path: String
	) throws -> Void
	
	/// Severs the connection to PrivMX Platform.
	///
	/// Calling this function makes the CoreApi instance on which it was called, as well as any instances of StoreApi and ThreadApi created using it, completely useless.
	///
	/// - Parameter channel: Which events should start arriving
	///
	/// - Returns: An object holding an event, that needs to be extracted
	///
	/// - Throws: When the operation fails
	func disconnect(
	) throws -> Void
	
	/// Subscribes to a data channel to listen for events
	///
	///The available channels are:
	///
	/// "thread2" for events regarding threads;
	///
	/// "store" for events regarding stores;
	///
	/// "thread2/[threadId]/messages" for events regarding messages in a particular thread;
	///
	/// "store/[storeId]/files" for files in a particular store.
	///
	/// - Parameter channel: Which events should start arriving
	///
	/// - Throws: When the operation fails
	func subscribeToChannel(
		_ channel:String
	) throws -> Void
	
	/// Ceases listening for events from the specified channel
	///
	///The available channels are:
	///
	/// "thread2" for events regarding threads;
	///
	/// "store" for events regarding stores;
	///
	/// "thread2/[threadId]/messages" for events regarding messages in a particular thread;
	///
	/// "store/[storeId]/files" for files in a particular store.
	///
	///
	/// - Parameter channel: Which events should start arriving
	///
	/// - Throws: When the operation fails
	func unsubscribeFromChannel(
		_ channel:String
	) throws -> Void
	
	/// Waits for next event.
	///
	/// This function will wait untill a new event arrives. However, should there be unprocesed Events, it will return first one of those.
	/// The returned object should be first queried with the `is*Event` methods, and extracted with an appropriate method thereafter.
	///
	/// - Parameter channel: Which events should start arriving
	///
	/// - Returns: An object holding an event, that needs to be extracted
	///
	/// - Throws: When the operation fails
	func waitEvent(
	) throws -> privmx.endpoint.core.EventHolder
	
	/// Attempts to retrieve an event.
	///
	/// This function, unlike`waitEvent()`, attempts to retrieve first unprocessed event. Should there be no such events, it will simply return `nil`.
	/// The returned object should be first queried with the `is*Event` methods, and extracted with an appropriate method thereafter.
	///
	/// - Parameter channel: Which events should start arriving
	///
	/// - Returns: An object holding an event, that needs to be extracted, or Nil, if there were no events to get.
	///
	/// - Throws: When the operation fails
	func getEvent(
	) throws -> privmx.endpoint.core.EventHolder?
	
	/// Lists contexts to which the connected user has access.
	///
	/// - Parameter query: Object holding parameters of the query
	///
	/// - Returns: Structure containing the total amount of Contexts and a vector of retrieved Contexts.
	///
	/// - Throws: When the operation fails
	func listContexts(
		query: privmx.endpoint.core.ListQuery
	)throws -> privmx.endpoint.core.ContextsList
}

