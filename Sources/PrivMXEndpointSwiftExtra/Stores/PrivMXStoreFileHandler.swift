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



/// A class providing a set of tools using SwiftNIO for uploading and downloading
/// files with the use of `PrivMXStore` from PrivMX Endpoint.
public class PrivMXStoreFileHandler{
	
	/// Recommended chunk size for file transfers, suggested by the endpoint library.
	public static let RecommendedChunkSize :Int64 = 131072
	
	private let chunkSize :Int64
	
	private let localFile:FileHandle?
	private let handle:privmx.StoreFileHandle
	private let storesApi:PrivMXStore
	private var buffer: Data?
	
	public let mode:StoreFileHandlerMode
	
	public var hasDataLeft:Bool = true
	
	/// Initializes a new handler that operates on local and remote files, using methods from `PrivMXStore`.
	///
	/// - Parameters:
	///   - StoreFileHandle: The file handle for the store file.
	///   - storesApi: The API for interacting with the `PrivMXStore`.
	///   - localFile: The local file handle (swift-nio) for file operations.
	///   - mode: The mode of operation (e.g., read or write).
	///   - chunkSize: The size of the chunks for file transfers.
	internal init(
		StoreFileHandle: privmx.StoreFileHandle,
		storesApi:PrivMXStore,
		localFile:FileHandle,
		mode:StoreFileHandlerMode,
		chunkSize: Int64
	) throws {
		self.storesApi = storesApi
		self.handle = StoreFileHandle
		self.mode = mode
		self.localFile = localFile
		self.chunkSize = chunkSize
	}
	

	/// Initializes a new handler that operates on an internal buffer and remote files, using methods from `PrivMXStore`.
	///
	/// - Parameters:
	///   - StoreFileHandle: The file handle for the store file.
	///   - storesApi: The API for interacting with the `PrivMXStore`.
	///   - buffer: The internal data buffer for file operations.
	///   - mode: The mode of operation (e.g., read or write).
	///   - chunkSize: The size of the chunks for file transfers.
	internal init(
		StoreFileHandle: privmx.StoreFileHandle,
		storesApi:PrivMXStore,
		buffer:Data,
		mode:StoreFileHandlerMode,
		chunkSize: Int64
	) throws {
		self.storesApi = storesApi
		self.handle = StoreFileHandle
		self.mode = mode
		self.buffer = buffer
		self.localFile = nil
		self.chunkSize = chunkSize
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
    /// - Returns: A string representing the result of closing the remote file.
    /// - Throws: An error if closing the file fails.
    @discardableResult
	public func close(
	) throws -> String {
		try localFile?.close()
		return try storesApi.closeFile(withHandle: handle)
	}
	
	/// Downloads the next chunk and adds it to either the local file or the internal buffer, depending on the mode.
    ///
    /// - Parameter onChunkDownloaded: A closure called when a chunk is downloaded, passing the byte count of the chunk.
    /// - Throws: An error if the file read operation fails.
    public func readChunk(
		onChunkDownloaded: (@escaping @Sendable (Int)->Void) = {byteCount in}
	) throws -> Void{
		if mode == .readToFile{
			let buf = try storesApi.readFromFile(withHandle: handle,
												 length: chunkSize)
			if let localFile{
				try localFile.write(contentsOf: buf)
			}
			if buf.count < chunkSize{
				hasDataLeft = false
			}
			onChunkDownloaded(buf.count)
		} else if mode == .readToBuffer {
			let buf = try storesApi.readFromFile(withHandle: handle,
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
		onChunkUploaded: (@escaping @Sendable (Int) -> Void) = {byteCount in}
	) throws -> Void{
		if mode == .createFromFile || mode == .updateFromFile{
			if let buf = try localFile?.read(upToCount: Int(chunkSize)){
				
				try storesApi.writeToFile(withHandle: handle,
										  uploading: buf)
				
				if buf.count < chunkSize{
					self.hasDataLeft = false
				}
				onChunkUploaded(buf.count)
			}
		} else if mode == .createFromBuffer || mode == .updateFromBuffer {
			if let buf = buffer?.prefix(Int(chunkSize)) {
				try storesApi.writeToFile(withHandle: handle,
										  uploading: buf)
				
				if buf.count < chunkSize{
					self.hasDataLeft = false
				}else{
					buffer = buffer?.advanced(by: buf.count)
				}
				onChunkUploaded(buf.count)
			}
			
		} else {
			var err = privmx.InternalError()
			err.message = "Tried to read in write mode"
			err.name = "File Handler Error"
			throw PrivMXEndpointError.failedWritingToFile(err)
		}
	}
	
}

/// Modes of operation for `PrivMXStoreFileHandler` instances.
public enum StoreFileHandlerMode{
	case readToFile,readToBuffer
	case updateFromFile,updateFromBuffer
	case createFromFile,createFromBuffer
}

