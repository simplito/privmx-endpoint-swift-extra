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
///
/// ## Key Features:
///
/// - **Connection Management:** Manages the connection to PrivMX Bridge via the `PrivMXConnection` instance.
/// - **APIs for Threads, Stores, and Inboxes:** Provides access to different APIs for managing threads (`PrivMXThread`), stores (`PrivMXStore`), and inboxes (`PrivMXInbox`).
/// - **File Upload and Download:** Supports uploading new files and updating existing files to/from a store, either from a file or in-memory buffer, with progress tracking.
/// - **Callback Management:** Allows registering, deleting, and clearing event callbacks from various channels (such as Threads, Stores, and Inboxes).
/// - **Event Handling:** Manages event subscriptions and dispatches events to registered callbacks.
///
/// ## Initialization:
///
/// The `PrivMXEndpoint` class is initialized with a connection to PrivMX Bridge using user credentials, Solution ID, and platform URL.
/// Based on the provided modules, it sets up the APIs for handling Threads, Stores, and Inboxes.
///
/// - Parameters:
///   - modules: A set of `PrivMXModule` instances to enable various APIs.
///   - userPrivKey: The user's private key in WIF format.
///   - solutionId: The unique identifier for PrivMX solution.
///   - platformUrl: The URL of PrivMX Bridge instance.
///
/// - Throws: An error if the connection or module initialization fails.
///
/// ## File Operations:
///
/// - Supports uploading and downloading files to/from a Store, either from a file (swift-nio) or in-memory buffer.
/// - Provides progress tracking for file upload/download operations.
/// - Supports chunked file transfers to handle large files efficiently.
///
/// ## Callback and Event Management:
///
/// - Registers callbacks for various events from different channels, such as Threads, Stores, or Inboxes.
/// - Provides methods for removing callbacks for specific events or channels.
/// - Automatically manages subscribing and unsubscribing from events, based on the registered callbacks.
public class PrivMXEndpoint: Identifiable{
	
	public let id:Int64
	
