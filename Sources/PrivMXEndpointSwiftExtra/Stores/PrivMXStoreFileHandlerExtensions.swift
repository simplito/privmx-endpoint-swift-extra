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



extension PrivMXStoreFileHandler{
	
	/// Creates a handler for updating a file with a new data buffer.
	///
	/// - Parameters:
	///   - fileId: The ID of the file to be updated.
	///   - sourceFile: The FileHandle (swift-nio) with new file content.
	///   - storesApi: The API for interacting with the `PrivMXStore`.
	///   - publicMeta: The new public metadata for the file.
	///   - privateMeta: The new private metadata for the file.
	///   - fileSize: The size of the file to be updated.
	///   - chunkSize: The size of the chunks for the upload. Defaults to the recommended chunk size.
	/// - Returns: A new `PrivMXStoreFileHandler` instance configured for updating the file.
	/// - Throws: An error if the file cannot be opened or updated.
	public static func getStoreFileUpdater(
		for fileId:String,
		withReplacement sourceFile:FileHandle,
		using storesApi:any PrivMXStore,
		replacingPublicMeta publicMeta: Data,
		replacingPrivateMeta privateMeta: Data,
		replacingFileSize fileSize: Int64,
		chunkSize: Int64 = PrivMXStoreFileHandler.RecommendedChunkSize
	) throws -> PrivMXStoreFileHandler{
		let handle = try storesApi.updateFile(fileId,
											  replacingPublicMeta: publicMeta,
											  replacingPrivateMeta: privateMeta,
											  replacingSize: fileSize)
		return try PrivMXStoreFileHandler(StoreFileHandle: handle,
										  storesApi: storesApi,
										  localFile:sourceFile,
										  mode: .updateFromFile,
										  chunkSize:chunkSize)
	}

	/// Creates a handler for creating a new file from a data buffer.
	///
	/// - Parameters:
	///   - storeId: The ID of the store where the file will be created.
	///   - sourceFile: The FileHandle (swift-nio) with new file content.
	///   - storesApi: The API for interacting with the `PrivMXStore`.
	///   - publicMeta: The public metadata for the new file.
	///   - privateMeta: The private metadata for the new file.
	///   - fileSize: The size of the new file.
	///   - chunkSize: The size of the chunks for the upload. Defaults to the recommended chunk size.
	/// - Returns: A new `PrivMXStoreFileHandler` instance configured for creating the file.
	/// - Throws: An error if the file cannot be created.
	public static func getStoreFileCreator(
		inStore storeId:String,
		from sourceFile:FileHandle,
		using storesApi:any PrivMXStore,
		withPublicMeta publicMeta:Data,
		withPrivateMeta privateMeta:Data,
		fileSize: Int64,
		chunkSize: Int64 = PrivMXStoreFileHandler.RecommendedChunkSize
	) throws -> PrivMXStoreFileHandler{
		let handle = try storesApi.createFile(in: storeId,
											  withPublicMeta: publicMeta,
											  withPrivateMeta: privateMeta,
											  ofSize: fileSize)
		return try PrivMXStoreFileHandler(StoreFileHandle: handle,
										  storesApi: storesApi,
										  localFile:sourceFile,
										  mode: .createFromFile,
										  chunkSize: chunkSize)
	}
	

	/// Creates a handler for updating a file with a new data buffer.
	///
	/// - Parameters:
	///   - fileId: The ID of the file to be updated.
	///   - sourceBuffer: The data buffer to replace the existing file content.
	///   - storesApi: The API for interacting with the `PrivMXStore`.
	///   - publicMeta: The new public metadata for the file.
	///   - privateMeta: The new private metadata for the file.
	///   - fileSize: The size of the file to be updated.
	///   - chunkSize: The size of the chunks for the upload. Defaults to the recommended chunk size.
	/// - Returns: A new `PrivMXStoreFileHandler` instance configured for updating the file.
	/// - Throws: An error if the file cannot be opened or updated.
	public static func getStoreFileUpdater(
		for fileId:String,
		withReplacementBuffer sourceBuffer:Data,
		using storesApi:any PrivMXStore,
		replacingPublicMeta publicMeta: Data,
		replacingPrivateMeta privateMeta: Data,
		replacingFileSize fileSize: Int64,
		chunkSize: Int64 = PrivMXStoreFileHandler.RecommendedChunkSize
	) throws -> PrivMXStoreFileHandler{
		let handle = try storesApi.updateFile(fileId,
											  replacingPublicMeta: publicMeta,
											  replacingPrivateMeta: privateMeta,
											  replacingSize: fileSize)
		return try PrivMXStoreFileHandler(StoreFileHandle: handle,
										  storesApi: storesApi,
										  buffer: sourceBuffer,
										  mode: .updateFromBuffer,
										  chunkSize: chunkSize)
	}

