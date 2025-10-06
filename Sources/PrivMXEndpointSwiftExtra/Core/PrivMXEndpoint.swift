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
import PrivMXEndpointSwiftNative
import PrivMXEndpointSwift


/// A wrapper class that manages a connection to PrivMX Bridge and provides access to various APIs, including Threads, Stores, and Inboxes.
///
/// The `PrivMXEndpoint` class is designed to encapsulate and manage a single connection to PrivMX. It provides
/// access to different APIs for handling Threads, Stores, and Inboxes, based on the modules that are enabled during initialization.
/// It also supports asynchronous operations like uploading and downloading files, and allows for managing callbacks for events.
public class PrivMXEndpoint: Identifiable, @unchecked Sendable{
	
	public let id:Int64
	
	/// Marks the endpoint as connected using no authorisation.
	public let anonymous: Bool
	/// Provides handling of network and events through `PrivMXConnection`.
	public private(set) var connection : PrivMXConnection
	/// API for handling Threads.
	public private(set) var threadApi : PrivMXThread?
	/// API for handling Stores.
	public private(set) var storeApi : PrivMXStore?
	/// API for handling Inboxes.
	public private(set) var inboxApi : PrivMXInbox?
	/// API for handling Custom Events
	public private(set) var eventApi: EventApi?
	/// API for handling KVDBs
	public private(set) var kvdbApi: KvdbApi?
	
	fileprivate var callbacks : [String :(PMXEventSubscriptionRequest, [String :[(@Sendable @MainActor (Any?) -> Void)]])] = [:]
	
	/// Initializes a new instance of `PrivMXEndpoint` with a connection to PrivMX Bridge and optional modules.
    ///
    /// This method sets up the connection and, based on the provided modules, initializes the APIs for handling Threads, Stores, and Inboxes.
    ///
    /// - Parameters:
    ///   - modules: A set of modules to initialize (of type `PrivMXModule`).
    ///   - userPrivKey: The user's private key in WIF format.
    ///   - solutionId: The unique identifier of PrivMX Solution.
    ///   - platformUrl: The URL of PrivMX Bridge instance.
    ///
    /// - Throws: An error if the connection or module initialization fails.
	@available(*, deprecated)
	public init(
		modules:Set<PrivMXModule>,
		userPrivKey:String,
		solutionId:String,
		platformUrl:String
	) throws {
		var con = try Connection.connect(userPrivKey: std.string(userPrivKey),
										 solutionId: std.string(solutionId),
										 platformUrl: std.string(platformUrl))
		self.connection = con
		self.anonymous = false
		var thr:ThreadApi?
		var sto:StoreApi?
		if modules.contains(.thread){
			thr = try ThreadApi.create(connection: &con)
			self.threadApi = thr
		}
		if modules.contains(.store){
			sto = try StoreApi.create(connection: &con)
			self.storeApi = sto
		}
		if modules.contains(.inbox){
			var s = try (sto ?? StoreApi.create(connection: &con))
			var t = try (thr ?? ThreadApi.create(connection: &con))
			self.inboxApi = try InboxApi.create(connection: &con,
												  threadApi: &t,
												  storeApi: &s)
		}
		if modules.contains(.event){
			self.eventApi = try EventApi.create(connection: &con)
		}
		if modules.contains(.kvdb){
			self.kvdbApi = try KvdbApi.create(connection: &con)
		}
		self.id = try! con.getConnectionId()
	}
	
	/// Initializes a new instance of `PrivMXEndpoint` with a connection to PrivMX Bridge and optional modules.
    ///
    /// This method sets up the connection and, based on the provided modules, initializes the APIs for handling Threads, Stores, and Inboxes.
    ///
    /// - Parameters:
    ///   - modules: A set of modules to initialize (of type `PrivMXModule`).
    ///   - userPrivKey: The user's private key in WIF format.
    ///   - solutionId: The unique identifier of PrivMX Solution.
    ///   - bridgeUrl: The URL of PrivMX Bridge instance.
    ///
    /// - Throws: An error if the connection or module initialization fails.
	public init(
		modules:Set<PrivMXModule>,
		userPrivKey:String,
		solutionId:String,
		bridgeUrl:String
	) throws {
		var con = try Connection.connect(userPrivKey: std.string(userPrivKey),
										 solutionId: std.string(solutionId),
										 bridgeUrl: std.string(bridgeUrl))
		self.connection = con
		self.anonymous = false
		var thr:ThreadApi?
		var sto:StoreApi?
		if modules.contains(.thread){
			thr = try ThreadApi.create(connection: &con)
			self.threadApi = thr
		}
		if modules.contains(.store){
			sto = try StoreApi.create(connection: &con)
			self.storeApi = sto
		}
		if modules.contains(.inbox){
			var s = try (sto ?? StoreApi.create(connection: &con))
			var t = try (thr ?? ThreadApi.create(connection: &con))
			self.inboxApi = try InboxApi.create(connection: &con,
												  threadApi: &t,
												  storeApi: &s)
		}
		if modules.contains(.event){
			self.eventApi = try EventApi.create(connection: &con)
		}
		if modules.contains(.kvdb){
			self.kvdbApi = try KvdbApi.create(connection: &con)
		}
		self.id = try! con.getConnectionId()
	}
	
