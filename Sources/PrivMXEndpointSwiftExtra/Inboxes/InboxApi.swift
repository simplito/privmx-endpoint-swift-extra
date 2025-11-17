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

/// Extension of `InboxApi`, providing more "Swifty" methods, that take and return Swift types instead of C++ types when an equivalent exists.
extension InboxApi: PrivMXInbox, @retroactive @unchecked Sendable{
	
	public func createInbox(
		in contextId: String,
		for users: [privmx.endpoint.core.UserWithPubKey],
		managedBy managers: [privmx.endpoint.core.UserWithPubKey],
		withPublicMeta publicMeta: Data,
		withPrivateMeta privateMeta: Data,
		withFilesConfig filesConfig: privmx.endpoint.inbox.FilesConfig?,
		withPolicies policies: privmx.endpoint.core.ContainerPolicyWithoutItem? = nil
	) throws -> String {
		String(try self.createInbox(contextId: std.string(contextId),
									users: privmx.UserWithPubKeyVector(users),
									managers: privmx.UserWithPubKeyVector(managers),
									publicMeta: publicMeta.asBuffer(),
									privateMeta: privateMeta.asBuffer(),
									filesConfig: filesConfig,
									policies: policies))
	}
	
	public func updateInbox(
		_ inboxId: String,
		replacingUsers users: [privmx.endpoint.core.UserWithPubKey],
		replacingManagers managers: [privmx.endpoint.core.UserWithPubKey],
		replacingPublicMeta publicMeta: Data,
		replacingPrivateMeta privateMeta: Data,
		replacingFilesConfig filesConfig: privmx.endpoint.inbox.FilesConfig?,
		atVersion version: Int64,
		force: Bool,
		forceGenerateNewKey: Bool,
		replacingPolicies policies: privmx.endpoint.core.ContainerPolicyWithoutItem? = nil
	) throws -> Void {
		try self.updateInbox(inboxId: std.string(inboxId),
							 users: privmx.UserWithPubKeyVector(users),
							 managers: privmx.UserWithPubKeyVector(managers),
							 publicMeta: publicMeta.asBuffer(),
							 privateMeta: privateMeta.asBuffer(),
							 filesConfig: filesConfig,
							 version: version,
							 force: force,
							 forceGenerateNewKey: forceGenerateNewKey,
							 policies: policies)
	}
	
	public func getInbox(
		_ inboxId: String
	) throws -> privmx.endpoint.inbox.Inbox {
		try self.getInbox(inboxId: std.string(inboxId))
	}
	
	public func listInboxes(
		from contextId: String,
		basedOn pagingQuery: privmx.endpoint.core.PagingQuery
	) throws -> privmx.InboxList {
		try self.listInboxes(contextId: std.string(contextId),
							 pagingQuery: pagingQuery)
	}
	
	public func getInboxPublicView(
		for inboxId: String
	) throws -> privmx.endpoint.inbox.InboxPublicView {
		try self.getInboxPublicView(inboxId: std.string(inboxId))
	}
	
	
	public func deleteInbox(
		_ inboxId: String
	) throws -> Void {
		try self.deleteInbox(inboxId:std.string(inboxId))
	}
	
	public func prepareEntry(in inboxId: String,
							 containing data: Data,
							 attaching inboxFilesHandles: [privmx.InboxFileHandle],
							 publicKeyDerivedFrom userPrivateKey: String?
	) throws -> privmx.EntryHandle {
		try self.prepareEntry(inboxId: std.string(inboxId),
							  data: data.asBuffer(),
							  inboxFileHandles: privmx.InboxFileHandleVector(inboxFilesHandles),
							  userPrivKey: userPrivateKey != nil ? std.string(userPrivateKey) : nil)
	}
	
	
	@available(*, deprecated, renamed: "prepareEntry(in:containing:attaching:publicKeyDerivedFrom:)")
	public func prepareEntry(in inboxId: String,
							 containing data: Data,
							 attaching inboxFilesHandles: [privmx.InboxFileHandle],
							 as userPrivateKey: String?
	) throws -> privmx.InboxHandle {
		try self.prepareEntry(inboxId: std.string(inboxId),
							  data: data.asBuffer(),
							  inboxFileHandles: privmx.InboxFileHandleVector(inboxFilesHandles),
							  userPrivKey: userPrivateKey != nil ? std.string(userPrivateKey) : nil)
	}
	
