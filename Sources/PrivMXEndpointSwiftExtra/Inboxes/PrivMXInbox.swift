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

public protocol PrivMXInbox{
	
	/// Creates an inbox in a specified context for a group of users, managed by a set of managers.
	///
	/// This method creates an inbox associated with a given context ID, assigning users and managers
	/// to it, while attaching metadata and configuration for files if needed.
	///
	/// - Parameters:
	///   - contextId: The unique identifier for the context in which the inbox is being created.
	///   - users: An array of `UserWithPubKey` objects representing the users who will have access to the inbox.
	///   - managaers: An array of `UserWithPubKey` objects representing the managers responsible for managing the inbox.
	///   - publicMeta: Public metadata to be associated with the inbox, provided as `Data`.
	///   - privateMeta: Private metadata to be associated with the inbox, provided as `Data`.
	///   - filesConfig: Optional configuration for managing files in the inbox, provided as `FilesConfig`.
	///
	/// - Throws: Throws an error if the inbox creation process fails.
	///
	/// - Returns: A `String` representing the ID of the newly created inbox.
	func createInbox(
		in contextId: String,
		for users: [privmx.endpoint.core.UserWithPubKey],
		managedBy managaers: [privmx.endpoint.core.UserWithPubKey],
		withPublicMeta publicMeta: Data,
		withPrivateMeta privateMeta: Data,
		withFilesConfig filesConfig: privmx.endpoint.inbox.FilesConfig?
	) throws -> String
	
	/// Updates an existing inbox by replacing its users, managers, metadata, and configuration with new values.
	///
	/// This method updates the specified inbox, replacing its current users, managers, and metadata
	/// (both public and private) with the new ones provided. It also allows updating the files configuration,
	/// optionally forcing the update and generating a new key if necessary.
	///
	/// - Parameters:
	///   - inboxId: The unique identifier of the inbox to be updated, provided as a `String`.
	///   - users: An array of `UserWithPubKey` representing the new users for the inbox.
	///   - managers: An array of `UserWithPubKey` representing the new managers for the inbox.
	///   - publicMeta: The new public metadata associated with the inbox, passed as `Data`.
	///   - privateMeta: The new private metadata associated with the inbox, passed as `Data`.
	///   - filesConfig: Optional new configuration for managing files in the inbox, provided as `FilesConfig`.
	///   - version: The current version of the inbox, provided as an `Int64`. This is used for version control to ensure updates are applied correctly.
	///   - force: A `Bool` indicating whether the update should be forced, even if there are version conflicts.
	///   - forceGenerateNewKey: A `Bool` indicating whether a new key should be generated for the inbox during the update.
	///
	/// - Throws: Throws an error if the update fails or if any of the data conversion processes fail.
	///
	/// - Returns: This method returns `Void` and does not provide any result on success.
	func updateInbox(
		_ inboxId: String,
		replacingUsers users: [privmx.endpoint.core.UserWithPubKey],
		replacingManagers managers: [privmx.endpoint.core.UserWithPubKey],
		replacingPublicMeta publicMeta: Data,
		replacingPrivateMeta privateMeta: Data,
		replacingFilesConfig filesConfig: privmx.endpoint.inbox.FilesConfig?,
		atVersion version: Int64,
		force: Bool,
		forceGenerateNewKey: Bool
	) throws -> Void
	
	/// Retrieves the inbox associated with the given inbox ID.
	///
	/// This method fetches an inbox based on its unique identifier, returning detailed information
	/// about the inbox, such as its users, managers, and metadata.
	///
	/// - Parameter inboxId: The unique identifier of the inbox to retrieve, provided as a `String`.
	///
	/// - Throws: Throws an error if the inbox could not be retrieved, such as if the inbox ID is invalid or the request fails.
	///
	/// - Returns: An `Inbox` object representing the detailed state of the requested inbox.
	func getInbox(
		_ inboxId: String
	) throws -> privmx.endpoint.inbox.Inbox
	
