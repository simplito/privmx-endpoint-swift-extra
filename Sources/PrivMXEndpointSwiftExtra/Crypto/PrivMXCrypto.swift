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

/// Protocol declaring cryptographic operations using Swift types.
public protocol PrivMXCrypto{
	
	/// Generates a new Private Key, which can be used for accessing PrivMX Bridge.
	///
	/// This method generates a private key using an optional base string (seed) for added randomness.
	/// The generated key is returned in WIF (Wallet Import Format).
	///
	/// - Parameter randomSeed: An optional seed string to generate the private key. If `nil`, a random seed is used.
	///
	/// - Returns: A WIF formatted private key as a `String`.
	///
	/// - Throws: `PrivMXEndpointError.failedGeneratingPrivKey` if the key generation fails or an error occurs in the C++ layer.
	func generatePrivateKey(
		withSeed randomSeed: String?
	) throws -> String
	
	
	/// Generates a new Symmetric Key for AES encryption.
	///
	/// This method creates a 256-bit symmetric key, which can be used for AES encryption and decryption.
	///
	/// - Returns: A 256-bit symmetric key as `Data`.
	///
	/// - Throws: `PrivMXEndpointError.failedGeneratingPrivKey` if key generation fails or if any errors occur in the C++ code.
	func generateKeySymmetric(
	) throws -> Data
	
	
	/// Derives a Public Key from a given Private Key.
	///
	/// This method derives the corresponding public key from a provided private key, formatted in WIF.
	///
	/// - Parameter keyPriv: The private key in WIF format (Wallet Import Format) from which the public key will be derived.
	///
	/// - Returns: The derived public key as a `String`.
	///
	/// - Throws: `PrivMXEndpointError.failedGeneratingPrivKey` if the key derivation process fails.
	func derivePublicKey(
		from keyPriv: String
	) throws -> String
	
	/// Deterministically derives a Private Key from a password and salt.
	///
	/// This method generates a private key using a combination of a password and salt.
	/// The resulting private key is derived in a deterministic way, ensuring the same password and salt
	/// will always produce the same private key.
	///
	/// - Parameters:
	///   - password: The base string (password) used for private key generation.
	///   - salt: A string used as salt for private key generation.
	///
	/// - Returns: The derived private key in WIF format (Wallet Import Format) as a `String`.
	///
	/// - Throws: `PrivMXEndpointError.failedGeneratingPrivKey` if the derivation fails.
	@available(*, deprecated, renamed: "derivePrivateKey2(from:and:)")
	func derivePrivateKey(
		from password: String,
		and salt: String
	) throws -> String
	
	/// Deterministically derives a Private Key from a password and salt.
	///
	/// This method generates a private key using a combination of a password and salt.
	/// The resulting private key is derived in a deterministic way, ensuring the same password and salt
	/// will always produce the same private key.
	///
	/// - Parameters:
	///   - password: The base string (password) used for private key generation.
	///   - salt: A string used as salt for private key generation.
	///
	/// - Returns: The derived private key in WIF format (Wallet Import Format) as a `String`.
	///
	/// - Throws: `PrivMXEndpointError.failedGeneratingPrivKey` if the derivation fails.
	func derivePrivateKey2(
		from password: String,
		and salt: String
	) throws -> String
	
	/// Signs the given data using a Private Key.
	///
	/// This method creates a digital signature for the provided data using a specified private key (in WIF format).
	///
	/// - Parameters:
	///   - data: The data to be signed, provided as `Data`.
	///   - privateKey: The private key (WIF format) used for signing the data.
	///
	/// - Returns: The signed data as `Data`.
	///
	/// - Throws: `PrivMXEndpointError.failedSigning` if the signing operation fails.
	func signData(
		_ data: Data,
		with privateKey: String
	) throws -> Data
	
