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

/// Protocol declaring methods of CryptoApi, with Swift Types
public protocol PrivMXCrypto{
	
	/// Generates a new Private Key
	///
	/// - Parameter baseString: Optional base for generating the key.
	///
	/// - Returns: WIF Private Key
	///
	/// - Throws: When the operation fails
	func privKeyNew(
		baseString: String?
	) throws -> String
	
	/// Derives a Public Key from the Private Key
	///
	/// - Parameter from  privKey: Optional base for generating the key.
	///
	/// - Returns: WIF Private Key
	///
	/// - Throws: When the operation fails
	func pubKeyNew(
		from keyPriv: String
	) throws -> String
	
	/// Deterministically generates a new Private Key from the provided strings
	///
	/// - Parameter password:
	/// - Parameter salt:
	///
	/// - Returns: WIF Private Key
	///
	/// - Throws: When the operation fails
	func privKeyNewPbkdf2(
		password: String,
		salt: String
	) throws -> String
	
	/// Creates a signature of the given data and Key
	///
	/// - Parameter data: Data to be signed
	/// - Parameter key: WIF Key to be used in the signing
	///
	/// - Returns: Signed Data
	///
	/// - Throws: When the operation fails
	func sign(
		data: Data,
		key: String
	) throws -> Data
	
	/// Encrypts data using AES.
	///
	/// - Parameter data: Data to be signed
	/// - Parameter key: 256bit binary data
	///
	/// - Returns: Encrypted data
	///
	/// - Throws: When the operation fails
	func encrypt(
		data: Data,
		key: Data
	) throws -> Data
	
	/// Decrypts data using AES.
	///
	/// - Parameter data: Data to be signed
	/// - Parameter key: 256bit binary data
	///
	/// - Returns: Encrypted data
	///
	/// - Throws: When the operation fails
	func decrypt(
		data: Data,
		key: Data
	) throws -> Data
	
	/// Converts a key from PEM format to WIF.
	///
	/// - Parameter kayPEM: key in PEM format
	///
	/// - Returns: Encrypted data
	///
	/// - Throws: When the operation fails
	func convertKeyPemToWIF(
		_ keyPEM: String
	) throws -> String
}

