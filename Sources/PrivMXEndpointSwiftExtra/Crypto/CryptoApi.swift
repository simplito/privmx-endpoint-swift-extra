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
	
	@available(*, deprecated, renamed: "derivePrivateKey(from:and:)")
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
	
	@available(*, deprecated)
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
}