	/// Initializes a new instance of `PrivMXEndpoint` with a public connection to the PrivMX Bridge and optional modules.
	///
	/// This method sets up the connection and, based on the provided modules, initializes the APIs for handling threads, stores, and inboxes. Using a Public (anonymous) connection.
	/// Take note that this is only useful for Inboxes
	///
	/// - Parameters:
	///   - modules: A set of modules to initialize (of type `PrivMXModule`).
	///   - solutionId: The unique identifier of the PrivMX solution.
	///   - platformUrl: The URL of the PrivMX Bridge instance.
	///
	/// - Throws: An error if the connection or module initialization fails.
	@available(*, deprecated)
	public init(
		modules:Set<PrivMXModule>,
		solutionId:String,
		platformUrl:String
	) throws {
		var con = try Connection.connectPublic(solutionId: std.string(solutionId),
											   platformUrl: std.string(platformUrl))
		self.connection = con
		self.anonymous = true
		var thr:ThreadApi?
		var sto:StoreApi?
		if modules.contains(.thread){
			thr = try ThreadApi.create(connection: &con)
			self.threadApi = thr
		}
		if modules.contains(.store){
			sto = try StoreApi.create(connection: &con)
			self.storeApi = sto
		}
		if modules.contains(.inbox){
			var s = try (sto ?? StoreApi.create(connection: &con))
			var t = try (thr ?? ThreadApi.create(connection: &con))
			self.inboxApi = try InboxApi.create(connection: &con,
												  threadApi: &t,
												  storeApi: &s)
		}
		if modules.contains(.event){
			self.eventApi = try EventApi.create(connection: &con)
		}
		if modules.contains(.kvdb){
			self.kvdbApi = try KvdbApi.create(connection: &con)
		}
		self.id = try! con.getConnectionId()
	}
	
	/// Initializes a new instance of `PrivMXEndpoint` with a public connection to the PrivMX Bridge and optional modules.
	///
	/// This method sets up the connection and, based on the provided modules, initializes the APIs for handling threads, stores, and inboxes. Using a Public (anonymous) connection.
	/// Take note that this is only useful for Inboxes
	///
	///  - Parameter modules: A set of modules to initialize (of type `PrivMXModule`).
	///  - Parameter solutionId: The unique identifier of the PrivMX solution.
	///  - Parameter bridgeUrl: The URL of the PrivMX Bridge instance.
	///
	/// - Throws: An error if the connection or module initialization fails.
	public init(
		modules:Set<PrivMXModule>,
		solutionId:String,
		bridgeUrl:String
	) throws {
		var con = try Connection.connectPublic(solutionId: std.string(solutionId),
											   bridgeUrl: std.string(bridgeUrl))
		self.connection = con
		self.anonymous = true
		var thr:ThreadApi?
		var sto:StoreApi?
		if modules.contains(.thread){
			thr = try ThreadApi.create(connection: &con)
			self.threadApi = thr
		}
		if modules.contains(.store){
			sto = try StoreApi.create(connection: &con)
			self.storeApi = sto
		}
		if modules.contains(.event){
			self.eventApi = try EventApi.create(connection: &con)
		}
		if modules.contains(.inbox){
			var s = try (sto ?? StoreApi.create(connection: &con))
			var t = try (thr ?? ThreadApi.create(connection: &con))
			self.inboxApi = try InboxApi.create(connection: &con,
												  threadApi: &t,
												  storeApi: &s)
		}
		if modules.contains(.event){
			self.eventApi = try EventApi.create(connection: &con)
		}
		if modules.contains(.kvdb){
			self.kvdbApi = try KvdbApi.create(connection: &con)
		}
		self.id = try! con.getConnectionId()
	}
	
	/// Begins uploading a new file using `PrivMXStoreFileHandler`, which manages file uploads.
	///
	/// This method uploads a file to a specified store using a `FileHandle`. It supports uploading large files in chunks and provides a callback for tracking the progress.
	///
	///  - Parameter file: A local `FileHandle` representing the file to be uploaded.
	///  - Parameter store: The identifier of the destination store.
	///  - Parameter publicMeta: Public, unencrypted metadata for the file.
	///  - Parameter privateMeta: Encrypted metadata for the file.
	///  - Parameter size: The size of the file in bytes.
	///  - Parameter chunkSize: The size of individual chunks, by default set to `PrivMXStoreFileHandler.RecommendedChunkSize`
	///  - Parameter onChunkUploaded: A callback that is called after each chunk upload is completed.
	///
	/// - Returns: The identifier of the uploaded file as a `String`.
	///
	/// - Throws: An error if the upload process fails.
	public func startUploadingNewFile(
		_ file:FileHandle,
		to store:String,
		withPublicMeta publicMeta: Data,
		withPrivateMeta privateMeta: Data,
		sized size:Int64,
		withChunksOf chunkSize: Int64 = PrivMXStoreFileHandler.RecommendedChunkSize,
		onChunkUploaded: (@escaping @Sendable (Int) -> Void) = {_ in}
	) async throws -> String{
		var isCancelled = false
        
        
		if let api = self.storeApi{
            
			let sfhandler = try PrivMXStoreFileHandler.getStoreFileCreator(inStore: store,
																		   from: file,
																		   using: api,
																		   withPublicMeta: publicMeta,
																		   withPrivateMeta: privateMeta,
																		   fileSize: size,
																		   chunkSize: chunkSize)
            
            
				while sfhandler.hasDataLeft && !isCancelled{
					try sfhandler.writeChunk(onChunkUploaded: onChunkUploaded)
					withUnsafeCurrentTask(){
						task in
						isCancelled = task?.isCancelled ?? false
					}
				}
            
                return try sfhandler.close()
             
		} else {
			var err = privmx.InternalError()
			err.message = "StoresApi not initialized"
			err.name = "Api Error"
			throw PrivMXEndpointError.otherFailure(err)
		}
	}
	
