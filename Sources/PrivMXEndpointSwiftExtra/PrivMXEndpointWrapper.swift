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
import PrivMXEndpointSwiftNative
import PrivMXEndpointSwift

/// Wrapper class holding an instance of CoreApi, as well as optional
public class PrivMXEndpointWrapper{
	/// Provides handling of network and events
	public private(set) var coreApi : PrivMXCore
	/// Provides handling of Threads
	public private(set) var threadsApi : PrivMXThread?
	/// Provides handling of Stores
	public private(set) var storesApi : PrivMXStore?
	
	/// Creates a new Instance of PrivMXEndpointWrapper with CoreApi instance and selected additional modules
	///
	/// - Parameter modules: A set of modules to be initialised
	/// - Parameter userPrivKey: Private key of the User
	/// - Parameter solutionId: Id of the Solution
	/// - Parameter platformUrl: Address of the Platform
	/// - Parameter onDisconnect: Callback for handling of the loss of connection
	///
	/// - Throws: When an instance could not be created
	public init(
		modules:Set<PrivMXModule>,
		userPrivKey:String,
		solutionId:String,
		platformUrl:String,
		onDisconnect:@escaping ((Any)->Void) = {_ in}
	) throws {
		var con = try CoreApi(userPrivKey: std.string(userPrivKey),
							  solutionId: std.string(solutionId),
							  platformUrl: std.string(platformUrl))
		self.coreApi = con
		for m in modules{
			switch m{
			case .store:
				self.storesApi = StoreApi(coreApi: &con)
			case .thread:
				self.threadsApi = ThreadApi(coreApi: &con)
			}
		}
		
		_ = self.registerCallback(for: privmx.endpoint.core.LibDisconnectedEvent.self, from: .platform, onDisconnect)
	}
	
	fileprivate var callbacks : [String:[String: [Int : ((_ data:Any?)->Void)]]] = [:]
	fileprivate var task: Task<Void,Error>?
	fileprivate static var cbId = 0
	
	/// Begins uploading a new File using an instance of `PrivMXStoreFileHandler`
	///
	/// 
	public func startUploadingNewFile(
		_ file:FileHandle,
		to store:String,
		sized size:Int64,
		mimetype:String,
		named name:String,
		onChunkUploaded: @escaping ((Int) -> Void) = {_ in},
		onFileUploaded:@escaping ((String) -> Void) = {_ in}
	) async throws -> Void{
		var isCancelled = false
		if let api = self.storesApi{
				let sfhandler = try PrivMXStoreFileHandler.getStoreFileCreator(inStore: store,
														   from: file,
														   with: api,
														   fileSize: size,
														   fileMimetype: mimetype,
														   fileName: name)
				while sfhandler.hasDataLeft && !isCancelled{
					try sfhandler.writeChunk(onChunkUploaded: onChunkUploaded)
					withUnsafeCurrentTask(){
						task in
						isCancelled = task?.isCancelled ?? false
					}
				}
				
				onFileUploaded(try sfhandler.close())
		} else {
			throw PrivMXEndpointError.otherFailure(msg: "StoresApi not initialised")
		}
	}
	
	/// Begins uploading an updated File using an instance of `PrivMXStoreFileHandler`
	public func startUploadingUpdatedFile(
		_ file:FileHandle,
		storeFile:String,
		sized size:Int64,
		mimetype:String,
		named name:String,
		onChunkUploaded: @escaping ((Int) -> Void) = {_ in},
		onFileUploaded: @escaping ((String)->Void) = {_ in}
		
	) throws -> Void{
		var isCancelled = false
		if let api = self.storesApi{
			let sfhandler = try PrivMXStoreFileHandler.getStoreFileUpdater(for: storeFile,
																		   from: file,
																		   with: api,
																		   fileSize: size,
																		   fileMimetype: mimetype,
																		   fileName: name)
			while sfhandler.hasDataLeft && !isCancelled{
				try sfhandler.writeChunk(onChunkUploaded: onChunkUploaded)
				withUnsafeCurrentTask(){
					task in
					isCancelled = task?.isCancelled ?? false
				}
			}
			onFileUploaded(try sfhandler.close())
			
		} else {
			throw PrivMXEndpointError.otherFailure(msg: "StoresApi not initialised")
		}
	}
	
	/// Begins downloading a File using an instance of `PrivMXStoreFileHandler`
	public func startDownloadingToFile(
		_ file:FileHandle,
		from fileId:String,
		onChunkDownloaded: @escaping ((Int) -> Void) = {_ in},
		onFileDownloaded: @escaping ((String) -> Void) = {_ in}
	) throws -> Void{
		var isCancelled = false
		if let api = self.storesApi{
			let sfhandler = try PrivMXStoreFileHandler.getStoreFileReader(saveTo: file,
																		  readFrom: fileId,
																		  with: api)
			while sfhandler.hasDataLeft && !isCancelled{
				try sfhandler.readChunk(onChunkDownloaded: onChunkDownloaded)
				
				withUnsafeCurrentTask(){
					task in
					isCancelled = task?.isCancelled ?? false
				}
			}
			onFileDownloaded(try sfhandler.close())
		} else {
			throw PrivMXEndpointError.otherFailure(msg: "StoresApi not initialised")
		}
	}
	
