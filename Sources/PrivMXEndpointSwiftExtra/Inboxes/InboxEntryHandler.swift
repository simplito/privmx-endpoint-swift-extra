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

public class InboxEntryHandler:@unchecked Sendable{
	
	/// Recommended chunk size for file transfers, suggested by the endpoint library.
	public static let RecommendedChunkSize :Int64 = 131072
	
	private var inboxApi : any PrivMXInbox
	private var inboxHandle: privmx.InboxHandle
	private var fileHandlers: [InboxFileHandler]
	private var err: PrivMXEndpointError?
	
	public private(set) var state : InboxEntryHandlerState
	
	init(
		inboxApi:any PrivMXInbox,
		inboxHandle:privmx.InboxHandle,
		data:Data,
		fileHandlers: [InboxFileHandler]
	) throws {
		self.inboxApi = inboxApi
		self.inboxHandle = inboxHandle
		self.fileHandlers = fileHandlers
		self.state = .prepared
	}
	
	
	
	public static func prepareInboxEntryHandler(
		using inboxApi: any PrivMXInbox,
		in inboxId:String,
		containing data:Data,
		sending fileSources: [any FileDataSource],
		as userPrivateKey:String?
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
			handles.append(h.handle)
		}
		
		let inboxHandle = try inboxApi.prepareEntry(in: inboxId,
													containing: data,
													attaching: handles,
													as: userPrivateKey)
		
		for h in fileHandlers{
			h.setInboxHandle(inboxHandle)
		}
		
		return try InboxEntryHandler(inboxApi: inboxApi,
									 inboxHandle: inboxHandle,
									 data: data,
									 fileHandlers: fileHandlers)
		
		
	}
	
	public func startSending(
		
	) async throws -> InboxEntryHandlerState{
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
																			   description: "An Error occured",
																			   code: nil))
		}
		self.state = .filesSent
		return self.state
	}
	
	/// Aborts sending of the files, if they haven't been sent already
	public func cancel(
	) throws -> Void {
		switch self.state{
			case .sent,.error,.aborted:
				throw PrivMXEndpointError.otherFailure(privmx.InternalError(name: "Invalid State Error",
																			message: "Error",
																			description: std.string("Sending cannot be aborted in \"\(self.state)\" state.")
																			, code: nil))
			case .filesSent,.prepared:
				self.state = .aborted
		}
	}
	
	public func sendEntry(
	) throws {
		var error = privmx.InternalError(name: "Invalid State Error",
										 message: "Error",
										 description: std.string("Entry cannot be sent in \"\(self.state)\" state."),
										 code: nil)
		switch self.state{
			case .filesSent:
				try self.inboxApi.sendEntry(to: inboxHandle)
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
public enum InboxEntryHandlerState{
	/// Ready to start sending
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

