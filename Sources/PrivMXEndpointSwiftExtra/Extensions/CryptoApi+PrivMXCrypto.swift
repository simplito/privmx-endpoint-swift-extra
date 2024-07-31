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
import PrivMXEndpointSwift
import PrivMXEndpointSwiftNative

extension CryptoApi: PrivMXCrypto{
	
	/// Generates a new Private Key
	///
	/// - Parameter baseString: Optional base for generating the key.
	///
	/// - Returns: WIF Private Key
	///
	/// - Throws: `PrivMXEndpointError.failedGeneratingPrivKey` if an exception was thrown in C++ code, or another error occurred.
	public func privKeyNew(
		baseString: String?
	) throws -> String {
		if let baseString = baseString{
			return try String(privKeyNew(baseString: baseString))
		} else {
			return try String(privKeyNew(baseString: nil) as std.string)
		}
		
	}
	
	/// Derives a Public Key from the Private Key
	///
	/// - Parameter from  privKey: Optional base for generating the key.
	///
	/// - Returns: WIF Private Key
	///
	/// - Throws: `PrivMXEndpointError.failedGeneratingPrivKey` if an exception was thrown in C++ code, or another error occurred.
	public func pubKeyNew(
		from keyPriv: String
	) throws -> String {
		try String(pubKeyNew(from: std.string(keyPriv)))
	}
	
	/// Deterministically generates a new Private Key from the provided strings
	///
	/// - Parameter password:
	/// - Parameter salt:
	///
	/// - Returns: WIF Private Key
	///
	/// - Throws: `PrivMXEndpointError.failedGeneratingPrivKey` if an exception was thrown in C++ code, or another error occurred.
	public func privKeyNewPbkdf2(
		password: String,
		salt: String
	) throws -> String {
		try String(privKeyNewPbkdf2(password: std.string(password),
									salt: std.string(salt)))
	}
	
	/// Creates a signature of the given data and Key
	///
	/// - Parameter data: Data to be signed
	/// - Parameter key: WIF Key to be used in the signing
	///
	/// - Returns: Signed Data
	///
	/// - Throws: `PrivMXEndpointError.failedSigning` if an exception was thrown in C++ code, or another error occurred.
	public func sign(
		data: Data,
		key: String
	) throws -> Data {
		try Data(from: sign(data: data.asBuffer(),
							key: std.string(key)))
	}
	
	/// Encrypts data using AES.
	///
	/// - Parameter data: Data to be signed
	/// - Parameter key: 256bit binary data
	///
	/// - Returns: Encrypted data
	///
	/// - Throws: `PrivMXEndpointError.failedEncrypting` if an exception was thrown in C++ code, or another error occurred.
	public func encrypt(data: Data, key: Data) throws -> Data {
		try Data(from: encrypt(data: data.asBuffer(),
							   key: key.asBuffer()))
	}
	
	/// Decrypts data using AES.
	///
	/// - Parameter data: Data to be signed
	/// - Parameter key: 256bit binary data
	///
	/// - Returns: Encrypted data
	///
	/// - Throws: `PrivMXEndpointError.failedDecrypting` if an exception was thrown in C++ code, or another error occurred.
	public func decrypt(
		data: Data, /// test
		key: Data
	) throws -> Data {
		try Data(from: decrypt(data: data.asBuffer(),
							   key: key.asBuffer()))
	}
	
	/// Converts a key from PEM format to WIF.
	///
	/// - Parameter kayPEM: key in PEM format
	///
	/// - Returns: Encrypted data
	///
	/// - Throws: `PrivMXEndpointError.failedEncrypting` if an exception was thrown in C++ code, or another error occurred.
	public func convertKeyPemToWIF(
		_ keyPEM: String
	) throws -> String {
		try String(self.convertKeyPEMToWIF(std.string(keyPEM)))
	}
}