	/// Lists all inboxes in the specified context, based on the given paging query.
	///
	/// This method retrieves a list of inboxes associated with a specific context, with the results
	/// potentially being paginated according to the provided `PagingQuery`.
	///
	/// - Parameters:
	///   - contextId: The unique identifier of the context from which inboxes will be listed.
	///   - pagingQuery: The query object that defines the pagination settings, such as limit, offset (skip) and sortOrder.
	///
	/// - Throws: Throws an error if the inbox listing process fails.
	///
	/// - Returns: An `InboxList` object that contains the list of inboxes and associated pagination details.
	func listInboxes(
		from contextId: String,
		basedOn pagingQuery: privmx.endpoint.core.PagingQuery
	) throws -> privmx.InboxList
	
	/// Retrieves the public view of the specified inbox.
	///
	/// This method fetches the public view of an inbox, which  includes public metadata
	/// that can be accessed without privileged access.
	///
	/// - Parameter inboxId: The unique identifier of the inbox to retrieve the public view for, provided as a `String`.
	///
	/// - Throws: Throws an error if the public view could not be retrieved, such as if the inbox ID is invalid or the request fails.
	///
	/// - Returns: An `InboxPublicView` object containing the public metadata and details of the requested inbox.
	func getInboxPublicView(
		for inboxId:String
	) throws -> privmx.endpoint.inbox.InboxPublicView
	
	/// Deletes the inbox with the specified ID.
	///
	/// This method removes the inbox identified by the given inbox ID, effectively deleting all associated data.
	///
	/// - Parameter inboxId: The unique identifier of the inbox to delete, provided as a `String`.
	///
	/// - Throws: Throws an error if the deletion process fails, such as if the inbox ID is invalid or the request cannot be completed.
	///
	/// - Returns: This method returns `Void` and does not provide any result on success.
	func deleteInbox(
		_ inboxId: String
	) throws -> Void
	
	/// Prepares an entry to be sent to the specified inbox, optionally attaching file handles.
	///
	/// This method prepares a new entry to be sent to the inbox identified by `inboxId`. The entry can
	/// contain metadata and optional files, represented by `InboxFileHandle` objects. A private key may be
	/// provided for encryption purposes.
	///
	/// - Parameters:
	///   - inboxId: The unique identifier of the inbox to which the entry will be sent, provided as a `String`.
	///   - data: The main content of the entry, provided as `Data`.
	///   - inboxFilesHandles: An array of `InboxFileHandle` objects representing any files that should be attached to the entry.
	///   - userPrivateKey: An optional private key for encryption, provided as a `String`. Otherwise random key is used.
	///
	/// - Throws: Throws an error if the entry preparation fails.
	///
	/// - Returns: An `InboxHandle` object representing the prepared entry that can be sent.
	func prepareEntry(
		in inboxId: String,
		containing data: Data,
		attaching inboxFilesHandles: [privmx.InboxFileHandle],
		as userPrivateKey: String?
	) throws -> privmx.InboxHandle
	
	/// Sends a previously prepared entry to its corresponding inbox.
	///
	/// This method sends an entry that has been prepared using `prepareEntry`. The `InboxHandle` must be passed,
	/// which represents the entry that was previously prepared for submission.
	///
	/// - Parameter inboxHandle: The handle of the prepared entry to be sent, provided as an `InboxHandle`.
	///
	/// - Throws: Throws an error if the entry cannot be sent, such as if the handle is invalid or the network request fails.
	///
	/// - Returns: This method returns `Void` and does not provide any result on success.
	func sendEntry(
		to inboxHandle: privmx.InboxHandle
	) throws -> Void
	
	/// Reads the content of a specific inbox entry identified by its entry ID.
	///
	/// This method retrieves the content and metadata of an inbox entry based on its unique identifier.
	/// Read access to the Inbox is required to successfully read its content.
	///
	/// - Parameter inboxEntryId: The unique identifier of the inbox entry to read, provided as a `String`.
	///
	/// - Throws: Throws an error if the entry cannot be read, such as if the entry ID is invalid or access is restricted.
	///
	/// - Returns: An `InboxEntry` object representing the full content and metadata of the specified entry.
	func readEntry(
		_ inboxEntryId: String
	) throws -> privmx.endpoint.inbox.InboxEntry
	
