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
/// Do not conform to this protocol on your own.
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
	/// 	- bridgeUrl: URL of PrivMX Bridge Instance
	/// 	- verificationOptions: URL of PrivMX Bridge Instance
	/// - Returns: new Connection object which can be used for initializing proper PrivMX Endpoint APIs
	/// - Throws: Any Connection Exceptions
	static func connect(
		as userPrivKey: String,
		to solutionID: String,
		on bridgeUrl: String,
		setting verificationOptions: privmx.endpoint.core.PKIVerificationOptions
	) throws -> any PrivMXConnection
	
	/// Connects with public access to PrivMX Bridge. It is used mainly for public access to `InboxApi`.
	///
	/// - Parameters:
	/// 	- solutionID: Unique Solution Identifier defined at  PrivMX Bridge
	/// 	- platformUrl: URL of PrivMX Bridge Instance
	/// 	- platformUrl: URL of PrivMX Bridge Instance
	/// - Returns: new Connection object which can be used for initializing  PrivMX `InboxApi`.
	/// - Throws: Any Connection Exceptions
	static func connectPublic(
		to solutionID: String,
		on bridgeUrl: String,
		setting verificationOptions: privmx.endpoint.core.PKIVerificationOptions
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
	
	/// Sets user’s custom verification callback.
	///
	/// Use this to set up verification with a PKI server.
	///
	/// - Parameter verifierImplementation: Callback that will be called for each verification request by the C++ library. It takes a C++ `std.vector` of
	/// ``privmx.endpoint.core.VerificationRequest`` objects, exposed to swift as `privmx.VerificationRequestVector` and returns a `std.vector` of `bool`s
	/// corresponding to the verification results.
	func setUserVerifier(
		_ verifierImplementation: privmx.VerificationImplementation
	) throws -> Void
}