	/// Begins uploading a new file from an in-memory buffer using `PrivMXStoreFileHandler`.
    ///
    /// This method uploads file content from a `Data` buffer to a specified Store. It supports chunked uploads and provides a callback for progress tracking.
    ///
    /// - Parameters:
    ///   - buffer: The in-memory file content as `Data`.
    ///   - store: The identifier of the destination store.
    ///   - publicMeta: Public, unencrypted metadata for the file.
    ///   - privateMeta: Encrypted metadata for the file.
    ///   - size: The size of the file in bytes.
    ///   - chunkSize: The size of each chunk to be uploaded.
    ///   - onChunkUploaded: A callback that is called after each chunk upload is completed.
    ///
    /// - Returns: The identifier of the uploaded file as a `String`.
    ///
    /// - Throws: An error if the upload process fails.
    public func startUploadingNewFileFromBuffer(
		_ buffer:Data,
		to store:String,
		withPublicMeta publicMeta: Data,
		withPrivateMeta privateMeta: Data,
		sized size:Int64,
		withChunksOf chunkSize: Int64 = PrivMXStoreFileHandler.RecommendedChunkSize,
		onChunkUploaded: (@escaping @Sendable (Int) -> Void) = {_ in}
	) async throws -> String{
		var isCancelled = false
        
        
		if let api = self.storeApi{
            
			let sfhandler = try PrivMXStoreFileHandler.getStoreFileCreator(inStore: store,
																		   fromBuffer: buffer,
																		   using: api,
																		   withPublicMeta: publicMeta,
																		   withPrivateMeta: privateMeta,
																		   fileSize: size,
																		   chunkSize: chunkSize)
            
            
				while sfhandler.hasDataLeft && !isCancelled{
					try sfhandler.writeChunk(onChunkUploaded: onChunkUploaded)
					withUnsafeCurrentTask(){
						task in
						isCancelled = task?.isCancelled ?? false
					}
				}
            
                return try sfhandler.close()
             
		} else {
			var err = privmx.InternalError()
			err.message = "StoresApi not initialized"
			err.name = "Api Error"
			throw PrivMXEndpointError.otherFailure(err)
		}
	}
	
	//// Begins uploading an updated file using `PrivMXStoreFileHandler`.
    ///
    /// This method updates an existing file in a store with new content and metadata, supporting chunked uploads for large files.
    ///
    /// - Parameter file: A local `FileHandle` representing the updated file.
    /// - Parameter storeFile: The identifier of the file in the store to be updated.
    /// - Parameter publicMeta: Public metadata to overwrite the existing metadata.
    /// - Parameter privateMeta: Encrypted metadata to overwrite the existing metadata.
    /// - Parameter size: The size of the updated file in bytes.
	/// - Parameter chunkSize: The size of individual chunks, by default set to `PrivMXStoreFileHandler.RecommendedChunkSize`
    /// - Parameter onChunkUploaded: A callback that is called after each chunk upload is completed.
    ///
    /// - Returns: The identifier of the updated file as a `String`.
    ///
    /// - Throws: An error if the update process fails.
   public func startUploadingUpdatedFile(
		_ file:FileHandle,
		as storeFile:String,
		replacingPublicMeta publicMeta: Data,
		replacingPrivateMeta privateMeta: Data,
		replacingSize size:Int64,
		withChunksOf chunkSize: Int64 = PrivMXStoreFileHandler.RecommendedChunkSize,
		onChunkUploaded: (@escaping @Sendable (Int) -> Void) = {_ in}
	) async throws -> String {
		var isCancelled = false
		if let api = self.storeApi{
			let sfhandler = try PrivMXStoreFileHandler.getStoreFileUpdater(for: storeFile,
																		   withReplacement: file,
																		   using: api,
																		   replacingPublicMeta: publicMeta,
																		   replacingPrivateMeta: privateMeta,
																		   replacingFileSize: size,
																		   chunkSize: chunkSize)
			while sfhandler.hasDataLeft && !isCancelled{
				try sfhandler.writeChunk(onChunkUploaded: onChunkUploaded)
				withUnsafeCurrentTask(){
					task in
					isCancelled = task?.isCancelled ?? false
				}
			}
			return try sfhandler.close()
			
		} else {
			var err = privmx.InternalError()
			err.message = "StoresApi not initialized"
			err.name = "Api Error"
			throw PrivMXEndpointError.otherFailure(err)
		}
	}
	
	/// Begins uploading an updated file from an in-memory buffer using `PrivMXStoreFileHandler`.
    ///
    /// This method updates an existing file in a store with new content and metadata, supporting chunked uploads for large files.
    ///
    /// - Parameters:
    ///   - buffer: The in-memory content of the updated file as `Data`.
    ///   - storeFile: The identifier of the file in the store to be updated.
    ///   - publicMeta: Public metadata to overwrite the existing metadata.
    ///   - privateMeta: Encrypted metadata to overwrite the existing metadata.
    ///   - size: The size of the updated file in bytes.
    ///   - chunkSize: The size of each chunk to be uploaded.
    ///   - onChunkUploaded: A callback that is called after each chunk upload is completed.
    ///
    /// - Returns: The identifier of the updated file as a `String`.
    ///
    /// - Throws: An error if the update process fails.
   public func startUploadingUpdatedFileFromBuffer(
		_ buffer:Data,
		as storeFile:String,
		replacingPublicMeta publicMeta: Data,
		replacingPrivateMeta privateMeta: Data,
		replacingSize size:Int64,
		withChunksOf chunkSize: Int64 = PrivMXStoreFileHandler.RecommendedChunkSize,
		onChunkUploaded: (@escaping @Sendable (Int) -> Void) = {_ in}
	) async throws -> String {
		var isCancelled = false
		if let api = self.storeApi{
			let sfhandler = try PrivMXStoreFileHandler.getStoreFileUpdater(for: storeFile,
																		   withReplacementBuffer: buffer,
																		   using: api,
																		   replacingPublicMeta: publicMeta,
																		   replacingPrivateMeta: privateMeta,
																		   replacingFileSize: size,
																		   chunkSize: chunkSize)
			while sfhandler.hasDataLeft && !isCancelled{
				try sfhandler.writeChunk(onChunkUploaded: onChunkUploaded)
				withUnsafeCurrentTask(){
					task in
					isCancelled = task?.isCancelled ?? false
				}
			}
			return try sfhandler.close()
			
		} else {
			var err = privmx.InternalError()
			err.message = "StoresApi not initialized"
			err.name = "Api Error"
			throw PrivMXEndpointError.otherFailure(err)
		}
	}
	
