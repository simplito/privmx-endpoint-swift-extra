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

/// An extension for `PrivMXCrypto` that provides a helper method to sign data in Base64 format.
public extension PrivMXCrypto {

	/// Signs the provided Base64-encoded string using the given key.
	///
	/// This function converts the input string to `Data` using UTF-8 encoding, signs the data
	/// using the provided key, and returns the signature as a Base64-encoded string.
	///
	/// - Parameters:
	///   - data: The input string to be signed, which will be converted to `Data` using UTF-8 encoding.
	///   - key: The key used to sign the input data.
	///
	/// - Throws: `PrivMXEndpointError.failedSigning` if the string cannot be encoded to `Data` or the signing process fails.
	///
	/// - Returns: A Base64-encoded string representing the signature of the input data.
	func signBase64(
		data: String,
		key: String
	) throws -> String {
		if let data = data.data(using: .utf8) {
			return try signData(data, with: key).base64EncodedString()
		} else {
			var err = privmx.InternalError()
			err.message = "Base64 encoding failed"
			err.name = "Crypto Error"
			throw PrivMXEndpointError.failedSigning(err)
		}
	}
}