	public func sendEntry(
		_ entryHandle:privmx.EntryHandle
	) throws -> Void {
		try self.sendEntry(entryHandle: entryHandle)
	}
	
	@available(*, deprecated, renamed: "sendEntry(_:)")
	public func sendEntry(
		to inboxHandle:privmx.InboxHandle
	) throws -> Void {
		try self.sendEntry(inboxHandle: inboxHandle)
	}
	
	public func createFileHandle(
		withPublicMeta publicMeta: Data,
		withPrivateMeta privateMeta: Data,
		forSize fileSize: Int64
	) throws -> privmx.InboxFileHandle {
		try self.createFileHandle(publicMeta: publicMeta.asBuffer(),
								  privateMeta: privateMeta.asBuffer(),
								  fileSize: fileSize)
	}
	
	public func writeToFile(
		_ inboxFileHandle: privmx.InboxFileHandle,
		of entryHandle: privmx.EntryHandle,
		uploading dataChunk: Data
	) throws -> Void {
		try self.writeToFile(entryHandle: entryHandle,
							 inboxFileHandle: inboxFileHandle,
							 dataChunk: dataChunk.asBuffer())
	}
	
	@available(*, deprecated, renamed: "writeToFile(_:of:uploading:)")
	public func writeToFile(
		_ inboxFileHandle: privmx.InboxFileHandle,
		in inboxHandle: privmx.InboxHandle,
		uploading dataChunk: Data
	) throws -> Void {
		try self.writeToFile(inboxHandle: inboxHandle,
							 inboxFileHandle: inboxFileHandle,
							 dataChunk: dataChunk.asBuffer())
	}
	
	public func readEntry(
		_ inboxEntryId: String
	) throws -> privmx.endpoint.inbox.InboxEntry {
		try self.readEntry(inboxEntryId: std.string(inboxEntryId))
	}
	
	public func listEntries(
		from inboxId: String,
		basedOn pagingQuery: privmx.endpoint.core.PagingQuery
	) throws -> privmx.InboxEntryList {
		try self.listEntries(inboxId: std.string(inboxId),
							 pagingQuery: pagingQuery)
	}
	
	public func deleteEntry(
		_ inboxEntryId: String
	) throws -> Void {
		try self.deleteEntry(inboxEntryId: std.string(inboxEntryId))
	}
	
	public func openFile(
		_ fileId: String
	) throws -> privmx.InboxFileHandle {
		try self.openFile(fileId: std.string(fileId))
	}
	
	public func seekInFile(
		withHandle fileHandle:privmx.InboxFileHandle,
		toPosition position:Int64
	) throws -> Void {
		try self.seekInFile(fileHandle: fileHandle,
							position: position)
	}
	
	
	public func readFromFile(
		withHandle fileHandle: privmx.InboxFileHandle,
		length: Int64
	) throws -> Data {
		try Data(from: self.readFromFile(fileHandle: fileHandle,
										 length: length))
	}
	
	public func closeFile(
		withHandle fileHandle: privmx.InboxFileHandle
	) throws -> String {
		try String(self.closeFile(fileHandle: fileHandle))
	}
	
	public func subscribeFor(
		_ queries: [String]
	) throws -> [String] {
		var sqv = privmx.SubscriptionQueryVector()
		sqv.reserve(queries.count)
		for q in queries{
			sqv.push_back(std.string(q))
		}
		return try self.subscribeFor(subscriptionQueries:sqv).map({x in String(x)})
	}
	
	public func unsubscribeFrom(
		_ subscriptionIds: [String]
	) throws -> Void {
		var sid = privmx.SubscriptionIdVector()
		sid.reserve(subscriptionIds.count)
		for i in subscriptionIds{
			sid.push_back(std.string(i))
		}
		try self.unsubscribeFrom(subscriptionIds: sid)
	}
	
	/// Generate subscription Query for the Custom events.
	///
	/// - Parameter eventType: type of event which you listen for
	/// - Parameter selectorType: scope on which you listen for events
	/// - Parameter selectorId: ID of the selector
	///
	/// - Throws: When building the subscription Query fails.
	///
	/// - Returns: a properly formatted event subscription request.
	public func buildSubscriptionQuery(
		forEventType eventType: privmx.endpoint.inbox.EventType,
		selectorType: privmx.endpoint.inbox.EventSelectorType,
		selectorId: String
	) throws -> String {
		try String(self.buildSubscriptionQuery(eventType: eventType,
											   selectorType: selectorType,
											   selectorId: std.string(selectorId)))
	}
}