	/// Begins downloading a file to the local filesystem using `PrivMXStoreFileHandler`.
    ///
    /// This method downloads a file from a Store to the local filesystem using a `FileHandle`. It supports downloading files in chunks and provides a callback for progress tracking.
    ///
    /// - Parameter file: A local `FileHandle` representing the destination file.
    /// - Parameter fileId: The identifier of the file to be downloaded.
	/// - Parameter chunkSize: The size of individual chunks, by default set to `PrivMXStoreFileHandler.RecommendedChunkSize`
	/// - Parameter onChunkDownloaded: A callback that is called after each chunk download is completed.
    ///
    /// - Returns: The identifier of the downloaded file as a `String`.
    ///
    /// - Throws: An error if the download process fails.
    public func startDownloadingToFile(
		_ file:FileHandle,
		from fileId:String,
		withChunksOf chunkSize: Int64 = PrivMXStoreFileHandler.RecommendedChunkSize,
		onChunkDownloaded: (@escaping @Sendable (Int) -> Void) = {_ in}
	) async throws -> String{
		var isCancelled = false
		if let api = self.storeApi{
			let sfhandler = try PrivMXStoreFileHandler.getStoreFileReader(saveTo: file,
																		  readFrom: fileId,
																		  with: api,
																		  chunkSize:chunkSize)
			while sfhandler.hasDataLeft && !isCancelled{
				try sfhandler.readChunk(onChunkDownloaded: onChunkDownloaded)
				
				withUnsafeCurrentTask(){
					task in
					isCancelled = task?.isCancelled ?? false
				}
			}
			return try sfhandler.close()
		} else {
			var err = privmx.InternalError()
			err.message = "StoresApi not initialized"
			err.name = "Api Error"
			throw PrivMXEndpointError.otherFailure(err)
		}
	}
	
	/// Begins downloading a file to the local filesystem using `InboxFileHandler`.
    ///
    /// This method downloads a file from an Inbox to the local filesystem using a `FileHandle`. It supports downloading files in chunks and provides a callback for progress tracking.
    ///
    /// - Parameter file: A local `FileHandle` representing the destination file.
    /// - Parameter fileId: The identifier of the file to be downloaded.
	/// - Parameter chunkSize: The size of a chunk to be used.
	/// - Parameter onChunkDownloaded: A callback that is called after each chunk download is completed.
    ///
	/// - Returns: The identifier of the downloaded file as a `String`.
    ///
    /// - Throws: An error if the download process fails.
    public func startDownloadingToFileFromInbox(
		_ file:FileHandle,
		from fileId:String,
		withChunksOf chunkSize: Int64 = InboxFileHandler.RecommendedChunkSize,
		onChunkDownloaded: (@escaping @Sendable (Int) -> Void) = {_ in}
	) async throws -> String{
		var isCancelled = false
		if let api = self.inboxApi{
			let sfhandler = try InboxFileHandler.getInboxFileReaderToFile(readFrom: fileId,
																		  with: api,
																		  to: file,
																		  chunkSize: chunkSize)
			while sfhandler.hasDataLeft && !isCancelled{
				try sfhandler.readChunk(onChunkDownloaded: onChunkDownloaded)
				
				withUnsafeCurrentTask(){
					task in
					isCancelled = task?.isCancelled ?? false
				}
			}
			try file.close()
			return try sfhandler.closeRemote()
		} else {
			var err = privmx.InternalError()
			err.message = "StoresApi not initialized"
			err.name = "Api Error"
			throw PrivMXEndpointError.otherFailure(err)
		}
	}
	
	/// Begins downloading a file to in-memory buffer.
    ///
    /// This method downloads a file from a store to the local in-memory buffer. It supports downloading files in chunks and provides a callback for progress tracking.
    ///
    /// - Parameter fileId: The identifier of the file to be downloaded.
	/// - Parameter chunkSize: The size of individual chunks, by default set to `PrivMXStoreFileHandler.RecommendedChunkSize`
	/// - Parameter onChunkDownloaded: A callback that is called after each chunk download is completed.
    ///
	/// - Returns: The identifier of the downloaded file as a `String`.
    ///
	/// - Throws: An error if the download process fails.
    public func startDownloadingToBufferFromInbox(
		from fileId:String,
		withChunksOf chunkSize: Int64 = PrivMXStoreFileHandler.RecommendedChunkSize,
		onChunkDownloaded: (@escaping @Sendable (Int) -> Void) = {_ in}
	) async throws -> Data{
		var isCancelled = false
		if let api = self.inboxApi{
			let sfhandler = try InboxFileHandler.getInboxFileReaderToBuffer(readFrom: fileId,
																			with: api,
																			chunkSize: chunkSize)
			while sfhandler.hasDataLeft && !isCancelled{
				try sfhandler.readChunk(onChunkDownloaded: onChunkDownloaded)
				
				withUnsafeCurrentTask(){
					task in
					isCancelled = task?.isCancelled ?? false
				}
			}
			_ = try sfhandler.closeRemote()
			if let b = sfhandler.getBuffer(){
				return b
			} else {
				var err = privmx.InternalError()
				err.message = "StoresApi not initialized"
				err.name = "Buffer Error"
				throw PrivMXEndpointError.otherFailure(err)
			}
			
		} else {
			var err = privmx.InternalError()
			err.message = "InboxApi not initialized"
			err.name = "Api Error"
			throw PrivMXEndpointError.otherFailure(err)
		}
	}
	
