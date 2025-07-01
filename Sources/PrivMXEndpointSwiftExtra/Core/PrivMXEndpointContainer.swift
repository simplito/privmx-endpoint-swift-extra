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
 
/// The `PrivMXEndpointContainer` class serves as the central management component for handling multiple
/// `PrivMXEndpoint` instances within PrivMX system. It is responsible for initializing, managing, and
/// disconnecting PrivMX Endpoints, as well as providing cryptographic services and event handling capabilities.
///
/// This class operates in a concurrent environment with support for handling cryptographic operations, managing
/// secure communication endpoints, and listening for events. It also supports asynchronous endpoint creation,
/// disconnection, and event processing.
public final class PrivMXEndpointContainer: Sendable{
	nonisolated(unsafe) var eventLoop: PrivMXEventLoop?
	
	public init(){
		
	}
	
	/// Provides access to cryptographic operations via `PrivMXCrypto`.
	nonisolated(unsafe) public private(set) var cryptoApi:PrivMXCrypto = CryptoApi.create()
	
	/// A dictionary containing `PrivMXEndpoint` instances, keyed by their connection IDs.
	nonisolated(unsafe) private var endpoints: [Int64:PrivMXEndpoint] = [:]
	
	/// Retrieves an `PrivMXEndpoint` instance from the container based on its ID.
	///
	/// - Parameter id: The connection ID of the desired `PrivMXEndpoint`.
	///
	/// - Returns: The `PrivMXEndpoint` with the specified ID, if it exists; otherwise, returns `nil`.
	public func getEndpoint(
		_ id: Int64
	) -> PrivMXEndpoint? {
		return endpoints[id]
	}
	
	/// Returns an array of all connected `PrivMXEndpoint` IDs.
	///
	/// This is useful when managing multiple  `PrivMXEndpoint`s and retrieving their connection IDs.
	///
	/// - Returns: An array of connection IDs for all connected endpoints.
	public func getEndpointIds(
	) -> [Int64] {
		[Int64](endpoints.keys)
	}
	
	/// Initializes a new `PrivMXEndpoint` and adds it to the container.
	///
	/// This method creates a new `PrivMXEndpoint` with the specified modules, user credentials, and platform details, 
	/// and adds it to the `endpoints` dictionary.
	///
	/// - Parameters:
	///   - modules: A set of modules to be initialized with the new endpoint.
	///   - userPrivKey: The user's private key in WIF format.
	///   - solutionId: The unique identifier of PrivMX solution.
	///   - bridgeUrl: The URL of PrivMX Bridge.
	///
	/// - Throws: An error if creating the new endpoint fails.
	///
	/// - Returns: The newly created `PrivMXEndpoint` instance.
	public func newEndpoint(
		enabling modules:Set<PrivMXModule>,
		connectingAs userPrivKey:String,
		to solutionId:String,
		on bridgeUrl:String
	) async throws -> PrivMXEndpoint {
		let ne = try PrivMXEndpoint(modules: modules,
									   userPrivKey: userPrivKey,
									   solutionId: solutionId,
									   bridgeUrl: bridgeUrl)
		endpoints[try ne.connection.getConnectionId()] = ne
		return ne
	}
	
	/// Initializes a new `PrivMXEndpoint` and adds it to the container.
	///
	/// This method creates a new `PrivMXEndpoint` with the specified modules and platform details,
	/// and adds it to the `endpoints` dictionary.
	/// Note it is only useful for
	///
	/// - Parameter modules: A set of modules to be initialized with the new endpoint.
	/// - Parameter solutionId: The unique identifier of the PrivMX solution.
	/// - Parameter bridgeUrl: The URL of the PrivMX Bridge.
	///
	/// - Throws: An error if creating the new endpoint fails.
	///
	/// - Returns: The newly created `PrivMXEndpoint` instance.
	public func newPublicEndpoint(
		enabling modules:Set<PrivMXModule>,
		to solutionId:String,
		on bridgeUrl:String
	) async throws -> PrivMXEndpoint {
		let ne = try PrivMXEndpoint(modules: modules,
									solutionId: solutionId,
									bridgeUrl: bridgeUrl)
		endpoints[try ne.connection.getConnectionId()] = ne
		return ne
	}
	
	/// Disconnects and removes a `PrivMXEndpoint` from the container.
	///
	/// This method terminates the connection of the specified `PrivMXEndpoint` and removes it from the container.
	///
	/// - Parameter endpoint: The connection ID of the endpoint to be disconnected.
	///
	/// - Throws: An error if disconnecting the endpoint fails.
	public func disconnect(
		endpoint: Int64
	) throws -> Void {
		let e = endpoints.removeValue(forKey: endpoint)
		try e?.connection.disconnect()
	}
	
	/// Disconnects and removes all `PrivMXEndpoint`s from the container.
	///
	/// This method terminates the connections of all `PrivMXEndpoint`s managed by the container and clears the container.
	///
	/// - Throws: An error if disconnecting any endpoint fails.
	public func disconnectAll(
	) throws -> Void {
		for e in endpoints.values {
			try e.connection.disconnect()
		}
	}
	
	/// Sets the path to the `.pem` file containing the certificates required for establishing secure connections.
	///
	/// This method configures the path to the certificates needed for secure communication with PrivMX Bridge. 
	/// The exact certificates depend on your Bridge setup.
	///
	/// - Parameter path: The file path to the `.pem` certificate file.
	///
	/// - Throws: `PrivMXEndpointError.failedSettingCerts` if setting the certificates fails.
	public func setCertsPath(
		to path: String
	) throws -> Void {
		try Connection.setCertsPath(path)
	}
	
	/// Stops listening for events but does not remove event listeners.
	///
	/// This method emits a "break" event to pause event listening without removing the registered listeners.
	///
	/// - Throws: An error if stopping event listening fails.
	public func stopListening(
	) async throws  -> Void {
			try self.eventLoop?.stopListening()
	}
	
	/// Starts listening for events in PrivMX system.
	///
	/// This method begins listening for events such as updates or notifications within PrivMX system. 
	/// If the listener is already running, an error will be thrown.
	///
	/// - Throws: `PrivMXEndpointError.otherFailure` if event listening is already running.
	public func startListening() async throws {
			if eventLoop == nil {
				eventLoop = PrivMXEventLoop(){ event, eventType, connectionID in
						try? await self.endpoints[connectionID]?.handleEvent(event, ofType: eventType)
				}
			}
			
			guard let el = eventLoop else {
				var err = privmx.InternalError()
				err.message = "Cannot access Event Loop"
				err.name = "Event Listener Error"
				throw PrivMXEndpointError.otherFailure(err)
			}
		
			// Run the event loop's background task
			el.startBackgroundLoop()
			
		}
	
	
	func processEvent(event:PMXEvent, eventType:PMXEvent.Type, connectionID:Int64) async{
		try? await self.getEndpoint(connectionID)?.handleEvent(event, ofType: eventType)
	}
    
	
}
