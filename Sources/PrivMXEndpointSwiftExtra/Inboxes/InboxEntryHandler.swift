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

/// Class wrapping the process of creating and uploading an Inbox Entry.
public class InboxEntryHandler:@unchecked Sendable{
	
	/// Recommended chunk size for file transfers, suggested by the endpoint library.
	public static let RecommendedChunkSize :Int64 = 131072
	
	private var inboxApi : any PrivMXInbox
	private var entryHandle: privmx.EntryHandle
	private var fileHandlers: [InboxFileHandler]
	private var err: PrivMXEndpointError?
	
	/// The current state
	public private(set) var state : InboxEntryHandlerState
	
	internal init(
		inboxApi:any PrivMXInbox,
		entryHandle:privmx.EntryHandle,
		data:Data,
		fileHandlers: [InboxFileHandler]
	) throws {
		self.inboxApi = inboxApi
		self.entryHandle = entryHandle
		self.fileHandlers = fileHandlers
		if fileHandlers.isEmpty{
			self.state = .filesSent
		}else{
			self.state = .prepared
		}
	}
	

	/// Creates a new `InboxEntryHandler` for sending an entry to an Inbox.
	///
	/// If fileSources is an empty array, the created handler will be in `.filesSent`, otherwise it will be in `.prepared`.
	///
	/// - Parameters:
	///   - inboxApi: provider of `PrivMXInbox` API
	///   - inboxId: Id of the Inbox in which the Entry is supposed to appear
	///   - data: arbitrary data that will appear as a mesasage in the Inbox
	///   - fileSources: list of sources of data for Files attached to the Entry
	///   - userPrivateKey: Optional identity of the Sender.
	///
	/// - Returns: an instance of `InboxEntryHandler`
	public static func prepareInboxEntryHandler(
		using inboxApi: any PrivMXInbox,
		in inboxId:String,
		containing data:Data,
		sending fileSources: [any FileDataSource],
		derivingPublicKeyFrom userPrivateKey:String?
	) throws -> InboxEntryHandler {
		var fileHandlers = [InboxFileHandler]()
		for s in fileSources{
			try fileHandlers.append(InboxFileHandler(inboxApi: inboxApi,
													 dataSource: s,
													 mode: .write,
													 chunkSize: Self.RecommendedChunkSize))
		}
		
		var handles = [privmx.InboxFileHandle]()
		
		for h in fileHandlers{
			handles.append(h.fileHandle)
		}
		
		let entryHandle = try inboxApi.prepareEntry(in: inboxId,
													containing: data,
													attaching: handles,
													publicKeyDerivedFrom: userPrivateKey)
		
		for h in fileHandlers{
			h.setEntryHandle(entryHandle)
		}
		
		return try InboxEntryHandler(inboxApi: inboxApi,
									 entryHandle: entryHandle,
									 data: data,
									 fileHandlers: fileHandlers)
		
		
	}
	
	/// Uploads the files associated with the Entry.
	///
	/// - Returns: the state of the Handler
	public func sendFiles(
	) throws -> InboxEntryHandlerState{
		DispatchQueue.concurrentPerform(iterations: fileHandlers.count){
			hId in
			let handler = self.fileHandlers[hId]
			while handler.hasDataLeft && self.state == .prepared{
				do {
					try handler.writeChunk()
				} catch {
					self.state = .error
					self.err = error as? PrivMXEndpointError
					break
				}
			}
		}
		guard self.state == .prepared
		else {
			throw err ?? PrivMXEndpointError.otherFailure(privmx.InternalError(name: "Invalid State Error",
																			   message: "Error",
																			   description: "An Error occured"))
		}
		self.state = .filesSent
		return self.state
	}
	
	/// Aborts sending of the files, if they haven't been sent already
	public func cancel(
	) throws -> Void {
		switch self.state{
			case .sent,.error,.aborted,.filesSent:
				throw PrivMXEndpointError.otherFailure(privmx.InternalError(name: "Invalid State Error",
																			message: "Error",
																			description: "Sending cannot be aborted in \"\(self.state)\" state."))
			case .prepared:
				self.state = .aborted
				try inboxApi.sendEntry(entryHandle)
		}
	}
	
	/// Sends the entry, completing the process and adding it to the Inbox.
	public func sendEntry(
	) throws {
		var error = privmx.InternalError(name: "Invalid State Error",
										 message: "Error",
										 description: "Entry cannot be sent in \"\(self.state)\" state.")
		switch self.state{
			case .filesSent:
				try self.inboxApi.sendEntry(entryHandle)
			case .sent:
				error.message = "Entry already sent!"
				throw PrivMXEndpointError.otherFailure(error)
			case .prepared:
				error.message = "Files not yet uploaded!"
				throw PrivMXEndpointError.otherFailure(error)
			case .aborted:
				error.message = "Entry was aborted"
				throw PrivMXEndpointError.otherFailure(error)
			case .error:
				throw err ?? PrivMXEndpointError.otherFailure(error)
		}
	}
	
}

///State of the `InboxEntryHandler`
public enum InboxEntryHandlerState:Sendable{
	/// Ready to start uploading files
	case prepared
	/// All Files have been uploaded and the Entry can be sent
	case filesSent
	/// Entry has been sent succesfully
	case sent
	/// Cancelled by user
	case aborted
	/// An error occured
	case error
}

