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

/// Container for multiple `PrivmxEndpointWrapper`s
public class EndpointContainer{
	/// Provides access to cryptographic operations
 	public var cryptoApi:PrivMXCrypto = CryptoApi()
	/// Dictionary of `PrivMXEndpointWrapper`s, keyed by arbitrary `Strings`
	public var endpoints: [String:PrivMXEndpointWrapper] = [:]
	
	/// Information if the setCertPaths method has been called by this class
	public static var isCertPathSet = false
	
	///Creates a new EndpointContainer
	public init(
	) {}

	/// Initialises a new `PrivMXEndpointWrapper` and adds it to `endpoints` dictionary with a provided identificator
	///
	/// - Parameter endpointId: key under which the new endpoint will be accesible
	/// - Parameter modules: set of modules with which te hnew endpoint is to be initialised
	/// - Parameter userPrivKey: Private Key of the User
	/// - Parameter solutionId: Id of the solution
	/// - Parameter platformUrl: Url of the PrivMX Platform
	///
	/// - Throws: If creating a new Endpoint fails
	public func newEndpoint(
		_ endpointId:String,
		modules:Set<PrivMXModule>,
		userPrivKey:String,
		solutionId:String,
		platformUrl:String
	) throws -> Void {
		if nil == endpoints[endpointId]{
			try endpoints[endpointId] = PrivMXEndpointWrapper(modules: modules,
															  userPrivKey: userPrivKey,
															  solutionId: solutionId,
															  platformUrl: platformUrl,
															  onDisconnect: {
				_ in
				self.endpoints[endpointId]?.stopListening()
				self.endpoints.removeValue(forKey: endpointId)
			})
		} else {
			throw PrivMXEndpointError.otherFailure(msg: "Endpoint \"\(endpointId)\" already exists")
		}
	}
	
	private func verifyCert(
		filename:String = "cacert.pem",
		directoryPath:URL
	) throws -> String {
		let destinationURL = directoryPath.appending(path: filename)
		guard let sourceURL = Bundle.module.url(forResource: "cacert", withExtension: ".pem") else {
			throw PrivMXEndpointError.otherFailure(msg:"Failed to find default cert file")
		}
		let path = destinationURL.path
		let  filemgr = FileManager()
		if !filemgr.fileExists(atPath: destinationURL.path){
			try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
			try FileManager.default.setAttributes(
				[.protectionKey: FileProtectionType.complete],
				ofItemAtPath: destinationURL.path
			)
		}else{
			try FileManager.default.setAttributes([.protectionKey: FileProtectionType.complete], ofItemAtPath: path)
		}
		
		return path
	}
	
	/// Checks if a file exists under the specified path, If it doesn't the bundled certificate file is copied there; afterwards configures OpenSSL to use it.
	///
	/// - Parameter directoryPath: URL to the directory in which the Certificate file should be
	/// - Parameter filename: Name of the certificate file
	///
	/// - Throws: When there were issues with file access
	public func setCertsPath(
		directoryPath:URL,
		filename:String="cacert.pem"
	) throws -> Void {
		let path = try verifyCert(
			filename: filename,
			directoryPath: directoryPath)
		try CoreApi.setCertsPath(path)
		EndpointContainer.isCertPathSet = true
	}
}
