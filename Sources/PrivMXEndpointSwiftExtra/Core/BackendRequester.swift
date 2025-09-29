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

extension BackendRequester {

	/// Performs a backend request to PrivMX Bridge.
	///
	/// This method sends a request to PrivMX Bridge using its REST API with the appropriate authorization. 
	/// The full Bridge API can be accessed using this method. The request is authenticated using a server token, 
	/// and parameters are provided in JSON format.
	///
	/// - Parameters:
	///   - serverUrl: The URL of PrivMX Bridge server.
	///   - memberToken: The authentication token provided by the server.
	///   - method: The API endpoint to be called (HTTP method, such as POST, GET, etc.).
	///   - paramsAsJson: The parameters to be sent with the request, formatted as a JSON string.
	///
	/// - Returns: The result body as a `String`, representing the response from the backend.
	///
	/// - Throws: An error if the request fails, such as network issues or invalid parameters.
	public static func backendRequest(
		serverUrl: String,
		accessToken: String,
		method: String,
		paramsAsJson: String
	) throws -> String {
		try String(
			Self.backendRequest(
				serverUrl: std.string(serverUrl),
				accessToken: std.string(accessToken),
				method: std.string(method),
				paramsAsJson: std.string(paramsAsJson)))
	}

	@available(*, deprecated, renamed: "backendRequest(serverUrl:memberToken:method:paramsAsJson:)")
	public static func backendRequest(
		serverUrl: String,
		memberToken: String,
		method: String,
		paramsAsJson: String
	) throws -> String {
		try String(
			Self.backendRequest(
				serverUrl: std.string(serverUrl),
				accessToken: std.string(memberToken),
				method: std.string(method),
				paramsAsJson: std.string(paramsAsJson)))
	}

	/// Performs a backend request to the PrivMX Bridge.
	///
	/// This method sends a request to the PrivMX Bridge using its REST API..
	/// The parameters are provided in JSON format.
	///
	/// - Parameters:
	///   - serverUrl: The URL of the PrivMX Bridge server.
	///   - method: The API endpoint to be called (HTTP method, such as POST, GET, etc.).
	///   - paramsAsJson: The parameters to be sent with the request, formatted as a JSON string.
	///
	/// - Returns: The result body as a `String`, representing the response from the backend.
	///
	/// - Throws: An error if the request fails, such as network issues or invalid parameters.
	public static func backendRequest(
		serverUrl: String,
		method: String,
		paramsAsJson: String
	) throws -> String {
		try String(
			Self.backendRequest(
				serverUrl: std.string(serverUrl),
				method: std.string(method),
				paramsAsJson: std.string(paramsAsJson)))
	}
	
	/// Performs a backend request to the PrivMX Bridge.
	///
	/// This method sends a request to the PrivMX Bridge using its REST API with the appropriate authorization.
	/// The full Bridge API can be accessed using this method. The request is authenticated using a server token,
	/// and parameters are provided in JSON format.
	///
	/// - Parameters:
	///   - serverUrl: PrivMX Bridge server URL
	///   - apiKeyId: API KEY ID (see PrivMX Bridge API for more details)
	///   - apiKeySecret: API KEY SECRET (see PrivMX Bridge API for more details)
	///   - mode: allows you to set whether the request should be signed (mode = 1) or plain (mode = 0)
	///   - method: API method to call
	///   - paramsAsJson: API method's parameters in JSON format
	///
	/// - Returns: The result body as a `String`, representing the response from the backend.
	///
	/// - Throws: An error if the request fails, such as network issues or invalid parameters.
	public static func backendRequest(
		serverUrl: String,
		apiKeyId: String,
		apiKeySecret: String,
		mode: Int64,
		method: String,
		paramsAsJson: String
	) throws -> String {
		try String(
			Self.backendRequest(serverUrl: std.string(serverUrl),
								apiKeyId: std.string(apiKeyId),
								apiKeySecret: std.string(apiKeySecret),
								mode: mode,
								method: std.string(method),
								paramsAsJson: std.string(paramsAsJson)))
	}
}