	/// Creates a handler for updating a file with a new data buffer.
	///
	/// - Parameters:
	///   - fileId: The ID of the file to be updated.
	///   - sourceBuffer: The data buffer to replace the existing file content.
	///   - storesApi: The API for interacting with the `PrivMXStore`.
	///   - publicMeta: The new public metadata for the file.
	///   - privateMeta: The new private metadata for the file.
	///   - fileSize: The size of the file to be updated.
	///   - chunkSize: The size of the chunks for the upload. Defaults to the recommended chunk size.
	/// - Returns: A new `PrivMXStoreFileHandler` instance configured for updating the file.
	/// - Throws: An error if the file cannot be opened or updated.
	public static func getStoreFileCreator(
		inStore storeId:String,
		fromBuffer sourceBuffer:Data,
		using storesApi:any PrivMXStore,
		withPublicMeta publicMeta:Data,
		withPrivateMeta privateMeta:Data,
		fileSize: Int64,
		chunkSize: Int64 = PrivMXStoreFileHandler.RecommendedChunkSize
	) throws -> PrivMXStoreFileHandler{
		let handle = try storesApi.createFile(in: storeId,
											  withPublicMeta: publicMeta,
											  withPrivateMeta: privateMeta,
											  ofSize: fileSize)
		return try PrivMXStoreFileHandler(StoreFileHandle: handle,
										  storesApi: storesApi,
										  buffer: sourceBuffer,
										  mode: .createFromBuffer,
										  chunkSize:chunkSize)
	}

	
	/// Creates a new handler for downloading a file and saving it to a local file.
	///
	/// - Parameters:
	///   - outputFile: The local file handle (swift-nio) where the downloaded file content will be saved.
	///   - fileId: The ID of the file to be downloaded from the `PrivMXStore`.
	///   - storesApi: The API for interacting with the `PrivMXStore`.
	///   - chunkSize: The size of the chunks for downloading. Defaults to the recommended chunk size.
	/// - Returns: A new `PrivMXStoreFileHandler` instance configured for downloading the file to the local file.
	/// - Throws: An error if the file cannot be opened or the download process fails.
   public static func getStoreFileReader(
		saveTo outputFile:FileHandle,
		readFrom fileId:String,
		with storesApi:any PrivMXStore,
		chunkSize: Int64 = PrivMXStoreFileHandler.RecommendedChunkSize
	) throws -> PrivMXStoreFileHandler{
		let handle = try storesApi.openFile(fileId)
		return try PrivMXStoreFileHandler(StoreFileHandle: handle,
										  storesApi: storesApi,
										  localFile:outputFile,
										  mode: .readToFile,
										  chunkSize: chunkSize)
	}
	
	/// Creates a new handler for downloading a file to an internal buffer.
	///
	/// This method allows downloading a file from the `PrivMXStore` directly into memory (a buffer).
	/// To retrieve the buffer after the download, call `getBuffer()`.
	///
	/// - Parameters:
	///   - fileId: The ID of the file to be downloaded from the `PrivMXStore`.
	///   - storesApi: The API for interacting with the `PrivMXStore`.
	///   - chunkSize: The size of the chunks for downloading. Defaults to the recommended chunk size.
	/// - Returns: A new `PrivMXStoreFileHandler` instance configured for downloading the file into the buffer.
	/// - Throws: An error if the file cannot be opened or the download process fails.
	public static func getStoreFileReader(
		readFrom fileId:String,
		with storesApi:any PrivMXStore,
		chunkSize: Int64 = PrivMXStoreFileHandler.RecommendedChunkSize
	) throws -> PrivMXStoreFileHandler{
		let handle = try storesApi.openFile(fileId)
		return try PrivMXStoreFileHandler(StoreFileHandle: handle,
										  storesApi: storesApi,
										  buffer: Data(),
										  mode: .readToBuffer,
										  chunkSize: chunkSize)
	}
}