	@available(*,deprecated)
	public func startDownloadingToBuffer(
		_ file:FileHandle,
		from fileId:String,
		withChunksOf chunkSize: Int64 = PrivMXStoreFileHandler.RecommendedChunkSize,
		onChunkDownloaded: (@escaping @Sendable (Int) -> Void) = {_ in}
	) async throws -> Data{
		try await startDownloadingToBuffer(
			from:fileId,
			withChunksOf:PrivMXStoreFileHandler.RecommendedChunkSize,
			onChunkDownloaded: onChunkDownloaded
		)
	}
	
	
	/// Begins downloading a file to in-memory buffer.
    ///
    /// This method downloads a file from a store to the local in-memory buffer. It supports downloading files in chunks and provides a callback for progress tracking.
    ///
    /// - Parameter fileId: The identifier of the file to be downloaded.
	/// - Parameter chunkSize: The size of individual chunks, by default set to `PrivMXStoreFileHandler.RecommendedChunkSize`
    /// - Parameter onChunkDownloaded: A callback that is called after each chunk download is completed.
    ///
    /// - Returns: The identifier of the downloaded file as a `String`.
    ///
    /// - Throws: An error if the download process fails.
    public func startDownloadingToBuffer(
		from fileId:String,
		withChunksOf chunkSize: Int64 = PrivMXStoreFileHandler.RecommendedChunkSize,
		onChunkDownloaded: (@escaping @Sendable (Int) -> Void) = {_ in}
	) async throws -> Data{
		var isCancelled = false
		if let api = self.storeApi{
			let sfhandler = try PrivMXStoreFileHandler.getStoreFileReader(readFrom: fileId,
																		  with: api,
																		  chunkSize: chunkSize)
			while sfhandler.hasDataLeft && !isCancelled{
				try sfhandler.readChunk(onChunkDownloaded: onChunkDownloaded)
				
				withUnsafeCurrentTask(){
					task in
					isCancelled = task?.isCancelled ?? false
				}
			}
			try sfhandler.close()
			if let b = sfhandler.getBuffer(){
				return b
			} else {
				var err = privmx.InternalError()
				err.message = "StoresApi not initialized"
				err.name = "Buffer Error"
				throw PrivMXEndpointError.otherFailure(err)
			}
			
		} else {
			var err = privmx.InternalError()
			err.message = "StoresApi not initialized"
			err.name = "Api Error"
			throw PrivMXEndpointError.otherFailure(err)
		}
	}
	
	/// Registers a callback for a particular event type from a particular scope.
	///
	/// Whenever possible preffer using `registerCallbacksInBulk(_:)` to minimise the amount of server requests.
	///
	/// - Parameter request: `PMXEventCallbackRegistration` instance describing EventType and Scope of the callback; as well as assigning it to a group.
	///
	/// - Throws: When the request is malformed, or subscribing fails.
	public func registerCallback(
		for request: PMXEventCallbackRegistration
	) throws -> Void {
		if let e = registerCallbacksInBulk([request]).first,let e, let e = (e as? PrivMXEndpointError){
			throw e
		}
	}
	
