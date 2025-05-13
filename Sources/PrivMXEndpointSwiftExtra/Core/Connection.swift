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

import Cxx
import CxxStdlib
import Foundation
import PrivMXEndpointSwift
import PrivMXEndpointSwiftNative

/// Extension of `Connection`, providing methods for connecting to PrivMX Bridge and managing Contexts.
extension Connection: PrivMXConnection {
	
	/// Lists all available Contexts for the authorized user in the current Solution.
	///
	/// This method retrieves a list of Contexts available to the user, filtered according to the provided query.
	///
	/// - Parameter query: A `PagingQuery` object to filter the list of Contexts.
	///
	/// - Returns: A `privmx.endpoint.core.ContextList` instance containing the list of Contexts.
	///
	/// - Throws: An error if the request fails or if access is denied.
	public func listContexts(
		basedOn query: privmx.endpoint.core.PagingQuery
	) throws -> privmx.ContextList {
		try self.listContexts(query: query)
	}
	
	/// Establishes an authorized connection to PrivMX Bridge.
	///
	/// This method initiates a secured connection to PrivMX Bridge using the user's private key. 
	/// The connection allows for the execution of secured operations within a specified Solution.
	///
	/// - Parameter  userPrivKey: The user's private key used for authentication (WIF format).
	/// - Parameter solutionID: The unique identifier of the Solution to connect to.
	/// - Parameter bridgeUrl: The URL of PrivMX Bridge to connect to.
	/// - Parameter verificationOptions: Options used to verify if Bridge on given url is the one you expect.
	///
	/// - Returns: A new `PrivMXConnection` instance representing the established connection.
	///
	/// - Throws: An error if the connection process fails or if the provided credentials are invalid.
	public static func connect(
		as userPrivKey: String,
		to solutionID: String,
		on bridgeUrl: String,
		setting verificationOptions: privmx.endpoint.core.PKIVerificationOptions = privmx.endpoint.core.PKIVerificationOptions()
	) throws -> any PrivMXConnection {
		try Self.connect(
			userPrivKey: std.string(userPrivKey),
			solutionId: std.string(solutionID),
			bridgeUrl: std.string(bridgeUrl),
			verificationOptions: verificationOptions)
	}

	/// Establishes a public connection to PrivMX Bridge.
	///
	/// This method initiates a public connection to PrivMX Bridge, which is typically used for operations that do not require authentication, such as handling inbound traffic to an Inbox.
	///
	/// - Parameter solutionID: The unique identifier of the Solution to connect to.
	/// - Parameter bridgeUrl: The URL of PrivMX Bridge to connect to.
	/// - Parameter verificationOptions: Options used to verify if Bridge on given url is the one you expect.
	///
	/// - Returns: A new `PrivMXConnection` instance representing the public connection.
	///
	/// - Throws: An error if the connection process fails.
	public static func connectPublic(
		to solutionID: String,
		on bridgeUrl: String,
		setting verificationOptions: privmx.endpoint.core.PKIVerificationOptions = privmx.endpoint.core.PKIVerificationOptions()
	) throws -> any PrivMXConnection {
		try Self.connectPublic(
			solutionId: std.string(solutionID),
			bridgeUrl: std.string(bridgeUrl),
			verificationOptions: verificationOptions)
	}

	/// Sets the path to the `.pem` file containing certificates required for establishing a connection.
	///
	/// This method configures the path to a `.pem` file with certificates necessary to authenticate the connection. 
	/// The required certificates depend on the specific setup of PrivMX Bridge.
	///
	/// - Parameter path: The path to the `.pem` file containing the required certificates.
	///
	/// - Throws: `PrivMXEndpointError.failedSettingCerts` if the certificate configuration fails.
	public static func setCertsPath(
		_ path: String
	) throws {
		try Self.setCertsPath(std.string(path))
	}
	
	/// Sets user’s custom verification callback.
	///
	/// Use this to set up verification with a PKI server.
	///
	/// - Parameter verifierImplementation: Callback that will be called for each verification request by the C++ library. It takes a C++ `std.vector` of
	/// ``privmx.endpoint.core.VerificationRequest`` objects, exposed to swift as `privmx.VerificationRequestVector` and returns a `std.vector` of `bool`s
	/// corresponding to the verification results.
	public func setUserVerifier(
		_ verifierImplementation: privmx.VerificationImplementation
	) throws -> Void {
		try self.setUserVerifier(verifier: privmx.UserVerifier(verifierImplementation))
	}
}
