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

import PrivMXEndpointSwiftNative
import PrivMXEndpointSwift
import Foundation

	/// A class providing a set of tools using SwiftNIO for uploading and downloading
	/// files with the use of `PrivMXInbox` from PrivMX Endpoint.
public class InboxFileHandler{
	
	/// Recommended chunk size for file transfers, suggested by the endpoint library.
	public static let RecommendedChunkSize :Int64 = 131072
	
	private let chunkSize :Int64
	
	public let handle:privmx.InboxFileHandle
	private var inboxApi:PrivMXInbox
	private var inboxHandle: privmx.InboxHandle?
	private var dataSource: (any FileDataSource)?
	private var buffer: Data?
	private var localFile: FileHandle?
	
	public let mode:InboxFileHandlerMode
	
	public private(set) var hasDataLeft:Bool = true
	
	internal init(
		fileId:String,
		inboxApi: any PrivMXInbox,
		mode: InboxFileHandlerMode,
		chunkSize:Int64
	) throws {
		self.inboxApi = inboxApi
		self.handle = try inboxApi.openFile(fileId)
		self.mode = mode
		self.chunkSize = chunkSize
	}
	
	/// Initializes a new handler that operates on local and remote files, using methods from `PrivMXInbox`.
	///
	/// - Parameters:
	///   - StoreFileHandle: The file handle for the store file.
	///   - inboxApi: The API for interacting with the `PrivMXInbox`.
	///   - localFile: The local file handle (swift-nio) for file operations.
	///   - mode: The mode of operation (e.g., read or write).
	///   - chunkSize: The size of the chunks for file transfers.
	internal init(
		inboxApi:any PrivMXInbox,
		dataSource: any FileDataSource,
		mode:InboxFileHandlerMode,
		chunkSize: Int64
	) throws {
		self.inboxApi = inboxApi
		self.handle = try inboxApi.createFileHandle(withPublicMeta: dataSource.publicMeta,
													withPrivateMeta: dataSource.publicMeta,
													forSize: dataSource.size)
		self.mode = mode
		self.dataSource = dataSource
		self.chunkSize = chunkSize
	}
	
	public func setInboxHandle(
		_ handle: privmx.InboxHandle
	) -> Void {
		self.inboxHandle = handle
	}
	
	/// Provides access to the data buffer of the processed file.
	///
	/// - Returns: The processed data buffer.
	public func getBuffer(
	) -> Data? {
		return buffer
	}
	
	/// Closes both local and remote files.
	///
	/// - Throws: An error if closing the source fails.
	public func closeSource(
	) throws -> Void{
		try dataSource!.close()
	}
	
	
	public func closeRemote(
	) throws -> String {
		try inboxApi.closeFile(withHandle: handle)
	}
	
	/// Downloads the next chunk and adds it to either the local file or the internal buffer, depending on the mode.
	///
	/// - Parameter onChunkDownloaded: A closure called when a chunk is downloaded, passing the byte count of the chunk.
	/// - Throws: An error if the file read operation fails.
	public func readChunk(
		onChunkDownloaded: @escaping ((Int)->Void) = {byteCount in}
	) throws -> Void{
		if mode == .readToFile{
			let buf = try inboxApi.readFromFile(withHandle: handle,
												 length: chunkSize)
			if let localFile{
				try localFile.write(contentsOf: buf)
			}
			if buf.count < chunkSize{
				hasDataLeft = false
			}
			onChunkDownloaded(buf.count)
		} else if mode == .readToBuffer {
			let buf = try inboxApi.readFromFile(withHandle: handle,
												 length: chunkSize)
			if nil != buffer {
				buffer = Data()
			}
			buffer?.append(buf)
			
			if buf.count < chunkSize{
				hasDataLeft = false
			}
			onChunkDownloaded(buf.count)
		}else {
			var err = privmx.InternalError()
			err.message = "Tried reading in write mode"
			err.name = "File Handler Error"
			throw PrivMXEndpointError.failedReadingFromFile(err)
		}
	}
	
	/// Uploads the next chunk of data from the local file or buffer to the remote file.
	///
	/// - Parameter onChunkUploaded: A closure called when a chunk is uploaded, passing the byte count of the chunk.
	/// - Throws: An error if the file write operation fails.
	public func writeChunk(
		onChunkUploaded: @escaping ((Int) -> Void) = {byteCount in}
	) throws -> Void{
		if mode == .write{
			let buf = try dataSource!.getNextChunk(ofSize: chunkSize)
			guard let inboxHandle else {throw PrivMXEndpointError.failedWritingToFile(privmx.InternalError(name: "Unknown Destination",
																										   message: "Inbox Handle was nil",
																										   description: "Error",
																										   code: nil))}
			try inboxApi.writeToFile(handle,
									 in: inboxHandle,
									 uploading: buf)
			
			hasDataLeft = dataSource!.hasDataLeft
			
			onChunkUploaded(buf.count)
		} else {
			var err = privmx.InternalError()
			err.message = "Tried to read in write mode"
			err.name = "File Handler Error"
			throw PrivMXEndpointError.failedWritingToFile(err)
		}
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
	public static func getInboxFileReaderToBuffer(
		readFrom fileId:String,
		with inboxApi:any PrivMXInbox,
		chunkSize: Int64 = InboxFileHandler.RecommendedChunkSize
	) throws -> InboxFileHandler{
		return try InboxFileHandler(fileId: fileId,
									inboxApi: inboxApi,
									mode: .readToBuffer,
									chunkSize: chunkSize)
	}
}

public enum InboxFileHandlerMode{
	case write
	case readToBuffer, readToFile
}

