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

public class PrivMXStoreFileHandler{
	
	public static let optimalChunkSize :Int64 = 131072
	
	private let localFile:FileHandle
	private let handle:privmx.PMXFileHandle
	private let storesApi:PrivMXStore
	
	public let mode:PMXFileHandlerMode
	
	public var hasDataLeft:Bool = true
	
	/// Creates a new handler that opareats on local and remote files, using methods of`PrivMXStore`
	internal init(
		PMXFileHandle: privmx.PMXFileHandle,
		storesApi:PrivMXStore,
		localFile:FileHandle,
		mode:PMXFileHandlerMode
	) throws {
		self.storesApi = storesApi
		self.handle = PMXFileHandle
		self.mode = mode
		self.localFile=localFile
	}
	
	/// Closes the local and remote files
	///
	@discardableResult
	public func close(
	) throws -> String {
		try localFile.close()
		return try storesApi.closeFile(handle: handle)
	}
	
	/// Downloads next chunk and adds it to local file
	public func readChunk(
		onChunkDownloaded: @escaping ((Int)->Void) = {byteCount in}
	) throws -> Void{
		if mode == .read{
			let buf = try storesApi.readFile(handle: handle, length: Self.optimalChunkSize)
			try localFile.write(contentsOf: buf)
			if buf.count < Self.optimalChunkSize{
				hasDataLeft = false
			}
			onChunkDownloaded(buf.count)
		} else {
			throw PrivMXEndpointError.failedReadingFromFile(msg: "Tried to read in write mode")
		}
	}
	
	/// Uploads next chunk and adds it to store file
	public func writeChunk(
		onChunkUploaded: @escaping ((Int) -> Void) = {byteCount in}
	) throws -> Void{
		if mode != .read{
			if let buf = try localFile.read(upToCount: Int(Self.optimalChunkSize)){
				try storesApi.writeFile(handle: handle, dataChunk: buf)
				if buf.count < Self.optimalChunkSize{
					self.hasDataLeft = false
				}
				onChunkUploaded(buf.count)
			}
		} else {
			throw PrivMXEndpointError.failedWritingToFile(msg: "Tried to write in read mode.")
		}
	}
	
	deinit {
		_ = try? close()
	}
}

extension PrivMXStoreFileHandler{
	
	/// Creates a new handler for updating a file
	public static func getStoreFileUpdater(
		for fileId:String,
		from sourceFile:FileHandle,
		with storesApi:any PrivMXStore,
		fileSize: Int64,
		fileMimetype: String,
		fileName: String
	) throws -> PrivMXStoreFileHandler{
		let handle = try storesApi.updateFile(fileId, size: fileSize, mimetype: fileMimetype, name: fileName)
		return try PrivMXStoreFileHandler(PMXFileHandle: handle,
										 storesApi: storesApi,
										 localFile:sourceFile,
										 mode: .update)
	}

	/// Creates a new handler for creating a new file
	public static func getStoreFileCreator(
		inStore storeId:String,
		from sourceFile:FileHandle,
		with storesApi:any PrivMXStore,
		fileSize: Int64,
		fileMimetype: String,
		fileName: String
	) throws -> PrivMXStoreFileHandler{
		let handle = try storesApi.createFile(in: storeId, size: fileSize, mimetype: fileMimetype, name: fileName)
		return try PrivMXStoreFileHandler(PMXFileHandle: handle,
										 storesApi: storesApi,
										 localFile:sourceFile,
										 mode: .create)
	}
}

extension PrivMXStoreFileHandler{
	/// Creates a new handler for downloading a file
	public static func getStoreFileReader(
		saveTo outputFile:FileHandle,
		readFrom fileId:String,
		with storesApi:any PrivMXStore
	) throws -> PrivMXStoreFileHandler{
		let handle = try storesApi.openFile(fileId)
		return try PrivMXStoreFileHandler(PMXFileHandle: handle,
										 storesApi: storesApi,
										 localFile:outputFile,
										 mode: .read)
	}
}