	/// Marks the endpoint as connected using no authorisation.
	public let anonymous: Bool
	/// Provides handling of network and events through `PrivMXConnection`.
	public private(set) var connection : PrivMXConnection
	/// API for handling threads.
	public private(set) var threadApi : PrivMXThread?
	/// API for handling stores.
	public private(set) var storeApi : PrivMXStore?
	/// API for handling inboxes.
	public private(set) var inboxApi : PrivMXInbox?
	
	
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
		self.id = try! con.getConnectionId()
	}
	
	fileprivate var callbacks : [String:[String: [String :  [(@Sendable (_ data:Any?)->Void)]]]] = [:]
	fileprivate var cbId = 0
	
	/// Begins uploading a new file using `PrivMXStoreFileHandler`, which manages file uploads.
	///
	/// This method uploads a file to a specified store using a `FileHandle`. It supports uploading large files in chunks and provides a callback for tracking the progress.
	///
	/// - Parameters:
	///   - file: A local `FileHandle` representing the file to be uploaded.
	///   - store: The identifier of the destination store.
	///   - publicMeta: Public, unencrypted metadata for the file.
	///   - privateMeta: Encrypted metadata for the file.
	///   - size: The size of the file in bytes.
	///   - onChunkUploaded: A callback that is called after each chunk upload is completed.
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
			err.message = "StoresApi not initialised"
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
			err.message = "StoresApi not initialised"
			err.name = "Api Error"
			throw PrivMXEndpointError.otherFailure(err)
		}
	}
	
	//// Begins uploading an updated file using `PrivMXStoreFileHandler`.
    ///
    /// This method updates an existing file in a store with new content and metadata, supporting chunked uploads for large files.
    ///
    /// - Parameters:
    ///   - file: A local `FileHandle` representing the updated file.
    ///   - storeFile: The identifier of the file in the store to be updated.
    ///   - publicMeta: Public metadata to overwrite the existing metadata.
    ///   - privateMeta: Encrypted metadata to overwrite the existing metadata.
    ///   - size: The size of the updated file in bytes.
    ///   - onChunkUploaded: A callback that is called after each chunk upload is completed.
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
			err.message = "StoresApi not initialised"
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
			err.message = "StoresApi not initialised"
			err.name = "Api Error"
			throw PrivMXEndpointError.otherFailure(err)
		}
	}
	
	/// Begins downloading a file to the local filesystem using `PrivMXStoreFileHandler`.
    ///
    /// This method downloads a file from a Store to the local filesystem using a `FileHandle`. It supports downloading files in chunks and provides a callback for progress tracking.
    ///
    /// - Parameters:
    ///   - file: A local `FileHandle` representing the destination file.
    ///   - fileId: The identifier of the file to be downloaded.
    ///   - onChunkDownloaded: A callback that is called after each chunk download is completed.
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
			err.message = "StoresApi not initialised"
			err.name = "Api Error"
			throw PrivMXEndpointError.otherFailure(err)
		}
	}
	
	/// Begins downloading a file to in-memory buffer.
    ///
    /// This method downloads a file from a store to the local in-memory buffer. It supports downloading files in chunks and provides a callback for progress tracking.
    ///
    /// - Parameters:
    ///   - fileId: The identifier of the file to be downloaded.
    ///   - onChunkDownloaded: A callback that is called after each chunk download is completed.
    ///
    /// - Returns: The identifier of the downloaded file as a `String`.
    ///
    /// - Throws: An error if the download process fails.
    public func startDownloadingToBuffer(
		_ file:FileHandle,
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
				err.message = "StoresApi not initialised"
				err.name = "Buffer Error"
				throw PrivMXEndpointError.otherFailure(err)
			}
			
		} else {
			var err = privmx.InternalError()
			err.message = "StoresApi not initialised"
			err.name = "Api Error"
			throw PrivMXEndpointError.otherFailure(err)
		}
	}
	
	/// Registers a callback for an Event from a particular Channel.
	///
	/// This also causes events to start arriving from that channel.
	///
	/// - Parameters:
	/// 	- type: type of Event
	/// 	- channel channel: Endpoint defined event channel such as .platform or .thread
	/// 	- id: Custom identifier for managing Callbacks
	public func registerCallback(
		for type: PMXEvent.Type,
		from channel:EventChannel,
		identified id:String,
		_ cb: (@escaping @Sendable (Any?) -> Void) = {_ in}
	) throws -> Void {
		if callbacks[channel.name] == nil{
			callbacks[channel.name] = [:]
			switch channel{
				case .store:
					try self.storeApi?.subscribeForStoreEvents()
				case .thread:
					try self.threadApi?.subscribeForThreadEvents()
				case .threadMessages(let threadID):
					try self.threadApi?.subscribeForMessageEvents(in: threadID)
				case .storeFiles(let storeID):
					try self.storeApi?.subscribeForFileEvents(in: storeID)
				case .platform:
					break
				case .inbox:
					try self.inboxApi?.subscribeForInboxEvents()
				case .inboxEntries(let inboxID):
					try self.inboxApi?.subscribeForEntryEvents(in: inboxID)
			}
		}
		if callbacks[channel.name]?[type.typeStr()] == nil{
			callbacks[channel.name]?[type.typeStr()] = [:]
		}
		if callbacks[channel.name]?[type.typeStr()]?[id] == nil{
			callbacks[channel.name]?[type.typeStr()]?[id] = []
			
		}
		callbacks[channel.name]?[type.typeStr()]?[id]?.append(cb)
	}
	
	/// Deletes a specific Callback.
	///
	/// Note that this is an expensive operation.
	/// If there are no callbacks left for events from a particular channel, `Connection.unsubscribeFromChannel(_:)` is called, which means no Events from that Channel will arrive.
	///
	/// - Parameter id: ID of the callback to be deleted
	public func deleteCallbacks(
		identified id:String
	) -> Void {
		for c in callbacks.keys{
			for t in callbacks[c]!.keys{
				callbacks[c]?[t]?.removeValue(forKey: id)
			}
			if nil != callbacks[c], (callbacks[c] ?? [:]).isEmpty{
				callbacks.removeValue(forKey: c)
				try? unsubscribeFromChannel(c)
			}
		}
		
	}
	
	/// Removes all callbacks for a particular Event type.
	///
	/// If there are no callbacks left for events from a particular channel, `Connection.unsubscribeFromChannel(_:)` is called, which means no Events from that Channel will arrive.
	///
	/// - Parameter type: the type of Event, for which callbacks should be removed.
	public func clearCallbacks(
		for type:PMXEvent.Type
	) -> Void {
		for c in callbacks.keys{
			callbacks[c]!.removeValue(forKey: type.typeStr())
			if nil != callbacks[c], (callbacks[c] ?? [:]).isEmpty{
				try? unsubscribeFromChannel(c)
				callbacks.removeValue(forKey: c)
			}
		}
	}
	
	/// Removes all registered callbacks for Events from selected Channel
	///
	/// Once all callbacks are removed, `Connection.unsubscribeFromChannel(_:)` is called, which means no Events from that Channel will arrive.
	///
	/// - Parameter channel: the EventChannel, from which events should no longer be received
	public func clearCallbacks(
		for channel:EventChannel
	) -> Void {
		callbacks.removeValue(forKey: channel.name)
		try? unsubscribeFromChannel(channel.name)
	}
	
	/// Removes all registered callbacks for Events and unsubscribes from all channels
	public func clearAllCallbacks(
	) -> Void {
		for c in callbacks.keys{
			try? unsubscribeFromChannel(c)
		}
		callbacks.removeAll()
	}
	/// Removes all registered callbacks for Events from selected Channel
	///
	/// - Parameter channel: the EventChannel, from which events should no longer be received
	private func unsubscribeFromChannel(
		_ c:String
	) throws {
		let splitted = c.split(separator: "/")
		switch splitted{
			case _ where splitted.count == 1:
				let s = String(splitted[0])
				if s == "thread"{
					try threadApi?.unsubscribeFromThreadEvents()
				}else if s == "store"{
					try storeApi?.unsubscribeFromStoreEvents()
				} else if s == "inbox" {
					try inboxApi?.unsubscribeFromInboxEvents()
				}
			case _ where splitted.count == 3:
				let id = String(splitted[1])
				let s = String(splitted[0])
				if s == "thread"{
					try threadApi?.unsubscribeFromMessageEvents(in: id)
				}else if s == "store"{
					try storeApi?.unubscribeFromFileEvents(in: id)
				}else if s == "inbox"{
					try inboxApi?.unsubscribeFromEntryEvents(in: id)
				}
			default:
				break
		}
	}
	
	public func handleEvent (
		_ event: any PMXEvent,
		ofType t: any PMXEvent.Type
	) async throws {
		for id in self.callbacks[event.getChannel()]?[t.typeStr()] ?? [:]{
			for cb in id.value{
				 event.handleWith(cb:cb)
			}
		}
	}
}