	/// Mass registration for Events, this method optimises the amount of server requests made and is the recommended way to subscribe for events.
	///
	/// - Parameter requests: an arrays of tuples consisting of the callback that will be called when the event arrives, `PMXEventRegistration` value that describes the particular event and a string representing a group of callbacks
	///
	/// - Returns: array of optional Errors corresponding to the provided requests. If the reques was succesfull the associated index will be `nil` otherwise it will have the error thrown.
	public func registerCallbacksInBulk(
		_ requests:[PMXEventCallbackRegistration]
	) -> [(any Error)?] {
		var results = [(any Error)?](repeating: nil, count: requests.count)
		var queryDict = [String:[String:[Int]]]()
		queryDict["thread"] = [:]
		queryDict["store"] = [:]
		queryDict["kvdb"] = [:]
		queryDict["kvdbEntry"] = [:]
		queryDict["inbox"] = [:]
		queryDict["event"] = [:]
		queryDict["platform"] = [:]
		queryDict["core"] = [:]
		
		// Maps requests to Apis
		for i in 0..<requests.count{
			do{
				let req = requests[i]
				switch(req.request){
					case .thread(let event, let selector, let selectorId):
						guard let threadApi
						else{
							throw PrivMXEndpointError.failedSubscribingForEvents(privmx.InternalError(name: "Api not Initialised",
																									  message: "Thread Api was nil",
																									  description: "You need to enable ThreadApi to register for Thread-related events"))
						}
						
						let sq = try threadApi.buildSubscriptionQuery(
							forEventType: event,
							selectorType: privmx.endpoint.thread.EventSelectorType.init(rawValue: selector.rawValue),
							selectorId: selectorId)
						if queryDict["thread"]![sq] == nil{
							queryDict["thread"]![sq]=[i]
						} else {
							queryDict["thread"]![sq]!.append(i)
						}
					case .store(let event, let selector, let selectorId):
						guard let storeApi
						else{
							throw PrivMXEndpointError.failedSubscribingForEvents(privmx.InternalError(name: "Api not Initialised",
																									  message: "Store Api was nil",
																									  description: "You need to enable StoreApi to register for Store-related events"))
						}
						
						let sq = try storeApi.buildSubscriptionQuery(
							forEventType: event,
							selectorType: privmx.endpoint.store.EventSelectorType.init(rawValue: selector.rawValue),
							selectorId: selectorId)
						if queryDict["store"]![sq] == nil{
							queryDict["store"]![sq] = [i]
						} else {
							queryDict["store"]![sq]!.append(i)
						}
					case .inbox(let event, let selector, let selectorId):
						guard let inboxApi
						else{
							throw PrivMXEndpointError.failedSubscribingForEvents(privmx.InternalError(name: "Api not Initialised",
																									  message: "Inbox Api was nil",
																									  description: "You need to enable InboxApi to register for Inbox-related events"))
						}
						let sq = try inboxApi.buildSubscriptionQuery(
							forEventType: event,
							selectorType: privmx.endpoint.inbox.EventSelectorType.init(rawValue: selector.rawValue),
							selectorId: selectorId)
						if queryDict["inbox"]![sq] == nil{
							queryDict["inbox"]![sq]=[i]
						} else {
							queryDict["inbox"]![sq]!.append(i)
						}
					case .kvdb(let event, let selector, let selectorId):
						guard let kvdbApi
						else{
							throw PrivMXEndpointError.failedSubscribingForEvents(privmx.InternalError(name: "Api not Initialised",
																									  message: "Kvdb Api was nil",
																									  description: "You need to enable KvdbApi to register for KVDB-related events"))
						}
						let sq = try kvdbApi.buildSubscriptionQuery(
							forEventType: event,
							selectorType: privmx.endpoint.kvdb.EventSelectorType.init(rawValue: selector.rawValue),
							selectorId: selectorId)
						if queryDict["kvdb"]![sq] == nil{
							queryDict["kvdb"]![sq]=[i]
						} else {
							queryDict["kvdb"]![sq]!.append(i)
						}
					case .custom(let channelName,let contextId):
						guard let eventApi
						else{
							throw PrivMXEndpointError.failedSubscribingForEvents(privmx.InternalError(name: "Api not Initialised",
																									  message: "Event Api was nil",
																									  description: "You need to enable EventApi to register for ContextCustom events"))
						}
						let sq = try eventApi.buildSubscriptionQuery(
							forChannel: channelName,
							selectorType: privmx.endpoint.event.CONTEXT_ID,
							selectorId: contextId)
						if queryDict["event"]![sq] == nil{
							queryDict["event"]![sq]=[i]
						} else {
							queryDict["event"]![sq]!.append(i)
						}
					case .library(let eventType):
						if queryDict["platform"]![String(eventType.rawValue)] == nil{
							queryDict["platform"]![String(eventType.rawValue)] = [i]
						} else {
							queryDict["platform"]![String(eventType.rawValue)]!.append(i)
						}
					case .kvdbEntry(let event, let kvdb, let key):
						guard let kvdbApi
						else{
							throw PrivMXEndpointError.failedSubscribingForEvents(privmx.InternalError(name: "Api not Initialised",
																									  message: "Thread Api was nil",
																									  description: "You need to enable ThreadApi to register for Thread-related events"))
						}
						
						let sq = try kvdbApi.buildSubscriptionQueryForSelectedEntry(
							key,
							from: kvdb,
							for: event)
						if queryDict["kvdbEntry"]![sq] == nil{
							queryDict["kvdbEntry"]![sq]=[i]
						} else {
							queryDict["kvdbEntry"]![sq]!.append(i)
						}
					case .core(let eventType, let contextId):
						let sq = try connection.buildSubscriptionQuery(
							forEventType: eventType,
							selectorType: .Context,
							selectorId: contextId)
						if queryDict["core"]![sq] == nil{
							queryDict["core"]![sq]=[i]
						} else {
							queryDict["core"]![sq]!.append(i)
						}
				}
			} catch {
				results[i] = error
			}
		}
		
		
		// actual subscriptions
		if let threadQuery = queryDict["thread"], threadApi != nil{
			do{
				let reqv = threadQuery.map({x in x})
				let resv = try threadApi!.subscribeFor(reqv.map({x in x.key}))
				for res in resv{
					for req in reqv{
						for i in req.value{
							let r = requests[i]
							if callbacks[res] == nil {
								callbacks[res] = (r.request,[:])
							}
							if callbacks[res]!.1[r.group] == nil {
								callbacks[res]!.1[r.group] = []
							}
							callbacks[res]!.1[r.group]!.append(r.cb)
						}
					}
				}
			} catch {
				for q in threadQuery{
					for i in q.value {
						results[i] = error
					}
				}
			}
		}
		if let storeQuery = queryDict["store"], storeApi != nil{
			do{
				let reqv = storeQuery.map({x in x})
				let resv = try storeApi!.subscribeFor(storeQuery.map({x in x.0}))
				for res in resv{
					for req in reqv{
						for i in req.value{
							let r = requests[i]
							if callbacks[res] == nil {
								callbacks[res] = (r.request,[:])
							}
							if callbacks[res]!.1[r.group] == nil {
								callbacks[res]!.1[r.group] = []
							}
							callbacks[res]!.1[r.group]!.append(r.cb)
						}
					}
				}
			} catch {
				for q in storeQuery{
					for i in q.value {
						results[i] = error
					}
				}
			}
		}
		if let inboxQuery = queryDict["inbox"], inboxApi != nil{
			do{
				let reqv = inboxQuery.map({x in x})
				let resv = try inboxApi!.subscribeFor(inboxQuery.map({x in x.0}))
				for res in resv{
					for req in reqv{
						for i in req.value{
							let r = requests[i]
							if callbacks[res] == nil {
								callbacks[res] = (r.request,[:])
							}
							if callbacks[res]!.1[r.group] == nil {
								callbacks[res]!.1[r.group] = []
							}
							callbacks[res]!.1[r.group]!.append(r.cb)
						}
					}
				}
			} catch {
				for q in inboxQuery{
					for i in q.value {
						results[i] = error
					}
				}
			}
		}
		if let kvdbQuery = queryDict["kvdb"], kvdbApi != nil{
			do{
				let reqv = kvdbQuery.map({x in x})
				let resv = try kvdbApi!.subscribeFor(kvdbQuery.map({x in x.0}))
				for res in resv{
					for req in reqv{
						for i in req.value{
							let r = requests[i]
							if callbacks[res] == nil {
								callbacks[res] = (r.request,[:])
							}
							if callbacks[res]!.1[r.group] == nil {
								callbacks[res]!.1[r.group] = []
							}
							callbacks[res]!.1[r.group]!.append(r.cb)
						}
					}
				}
			} catch {
				for q in kvdbQuery{
					for i in q.value {
						results[i] = error
					}
				}
			}
		}
		if let eventQuery = queryDict["event"], eventApi != nil{
			do{
				let reqv = eventQuery.map({x in x})
				let resv = try eventApi!.subscribeFor(eventQuery.map({x in x.0}))
				for res in resv{
					for req in reqv{
						for i in req.value{
							let r = requests[i]
							if callbacks[res] == nil {
								callbacks[res] = (r.request,[:])
							}
							if callbacks[res]!.1[r.group] == nil {
								callbacks[res]!.1[r.group] = []
							}
							callbacks[res]!.1[r.group]!.append(r.cb)
						}
					}
				}
			} catch {
				for q in eventQuery{
					for i in q.value {
						results[i] = error
					}
				}
			}
		}
		if let coreQuery = queryDict["core"]{
			do{
				let reqv = coreQuery.map({x in x})
				let resv = try connection.subscribeFor(coreQuery.map({x in x.0}))
				for res in resv{
					for req in reqv{
						for i in req.value{
							let r = requests[i]
							if callbacks[res] == nil {
								callbacks[res] = (r.request,[:])
							}
							if callbacks[res]!.1[r.group] == nil {
								callbacks[res]!.1[r.group] = []
							}
							callbacks[res]!.1[r.group]!.append(r.cb)
						}
					}
				}
			} catch {
				for q in coreQuery{
					for i in q.value {
						results[i] = error
					}
				}
			}
		}
		
		if let libQuery = queryDict["platform"]{
			let reqv = libQuery.map({x in x})
			let resv = libQuery.map({x in x.0})
			for res in resv{
				for req in reqv{
					for i in req.value{
						let r = requests[i]
						if callbacks[res] == nil {
							callbacks[res] = (r.request,[:])
						}
						if callbacks[res]!.1[r.group] == nil {
							callbacks[res]!.1[r.group] = []
						}
						callbacks[res]!.1[r.group]!.append(r.cb)
					}
				}
			}
		}
		return results
	}
	
