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

/// Extension of `CryptoApi`, providing conformance for protocol using Swift types.
extension CryptoApi: PrivMXCrypto{
	
	public func generatePrivateKey(
		withSeed randomSeed: String?
	) throws -> String {
		if let rS = randomSeed{
			return try String(self.generatePrivateKey(randomSeed: std.string(rS)))
		} else {
			return try String(self.generatePrivateKey(randomSeed: nil))
		}
		
	}
	
	
	public func generateKeySymmetric(
	) throws -> Data{
		try Data(from: self.generateKeySymmetric() as privmx.endpoint.core.Buffer)
	}
	
	public func derivePublicKey(
		from keyPriv: String
	) throws -> String {
		try String(derivePublicKey(privKey: std.string(keyPriv)))
	}
	
	@available(*, deprecated, renamed: "derivePrivateKey2(from:and:)")
	public func derivePrivateKey(
		from password: String,
		and salt: String
	) throws -> String {
		try String(derivePrivateKey(password: std.string(password),
									salt: std.string(salt)))
	}
	
	public func derivePrivateKey2(
		from password: String,
		and salt: String
	) throws -> String {
		try String(derivePrivateKey2(password: std.string(password),
									salt: std.string(salt)))
	}
	
	public func signData(
		_ data: Data,
		with privateKey: String
	) throws -> Data {
		try Data(from: signData(data: data.asBuffer(),
								privateKey: std.string(privateKey)))
	}
	
	public func encryptDataSymmetric(
		_ data: Data,
		with symmetricKey: Data
	) throws -> Data {
		try Data(from: encryptDataSymmetric(data: data.asBuffer(),
											symmetricKey: symmetricKey.asBuffer()))
	}
	
	public func decryptDataSymmetric(
		_ data: Data, /// test
		with symmetricKey: Data
	) throws -> Data {
		try Data(from: decryptDataSymmetric(data: data.asBuffer(),
											symmetricKey: symmetricKey.asBuffer()))
	}
	
	public func convertPEMKeyToWIFKey(
		_ pemKey: String
	) throws -> String {
		try String(self.convertPEMKeyToWIFKey(pemKey:std.string(pemKey)))
	}
	
	@available(*, deprecated, renamed: "verifySignature(_:of:with:)")
	public func verifySignature(
		data: Data,
		signature: Data,
		publicKey: String
	) throws -> Bool {
		try self.verifySignature(data: data.asBuffer(),
								 signature: signature.asBuffer(),
								 publicKey: std.string(publicKey))
	}
	
	public func verifySignature(
		_ signature: Data,
		of data: Data,
		with publicKey: String
	) throws -> Bool {
		try self.verifySignature(data: data.asBuffer(),
								 signature: signature.asBuffer(),
								 publicKey: std.string(publicKey))
	}
	
	/// Converts given public key in PGP format to its base58DER format.
	///
	/// - Parameter pgpKey: public key to convert
	///
	/// - Throws: `PrivMXEndpointError.failedConvertingKeyToBase58DER` if the conversion fails.
	///
	/// - Returns: public key in base58DER format
	public func convertPGPAsn1KeyToBase58DERKey(
		_ pgpKey: String
	) throws -> String {
		try String(self.convertPGPAsn1KeyToBase58DERKey(pgpKey:std.string(pgpKey)))
	}
	
	
	/// Generates ECC key and BIP-39 mnemonic from a password using BIP-39.
	///
	/// - Parameter strength: size of BIP-39 entropy, must be a multiple of 32
	/// - Parameter password: the password used to generate the Key
	///
	/// - Throws: `PrivMXEndpointError.failedGeneratingBIP39` if the generating fails.
	///
	/// - Returns: `BIP39` object containing ECC Key and associated with it BIP-39 mnemonic and entropy
	public func generateBip39(
		ofStrength strength: size_t,
		usingPassword password: String = ""
	) throws -> BIP39 {
		try self.generateBip39(strength:strength,
							   password:std.string(password))
		
	}
	
	
	/// Generates ECC key using BIP-39 mnemonic.
	///
	/// - Parameters mnemonic: the BIP-39 entropy used to generate the Key
	/// - Parameters password: the password used to generate the Key
	///
	/// - Throws: `PrivMXEndpointError.failedGeneratingBIP39` if the generating fails.
	///
	/// - Returns: `BIP39` object containing ECC Key and associated with it BIP-39 mnemonic and entropy
	public func fromMnemonic(
		_ mnemonic: String,
		usingPassword password: String = ""
	) throws -> BIP39 {
		try self.fromMnemonic(mnemonic:std.string(mnemonic),
							  password:std.string(password))
	}
	
	
	/// Generates ECC key using BIP-39 entropy.
	///
	/// - Parameters entropy: the BIP-39 entropy used to generate the Key
	/// - Parameters password: the password used to generate the Key
	///
	/// - Throws: `PrivMXEndpointError.failedGeneratingBIP39` if the generating fails.
	///
	/// - Returns: `BIP39_t` object containing ECC Key and associated with it BIP-39 mnemonic and entropy
	public func fromEntropy(
		_ entropy: Data,
		usingPassword password: String = ""
	) throws -> BIP39{
		try self.fromEntropy(entropy: entropy.asBuffer(),
							 password: std.string(password))
	}
	
	
	/// Converts BIP-39 mnemonic to entropy.
	///
	/// - Parameter entropy: BIP-39 entropy
	///
	/// - Throws: `PrivMXEndpointError.failedConvertingEntropyToMnemonic` if the conversion fails.
	///
	/// - Returns: BIP-39 mnemonic
	public func entropyToMnemonic(
		_ entropy: Data
	) throws -> String {
		try String(self.entropyToMnemonic(entropy:entropy.asBuffer()))
		
	}
	
	
	/// Converts BIP-39 mnemonic to entropy.
	///
	/// - Parameter mnemonic: BIP-39 mnemonic
	///
	/// - Throws: `PrivMXEndpointError.failedConvertingMnemonicToEntropy` if the conversion fails.
	///
	/// - Returns: BIP-39 entropy
	public func mnemonicToEntropy(
		_ mnemonic: String
	) throws -> Data {
		try Data(from: self.mnemonicToEntropy(mnemonic:std.string(mnemonic)))
	}
	
	
	/// Generates a seed used to generate a key using BIP-39 mnemonic with PBKDF2.
	///
	/// - Parameters mnemonic: BIP-39 mnemonic
	/// - Parameters password: the password used to generate the seed
	///
	/// - Throws: `PrivMXEndpointError.failedGeneratingSeedFromMnemonic` if the generating fails.
	///
	/// - Returns: generated seed
	public func mnemonicToSeed(
		_ mnemonic: String,
		usingPassword password: String = ""
	) throws -> Data {
		try Data(from:self.mnemonicToSeed(mnemonic:std.string(mnemonic),
										  password:std.string(password)))
		
	}
}
