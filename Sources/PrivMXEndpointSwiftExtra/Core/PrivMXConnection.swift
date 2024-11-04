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
import PrivMXEndpointSwift

/// The `PrivMXConnection` protocol declares methods for managing connections to PrivMX Bridge with Swift types.
///
/// This protocol defines the required methods for setting up, managing, and disconnecting a connection to PrivMX platform.
/// It provides functionality for setting up the path to SSL certificates, managing connection lifecycle (connect/disconnect),
/// and retrieving important connection details such as the connection ID. Additionally, it offers methods for connecting with public or private access.
///
/// ## Key Features:
///
/// - **Certificate Management:** Supports setting the path to a `.pem` file containing the necessary SSL certificates for establishing a secure connection.
/// - **Connection Lifecycle:** Provides methods for connecting to and disconnecting from PrivMX Bridge.
/// - **Connection Identification:** Retrieves the unique connection ID for identifying the connection.
/// - **Context Access:** Lists the contexts to which the connected user has access.
///
/// ## Methods:
///
/// - `setCertsPath(_:)`: Sets the path to the `.pem` file containing the certificates needed for establishing the connection.
/// - `disconnect()`: Disconnects the current connection, releasing all resources associated with it.
/// - `connect(as:to:on:)`: Connects to PrivMX Bridge using the provided credentials (private key, solution ID, platform URL).
/// - `connectPublic(to:on:)`: Connects to PrivMX Bridge with public access, mainly used for public access to `InboxAPI`.
/// - `getConnectionId()`: Retrieves the unique connection ID for managing and identifying the current connection.
/// - `listContexts(basedOn:)`: Lists the contexts that the connected user has access to.
///
/// ## Usage:
///
/// This protocol is implemented by classes that establish and manage connections to PrivMX system, providing a common interface for interacting
/// with various aspects of PrivMX platform, including API access and connection management.
public protocol PrivMXConnection{
	
	
	/// Sets path to .pem file with certificates needed for establishing connection. This certificates depends on your Bridge setup.
	///
	/// - Parameter path: Path to the .pem file
	///
	/// - Throws: `PrivMXEndpointError.failedSettingCerts` if an exception was thrown in C++ code, or another error occurred.
	static func setCertsPath(
		_ path: String
	) throws -> Void
	
	/// Disconnects current connection.
	///
	/// Calling this function finished usage of PrivMXConnection object.
	func disconnect(
	) throws -> Void
	
	/// Connects with provided credentials to PrivMX Bridge.
	///
	/// - Parameters:
	/// 	- userPrivKey: User's Private Key in WIF format
	/// 	- solutionID: Unique Solution Identifier defined at PrivMX Bridge
	/// 	- platformUrl: URL of PrivMX Bridge Instance
	/// - Returns: new Connection object which can be used for initializing proper PrivMX Endpoint APIs
	/// - Throws: Any Connection Exceptions
	static func connect(
		as userPrivKey: String,
		to solutionID: String,
		on bridgeUrl: String
	) throws -> any PrivMXConnection
	
	/// Connects with public access to PrivMX Bridge. It is used mainly for public access to `InboxApi`.
	///
	/// - Parameters:
	/// 	- solutionID: Unique Solution Identifier defined at  PrivMX Bridge
	/// 	- platformUrl: URL of PrivMX Bridge Instance
	/// - Returns: new Connection object which can be used for initializing  PrivMX `InboxApi`.
	/// - Throws: Any Connection Exceptions
	static func connectPublic(
		to solutionID: String,
		on bridgeUrl: String
	) throws -> any PrivMXConnection
	
	/// Returns current Connection ID.
	///
	/// - Returns: Current Connection ID. Used for managing and identifying connections.
	/// - Throws: Any connection Exceptions
	func getConnectionId(
	) throws -> Int64
	
	/// Lists Contexts to which the connected user has access.
	///
	/// - Parameter query: Object holding parameters of the query
	///
	/// - Returns: Structure containing all Contexts user has access to.
	///
	/// - Throws: Any Exceptions
	func listContexts(
		basedOn query: privmx.endpoint.core.PagingQuery
	) throws -> privmx.ContextList
}