	/// Downloads a file and returns it as a `Data`
	public func downloadFile(
		fileId:String
	) throws -> Data{
		if let api = self.storesApi{
			let size = try api.getFile(fileId).size
			let handle = try api.openFile(fileId)
			let data = try api.readFile(handle: handle, length: size)
			_ = try api.closeFile(handle: handle)
			return data
		}else{
			throw PrivMXEndpointError.otherFailure(msg: "StoresApi not initialised")
		}
	}
	
	/// Uploads the Data as a single file
	///
	/// Do note that this does not upload a chunk, for that use `startUploadingNewFile`.
	///
	/// - Parameter store: to which Store should the file be uploaded
	/// - Parameter data: raw bytes of the file
	/// - Parameter mimetype: mimetype of the file
	/// - Parameter name: name of the file
	///
	/// - Throws: `PrivMXEndpointError.otherFailure` when the Stores Api wasnt initialised, `PrivMXEndpointError.failedCreatingFile`
	public func uploadNewFile(
		in store:String,
		data:Data,
		mimetype:String,
		name:String
	) throws -> String{
		if let api = self.storesApi{
			let handle = try api.createFile(in: store, size: Int64(data.count), mimetype: mimetype, name: name)
			try api.writeFile(handle: handle, dataChunk: data)
			return try api.closeFile(handle: handle)
		}else{
			throw PrivMXEndpointError.otherFailure(msg: "StoresApi not initialised")
		}
	}
	
	/// Updates the file "whiolesale"
	///
	/// The preffered way of upladin gis through `startUploadingUpdatedFile` method.
	public func uploadUpdatedFile(
		_ fileId:String,
		data:Data,
		mimetype:String,
		name:String
	) throws -> String{
		if let api = self.storesApi{
			let handle = try api.updateFile(fileId, size: Int64(data.count), mimetype: mimetype, name: name)
			try api.writeFile(handle: handle, dataChunk: data)
			return try api.closeFile(handle: handle)
		}else{
			throw PrivMXEndpointError.otherFailure(msg: "StoresApi not initialised")
		}
	}
	
	public func isListening() -> Bool {
		nil != self.task
	}
	
	/// Registers a callback for an Event from a particular Channel
	///
	/// This also causes events to start arriving from that channel
	///
	/// - Parameter type: type of Event
	/// - Parameter channel:
	public func registerCallback(
		for type: PMXEvent.Type,
		from channel:EventChannel,
		_ cb: @escaping ((Any?)->Void)
	) -> Int {
		if callbacks[channel.name] == nil{
			callbacks[channel.name] = [:]
			try? coreApi.subscribeToChannel(channel.name)
		}
		if callbacks[channel.name]?[type.typeStr()] == nil{
			callbacks[channel.name]?[type.typeStr()] = [:]
		}
		callbacks[channel.name]?[type.typeStr()]?[PrivMXEndpointWrapper.cbId]=cb
		PrivMXEndpointWrapper.cbId+=1
		return PrivMXEndpointWrapper.cbId-1
	}
	
	/// Deletes a specific Callback
	///
	/// If there are no callbacks left for events from a particular channel, `CoreApi.unsubscribeFromChannel(_:)` is called, which means no Events from that Channel will arrive.
	///
	/// - Parameter id: Id of the callback to be deleted
	public func deleteCallback(
		_ id:Int
	) -> Void {
		
		for c in callbacks.keys{
			for t in callbacks[c]!.keys{
				callbacks[c]?[t]?.removeValue(forKey: id)
			}
			if callbacks[c]!.isEmpty{
				callbacks.removeValue(forKey: c)
				try? coreApi.unsubscribeFromChannel(c)
			}
		}
		
	}
	
	/// Removes all callbacks for a partitular Event type.
	///
	/// If there are no callbacks left for events from a particular channel, `CoreApi.unsubscribeFromChannel(_:)` is called, which means no Events from that Channel will arrive.
	///
	/// - Parameter type: the type of Event, for which callbacks should be removed.
	public func clearCallbacks(
		for type:PMXEvent.Type
	) -> Void {
		for c in callbacks.keys{
			callbacks[c]!.removeValue(forKey: type.typeStr())
			if callbacks[c]!.isEmpty{
				try? coreApi.unsubscribeFromChannel(c)
				callbacks.removeValue(forKey: c)
			}
		}
	}
	
	/// Removes all registered callbacks for Events from selected Channel
	///
	/// Once all callbacks are removed, `CoreApi.unsubscribeFromChannel(_:)` is called, which means no Events from that Channel will arrive.
	///
	/// - Parameter channel: the EventChannel, from which events should no longer be received
	public func clearCallbacks(
		for channel:EventChannel
	) -> Void {
		callbacks.removeValue(forKey: channel.name)
		try? coreApi.unsubscribeFromChannel(channel.name)
	}
	