	/// Lists all entries in the specified inbox, based on the provided paging query.
	///
	/// This method retrieves a list of inbox entries associated with a specific inbox ID, with the results
	/// potentially being paginated according to the provided `PagingQuery`.
	///
	/// - Parameters:
	///   - inboxId: The unique identifier of the inbox from which entries will be listed, provided as a `String`.
	///   - pagingQuery: The query object that defines the pagination settings, such as limit and offset.
	///
	/// - Throws: Throws an error if the listing process fails, such as if the inbox ID is invalid or access is restricted.
	///
	/// - Returns: An `InboxEntryList` object containing the list of entries and associated pagination details.
	func listEntries(
		from inboxId: String,
		basedOn pagingQuery: privmx.endpoint.core.PagingQuery
	) throws -> privmx.InboxEntryList
	
	/// Deletes a specific inbox entry identified by its entry ID.
	///
	/// This method removes the inbox entry identified by the provided entry ID, deleting its content and metadata.
	/// Full access to the inbox is required to successfully perform the deletion.
	///
	/// - Parameter inboxEntryId: The unique identifier of the inbox entry to delete, provided as a `String`.
	///
	/// - Throws: Throws an error if the deletion process fails, such as if the entry ID is invalid or access is restricted.
	///
	/// - Returns: This method returns `Void` and does not provide any result on success.
	func deleteEntry(
		_ inboxEntryId: String
	) throws -> Void
	
	/// Creates a file handle for attaching files to an inbox entry.
	///
	/// This method prepares a file handle, including public and private metadata, as well as the file size.
	/// The file handle is used when attaching files to an inbox entry before sending.
	///
	/// - Parameters:
	///   - publicMeta: Public metadata for the file, provided as `Data`.
	///   - privateMeta: Private metadata for the file, provided as `Data`.
	///   - fileSize: The size of the file in bytes, provided as an `Int64`.
	///
	/// - Throws: Throws an error if the file handle creation fails.
	///
	/// - Returns: An `InboxFileHandle` object representing the prepared file that can be attached to an inbox entry.
	func createFileHandle(
		withPublicMeta publicMeta: Data,
		withPrivateMeta privateMeta: Data,
		forSize fileSize: Int64
	) throws -> privmx.InboxFileHandle
	
	/// Writes a chunk of data to a file associated with a prepared inbox entry.
	///
	/// This method uploads a chunk of data to a file that is part of a prepared inbox entry.
	/// The `InboxFileHandle` represents the file, and the `InboxHandle` represents the entry being prepared.
	///
	/// - Parameters:
	///   - inboxFileHandle: The handle of the file to which data will be written, provided as an `InboxFileHandle`.
	///   - inboxHandle: The handle of the inbox entry that the file is associated with, provided as an `InboxHandle`.
	///   - dataChunk: The chunk of data to be uploaded, provided as `Data`.
	///
	/// - Throws: Throws an error if the file write operation fails.
	///
	/// - Returns: This method returns `Void` and does not provide any result on success.
	func writeToFile(
		_ inboxFileHandle: privmx.InboxFileHandle,
		in inboxHandle: privmx.InboxHandle,
		uploading dataChunk: Data
	) throws -> Void
	
	/// Opens a file associated with the given file ID and returns a file handle.
	///
	/// This method opens a file based on its unique file ID and returns a handle that can be used to read from
	/// or write to the file. The file must be closed using `closeFile` after operations are completed.
	///
	/// - Parameter fileId: The unique identifier of the file to open, provided as a `String`.
	///
	/// - Throws: Throws an error if the file cannot be opened, such as if the file ID is invalid or access is restricted.
	///
	/// - Returns: An `InboxFileHandle` object representing the opened file, which can be used for further operations.
	func openFile(
		_ fileId: String
	) throws -> privmx.InboxFileHandle
	