	/// Removes all callbacks for a particular Request.
	///
	/// - Parameter request: the request specifying Event Type and Scope
	///
	/// - Throws: When unsubscribing fails.
	@available(*, deprecated, message: "Removing part of the callbacks causes Undefined Behaviour in 2.6.0, please use clearAllCallbacks() instead")
	public func clearCallbacks(
		for request: PMXEventSubscriptionRequest
	) throws -> Void {
		callbacks.filter({x in x.value.0 == request}).forEach({x in callbacks[x.key]?.1.removeAll()})
		let errs = unsubscribeFromEmpty()
		if !errs.allSatisfy({x in x == nil}) {
			var errmsg = "Following errors were thrown:"
			var errno = 0
			errs.forEach {
				x in
				if x != nil{
					errmsg += "\(errno):"
					if let e = x as? PrivMXEndpointError {
						errmsg += "( Name:\(e.getName()), Description: \(e.getDescription()),Message: \(e.getMessage()),Code(hex): \(String(e.getCode() ?? 0,radix: 16)) )\n"
					} else {
						errmsg += "( \(x!) )\n"
					}
					errno += 1
				}
			}
			throw PrivMXEndpointError.failedUnsubscribingFromEvents(privmx.InternalError(name: "FailedUnsubscribing", message: "Failed unsubscribing", description: "Callbacks have been removed, but some events may still arrive. \(errmsg)"))
		}
	}
	