	/// Starts listening for Events
	///
	///  - Throws: `PrivMXEndpointError.otherFailure` when already listening for Events
	public func startListening(
		listenerErrorHandler: @escaping ((Error) -> Void)
	) throws -> Void {
		
		if self.isListening(){
			throw PrivMXEndpointError.otherFailure(msg: "Event Listener already runninng")
		}
		self.loop(listenerErrorHandler)
	}
	
	/// Stops listening for Events
	public func stopListening(
	) -> Void {
		self.task?.cancel()
	}
	
	private struct ParsedEvent{
		init(_ e:any PMXEvent, _ t: any PMXEvent.Type,_ c : EventChannel){
			type = t
			event = e
			channel = c
		}
		var event:any PMXEvent
		var type: any PMXEvent.Type
		var channel:EventChannel
	}
	
	private func parseEvent(
		_ eh: privmx.endpoint.core.EventHolder
	) throws -> ParsedEvent? {
		var x :any PMXEvent
		var ec:EventChannel
		if try CoreApi.isLibConnectedEvent(holder: eh){
			x = try CoreApi.extractLibConnectedEvent(holder: eh)
			ec = .platform
		}else if try CoreApi.isLibDisconnectedEvent(holder: eh){
			x = try CoreApi.extractLibDisconnectedEvent(holder: eh)
			ec = .platform
		}else if try CoreApi.isLibPlatformDisconnectedEvent(holder: eh){
			x = try CoreApi.extractLibPlatformDisconnectedEvent(holder: eh)
			ec = .platform
		}else if try ThreadApi.isThreadCreatedEvent(holder: eh){
			x = try ThreadApi.extractThreadCreatedEvent(holder: eh)
			ec = .thread2
		}else if try ThreadApi.isThreadUpdatedEvent(holder: eh){
			x = try ThreadApi.extractThreadUpdatedEvent(holder: eh)
			ec = .thread2
		}else if try ThreadApi.isThreadDeletedEvent(holder: eh){
			x = try ThreadApi.extractThreadDeletedEvent(holder: eh)
			ec = .thread2
		}else if try ThreadApi.isThreadStatsEvent(holder: eh){
			x = try ThreadApi.extractThreadStatsEvent(holder: eh)
			ec = .thread2
		}else if try ThreadApi.isThreadNewMessageEvent(holder: eh){
			x = try ThreadApi.extractThreadNewMessageEvent(holder: eh)
			ec = .threadMessages(threadID: String((x as! privmx.endpoint.thread.ThreadNewMessageEvent).data.info.threadId))
		}else if try ThreadApi.isThreadDeletedMessageEvent(holder: eh){
			x = try ThreadApi.extractThreadDeletedMessageEvent(holder: eh)
			ec = .threadMessages(threadID: String((x as! privmx.endpoint.thread.ThreadDeletedMessageEvent).data.threadId))
		}else if try StoreApi.isStoreCreatedEvent(holder: eh){
			x = try StoreApi.extractStoreCreatedEvent(holder: eh)
			ec = .store
		}else if try StoreApi.isStoreUpdatedEvent(holder: eh){
			x = try StoreApi.extractStoreUpdatedEvent(holder: eh)
			ec = .store
		}else if try StoreApi.isStoreDeletedEvent(holder: eh){
			x = try StoreApi.extractStoreDeletedEvent(holder: eh)
			ec = .store
		}else if try StoreApi.isStoreStatsChangedEvent(holder: eh){
			x = try StoreApi.extractStoreStatsChangedEvent(holder: eh)
			ec = .store
		}else if try StoreApi.isStoreFileCreatedEvent(holder: eh){
			x = try StoreApi.extractStoreFileCreatedEvent(holder: eh)
			ec = .storeFiles(storeID: String((x as! privmx.endpoint.store.StoreFileCreatedEvent).data.storeId))
		}else if try StoreApi.isStoreFileUpdatedEvent(holder: eh){
			x = try StoreApi.extractStoreFileUpdatedEvent(holder: eh)
			ec = .storeFiles(storeID: String((x as! privmx.endpoint.store.StoreFileUpdatedEvent).data.storeId))
		} else if try StoreApi.isStoreFileDeletedEvent(holder: eh){
			x = try StoreApi.extractStoreFileDeletedEvent(holder: eh)
			ec = .storeFiles(storeID: String((x as! privmx.endpoint.store.StoreFileDeletedEvent).data.storeId))
		}else{
			return nil
		}
		return ParsedEvent(x,type(of: x),ec)
	}
	
	private func loop(
		_ listenerErrorHandler: @escaping ((Error) -> Void)
	) -> Void {
		self.task = Task.detached(priority: .background){
			while !Task.isCancelled{
				do{
					if let event = try self.parseEvent(self.coreApi.waitEvent()){
						if event.type == privmx.endpoint.core.LibDisconnectedEvent.self
							|| event.type == privmx.endpoint.core.LibPlatformDisconnectedEvent.self{
							self.task?.cancel()
						}
						for cb in ((self.callbacks[event.channel.name]?[event.type.typeStr()] ?? [:]).values){
							event.event.handleWith(cb: cb)
						}
					}
				}catch{
					listenerErrorHandler(error)
				}
			}
			self.task = nil
		}
	}
}