	/// Reads a specified number of bytes from an open file.
	///
	/// This method reads up to `length` bytes from a file, starting from the current file pointer position,
	/// and returns the data as a `Data` object.
	///
	/// - Parameters:
	///   - fileHandle: The handle of the file to read from, provided as an `InboxFileHandle`.
	///   - length: The number of bytes to read from the file, provided as an `Int64`.
	///
	/// - Throws: Throws an error if the read operation fails, such as if the file handle is invalid or the read exceeds file bounds.
	///
	/// - Returns: A `Data` object containing the bytes read from the file.
	func readFromFile(
		withHandle fileHandle: privmx.InboxFileHandle,
		length: Int64
	) throws -> Data
	
	/// Moves the file pointer to a specified position within a file.
	///
	/// This method adjusts the file pointer to the given position in a file associated with the provided file handle.
	/// It is useful for reading from or writing to a specific part of a file.
	///
	/// - Parameters:
	///   - fileHandle: The handle of the file to seek in, provided as an `InboxFileHandle`.
	///   - position: The position (in bytes) to move the file pointer to, provided as an `Int64`.
	///
	/// - Throws: Throws an error if seeking within the file fails, such as if the file handle is invalid or the position is out of bounds.
	///
	/// - Returns: This method returns `Void` and does not provide any result on success.
	func seekInFile(
		withHandle fileHandle: privmx.InboxFileHandle,
		toPosition position: Int64
	) throws -> Void
	
	/// Closes an open file associated with the given file handle.
	///
	/// This method closes a file that was opened using `openFile`. It ensures that all pending changes
	/// are written and that the file handle is released.
	///
	/// - Parameter fileHandle: The handle of the file to close, provided as an `InboxFileHandle`.
	///
	/// - Throws: Throws an error if the file cannot be closed, such as if the file handle is invalid or already closed.
	///
	/// - Returns: A `String` representing the result or status after closing the file.
	func closeFile(
		withHandle fileHandle: privmx.InboxFileHandle
	) throws -> String
	
	/// Subscribes to receive general inbox events.
	///
	/// This method subscribes to receive notifications or events related to all inboxes.
	///
	/// - Throws: Throws an error if the subscription process fails.
	///
	/// - Returns: This method returns `Void` and does not provide any result on success.
	func subscribeForInboxEvents(
	) throws -> Void
	
	/// Unsubscribes from receiving general inbox events.
	///
	/// This method unsubscribes the client from receiving notifications or events related to inboxes.
	///
	/// - Throws: Throws an error if the unsubscribing process fails.
	///
	/// - Returns: This method returns `Void` and does not provide any result on success.
	func unsubscribeFromInboxEvents(
	) throws -> Void
	
	/// Subscribes to receive entry events for a specific inbox.
	///
	/// This method subscribes to receive notifications or events related to entries within the specified inbox.
	/// Once subscribed, the client will be notified of any changes or updates to the entries in the inbox.
	///
	/// - Parameter inboxId: The unique identifier of the inbox to subscribe to for entry events, provided as a `String`.
	///
	/// - Throws: Throws an error if the subscription process fails, such as if the inbox ID is invalid or the subscription cannot be established.
	///
	/// - Returns: This method returns `Void` and does not provide any result on success.
	func subscribeForEntryEvents(
		in inboxId: String
	) throws -> Void
	
	/// Unsubscribes from receiving entry events for a specific inbox.
	///
	/// This method unsubscribes the client from receiving notifications or events related to entries within the specified inbox.
	/// It stops further event notifications for that inbox.
	///
	/// - Parameter inboxId: The unique identifier of the inbox to unsubscribe from entry events, provided as a `String`.
	///
	/// - Throws: Throws an error if the unsubscribing process fails, such as if the inbox ID is invalid or the unsubscribing cannot be completed.
	///
	/// - Returns: This method returns `Void` and does not provide any result on success.
	func unsubscribeFromEntryEvents(
		in inboxId: String
	) throws -> Void
	
}