	/// Encrypts data using AES symmetric encryption.
	///
	/// This method encrypts the provided data using AES encryption with a 256-bit symmetric key.
	///
	/// - Parameters:
	///   - data: The data to be encrypted, provided as `Data`.
	///   - symmetricKey: The 256-bit symmetric key used for AES encryption.
	///
	/// - Returns: The encrypted data as `Data`.
	///
	/// - Throws: `PrivMXEndpointError.failedEncrypting` if the encryption process fails.
	func encryptDataSymmetric(
		_ data: Data,
		with symmetricKey: Data
	) throws -> Data
	
	/// Decrypts data using AES symmetric encryption.
	///
	/// This method decrypts the provided data using AES encryption with a 256-bit symmetric key.
	///
	/// - Parameters:
	///   - data: The encrypted data to be decrypted, provided as `Data`.
	///   - symmetricKey: The 256-bit symmetric key used for AES decryption.
	///
	/// - Returns: The decrypted data as `Data`.
	///
	/// - Throws: `PrivMXEndpointError.failedDecrypting` if the decryption process fails.
	func decryptDataSymmetric(
		_ data: Data,
		with symmetricKey: Data
	) throws -> Data
	
	/// Converts a PEM formatted key to WIF format.
	///
	/// This method converts a private key from PEM (Privacy-Enhanced Mail) format to Wallet Import Format (WIF).
	///
	/// - Parameter pemKey: The private key in PEM format.
	///
	/// - Returns: The converted private key in WIF format as a `String`.
	///
	/// - Throws: `PrivMXEndpointError.failedEncrypting` if the conversion process fails.
	func convertPEMKeyToWIFKey(
		_ keyPEM: String
	) throws -> String
	
	/// Validate a signature of data using given key.
	///
	/// - Parameter signature: signature to be verified.
	/// - Parameter data: buffer containing the data signature of which is being verified.
	/// - Parameter publicKey: public ECC key in BASE58DER format used to validate data.
	/// - Returns: data validation result.
	///
	/// - Throws: `PrivMXEndpointError.failedVerifyingSignature` if an verification process fails.
	func verifySignature(
		_ signature: Data,
		of data: Data,
		with publicKey: String
	) throws -> Bool
	
	 func convertPGPAsn1KeyToBase58DERKey(
		_ pgpKey: String
	) throws -> String
	
	 func generateBip39(
		ofStrength strength: size_t,
		usingPassword password: String
	) throws -> BIP39
	
	 func fromMnemonic(
		_ mnemonic: String,
		usingPassword password: String
	) throws -> BIP39
	
	 func fromEntropy(
		_ entropy: Data,
		usingPassword password: String
	)throws -> BIP39
	
	/// Converts BIP-39 mnemonic to entropy.
	///
	/// - Parameter mnemonic: BIP-39 mnemonic
	///
	/// - Throws: `PrivMXEndpointError.failedConvertingMnemonicToEntropy` if the conversion fails.
	///
	/// - Returns: BIP-39 entropy
	 func mnemonicToEntropy(
		_ mnemonic: String
	) throws -> Data
	
	/// Converts BIP-39 mnemonic to entropy.
	///
	/// - Parameter entropy: BIP-39 entropy
	///
	/// - Throws: `PrivMXEndpointError.failedConvertingEntropyToMnemonic` if the conversion fails.
	///
	/// - Returns: BIP-39 mnemonic
	 func entropyToMnemonic(
		_ entropy: Data
	) throws -> String
	
	/// Generates a seed used to generate a key using BIP-39 mnemonic with PBKDF2.
	///
	/// - Parameters mnemonic: BIP-39 mnemonic
	/// - Parameters password: the password used to generate the seed
	///
	/// - Throws: `PrivMXEndpointError.failedGeneratingSeedFromMnemonic` if the generating fails.
	///
	/// - Returns: generated seed
	 func mnemonicToSeed(
		_ mnemonic: String,
		usingPassword password: String
	) throws -> Data
}