	/// Removes all registered callbacks assigned to `group`.
	///
	/// If this removes the last callback for a subscription, it will automatically unsubscribe.
	///
	/// - Parameter group: the group that has been assigned when registering callbacks.
	///
	/// - Throws: when unsubscribing fails.
	@available(*, deprecated, message: "Removing part of the callbacks causes Undefined Behaviour in 2.6.0, please use clearAllCallbacks() instead")
	public func clearCallbacks(
		in group:String
	) throws -> Void {
		callbacks.forEach({x in callbacks[x.key]?.1.removeValue(forKey: group)})
		let errs = unsubscribeFromEmpty()
		
		if !errs.allSatisfy({x in x == nil}) {
			var errmsg = "Following errors were thrown:"
			var errno = 0
			errs.forEach {
				x in
				if x != nil{
					errmsg += "\(errno):"
					if let e = x as? PrivMXEndpointError {
						errmsg += "( Name:\(e.getName()), Description: \(e.getDescription()),Message: \(e.getMessage()),Code(hex): \(String(e.getCode() ?? 0,radix: 16)) )\n"
					} else {
						errmsg += "( \(x!) )\n"
					}
					errno += 1
				}
			}
			throw PrivMXEndpointError.failedUnsubscribingFromEvents(privmx.InternalError(name: "FailedUnsubscribing", message: "Failed unsubscribing", description: "Callbacks have been removed, but some events may still arrive.\(errmsg)"))
		}
	}
	
	/// Removes all registered callbacks and subscriptions for Events.
	public func clearAllCallbacks(
	) throws -> Void {
		callbacks.forEach({x in callbacks[x.key]?.1.removeAll()})
		let errs = unsubscribeFromEmpty()
		if !errs.allSatisfy({x in x == nil}) {
			var errmsg = "Following errors were thrown:"
			var errno = 0
			errs.forEach {
				x in
				if x != nil{
					errmsg += "\(errno):"
					if let e = x as? PrivMXEndpointError {
						errmsg += "( Name:\(e.getName()), Description: \(e.getDescription()),Message: \(e.getMessage()),Code(hex): \(String(e.getCode() ?? 0,radix: 16)) )\n"
					} else {
						errmsg += "( \(x!) )\n"
					}
					errno += 1
				}
			}
			throw PrivMXEndpointError.failedUnsubscribingFromEvents(privmx.InternalError(name: "FailedUnsubscribing", message: "Failed unsubscribing", description: "Callbacks have been removed, but some events may still arrive. \(errmsg)"))
		}
	}
	
	/// Removes all subscripitons that do not have any callbacks.
	private func unsubscribeFromEmpty(
	) -> [(any Error)?] {
		let calls = callbacks.filter({ x in x.value.1.isEmpty && x.key != "platform"}).map({x in x})
		var res = [(any Error)?](repeating: nil, count: calls.count)
		var queryDict = [String:[(String,Int)]]()
		let keyArr = calls.map({x in x.key})
		queryDict["thread"] = []
		queryDict["store"] = []
		queryDict["kvdb"] = []
		queryDict["kvdbEntry"] = []
		queryDict["inbox"] = []
		queryDict["event"] = []
		queryDict["platform"] = []
		queryDict["core"] = []
		for i in 0..<calls.count{
			switch calls[i].value.0{
				case .thread:
					queryDict["thread"]!.append((keyArr[i],i))
				case .store:
					queryDict["store"]!.append((keyArr[i],i))
				case .inbox:
					queryDict["inbox"]!.append((keyArr[i],i))
				case .kvdb,.kvdbEntry:
					queryDict["kvdb"]!.append((keyArr[i],i))
				case .custom:
					queryDict["event"]!.append((keyArr[i],i))
				case .library:
					queryDict["platform"]!.append((keyArr[i],i))
				case .core:
					queryDict["core"]!.append((keyArr[i],i))
			}
		}
		
		if let req = queryDict["thread"]?.map({x in x.0}), let threadApi{
			do{
				try threadApi.unsubscribeFrom(req)
				for r in req{
					callbacks.removeValue(forKey: r)
				}
			} catch {
				for q in queryDict["thread"] ?? []{
					res[q.1] = error
				}
			}
		}
		if let req = queryDict["store"]?.map({x in x.0}), let storeApi{
			do{
				try storeApi.unsubscribeFrom(req)
				for r in req{
					callbacks.removeValue(forKey: r)
				}
			} catch {
				for q in queryDict["store"] ?? []{
					res[q.1] = error
				}
			}
		}
		if let req = queryDict["kvdb"]?.map({x in x.0}), let kvdbApi{
			do{
				try kvdbApi.unsubscribeFrom(req)
				for r in req{
					callbacks.removeValue(forKey: r)
				}
			} catch {
				for q in queryDict["kvdb"] ?? []{
					res[q.1] = error
				}
			}
		}
		if let req = queryDict["inbox"]?.map({x in x.0}), let inboxApi{
			do{
				try inboxApi.unsubscribeFrom(req)
				for r in req{
					callbacks.removeValue(forKey: r)
				}
			} catch {
				for q in queryDict["inbox"] ?? []{
					res[q.1] = error
				}
			}
		}
		if let req = queryDict["event"]?.map({x in x.0}), let eventApi{
			do{
				try eventApi.unsubscribeFrom(req)
				for r in req{
					callbacks.removeValue(forKey: r)
				}
			} catch {
				for q in queryDict["event"] ?? []{
					res[q.1] = error
				}
				
			}
		}
		if let req = queryDict["platform"]?.map({x in x.0}) {
				for r in req{
					callbacks.removeValue(forKey: r)
				}
		}
		if let req = queryDict["core"]?.map({x in x.0}){
			do{
				try connection.unsubscribeFrom(req)
				for r in req{
					callbacks.removeValue(forKey: r)
				}
			} catch {
				for q in queryDict["core"] ?? []{
					res[q.1] = error
				}
				
			}
		}
		return res
	}
	
	public func handleEvent (
		_ event: any PMXEvent
	) async throws {
		let subscriptionList = event.getSubscriptionList()
		for id in subscriptionList{
			for r in callbacks[id]?.1 ?? [:] {
				for cb in r.value{
						event.handleWith(cb: cb)
				}
			}
		}
	}
}

