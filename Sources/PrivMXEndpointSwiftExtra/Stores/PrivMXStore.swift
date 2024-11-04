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

/// Protocol declaring methods of StoreApi using Swift types, enabling interaction with PrivMX Stores and Files.
public protocol PrivMXStore{
	

	/// Lists the Stores that the user has access to within a specified context.
	///
	/// This method retrieves a list of all Stores accessible to the user in the given context. 
	/// The list can be filtered and paginated using the provided query.
	///
	/// - Parameters:
	///   - contextId: The unique identifier of the context from which Stores should be listed.
	///   - query: A paging query object to filter and paginate the results.
	///
	/// - Returns: A `endpoint::core::PagingList<endpoint::store::Store>` (`privmx.StoreList`) instance containing the list of Stores.
	///
	/// - Throws: An error if the operation fails, such as when the context ID is invalid or network issues occur.
	func listStores(
		from contextId: String,
		basedOn query: privmx.endpoint.core.PagingQuery
	) throws -> privmx.StoreList
	
	/// Retrieves detailed information about a specific Store.
	///
	/// This method returns the details of a Store, such as its metadata and associated users, 
	/// identified by its unique store ID.
	///
	/// - Parameter storeId: The unique identifier of the Store to retrieve.
	///
	/// - Returns: A `privmx.endpoint.store.Store` instance containing the Store's metadata and details.
	///
	/// - Throws: An error if the Store cannot be found or if access is denied.
	func getStore(
		_ storeId: String
	) throws -> privmx.endpoint.store.Store
	
	/// Creates a new Store in the specified context, with defined users and managers.
	///
	/// This method creates a new Store within a specific context, associating users and managers with it.
	/// The Store will also have public and private metadata attached to it.
	///
	/// - Parameters:
	///   - contextId: The unique identifier of the context in which the Store will be created.
	///   - users: A list of `UserWithPubKey` objects representing users who will have access to the Store.
	///   - managers: A list of `UserWithPubKey` objects representing managers responsible for the Store.
	///   - publicMeta: The public metadata associated with the Store, which will not be encrypted.
	///   - privateMeta: The private metadata associated with the Store, which will be encrypted.
	///
	/// - Returns: A `String` representing the ID of the newly created Store.
	///
	/// - Throws: An error if the Store creation process fails.
	func createStore(
		in contextId: String,
		for users: [privmx.endpoint.core.UserWithPubKey],
		managedBy managers: [privmx.endpoint.core.UserWithPubKey],
		withPublicMeta publicMeta: Data,
		withPrivateMeta privateMeta: Data
	) throws -> String
	
	/// Deletes a specific Store identified by its unique ID.
	///
	/// This method removes the Store along with its associated data from the Bridge.
	///
	/// - Parameter storeId: The unique identifier of the Store to be deleted.
	///
	/// - Throws: An error if the Store cannot be deleted, such as if the store ID is invalid or the user lacks the necessary permissions.
	func deleteStore(
		_ storeId: String
	) throws -> Void
	
	/// Updates an existing Store by replacing its users, managers, and metadata.
	///
	/// This method updates an existing Store with new values, overriding the previous users, managers, 
	/// and metadata. The update can be forced, and a new key can be generated if required.
	///
	/// - Parameters:
	///   - storeId: The unique identifier of the Store to be updated.
	///   - version: The current version of the Store, used to ensure version consistency.
	///   - users: A new list of `UserWithPubKey` objects representing users who will have access to the Store.
	///   - managers: A new list of `UserWithPubKey` objects representing managers responsible for the Store.
	///   - publicMeta: The new public metadata for the Store, which will be unencrypted.
	///   - privateMeta: The new private metadata for the Store, which will be encrypted.
	///   - force: A boolean indicating whether the update should be forced, bypassing version control.
	///   - forceGenerateNewKey: A boolean indicating whether a new key should be generated for the Store.
	///
	/// - Throws: An error if the Store update process fails.
	func updateStore(
		_ storeId: String,
		atVersion version:Int64,
		replacingUsers users: [privmx.endpoint.core.UserWithPubKey],
		replacingManagers managers: [privmx.endpoint.core.UserWithPubKey],
		replacingPublicMeta publicMeta: Data,
		replacingPrivateMeta privateMeta: Data,
		force: Bool,
		forceGenerateNewKey: Bool
	) throws -> Void
	
	/// Retrieves information about a specific File in a Store.
	///
	/// This method returns details about a File, such as its metadata, associated with the given file ID.
	///
	/// - Parameter fileId: The unique identifier of the File to retrieve.
	///
	/// - Returns: A `privmx.endpoint.store.File` instance containing the File's metadata and details.
	///
	/// - Throws: An error if the File cannot be found or if access is denied.
	func getFile(
		_ fileId: String
	) throws -> privmx.endpoint.store.File
	
	/// Lists all Files in a specified Store.
	///
	/// This method retrieves a list of Files associated with a Store. It only provides metadata and information 
	/// about the files, not their contents. To download the files themselves, use `openFile()` and `readFromFile()`.
	///
	/// - Parameters:
	///   - storeId: The unique identifier of the Store from which to list Files.
	///   - query: A paging query object to filter and paginate the results.
	///
	/// - Returns: A `privmx.endpoint.core.FilesList` instance containing the list of Files.
	///
	/// - Throws: An error if the listing process fails.
	func listFiles(
		from storeId: String,
		basedOn query: privmx.endpoint.core.PagingQuery
	) throws -> privmx.FileList
	
	/// Creates a new file handle for writing data to a File in a Store.
	///
	/// This method creates a new file handle, which can be used to write data to a new File in the Store. 
	/// Once the file is created, data can be uploaded using `writeToFile()` and finalized with `closeFile()`.
	///
	/// - Parameters:
	///   - storeId: The unique identifier of the Store in which the File will be created.
	///   - publicMeta: Public metadata for the File, which will be unencrypted.
	///   - privateMeta: Private metadata for the File, which will be encrypted.
	///   - size: The size of the File in bytes.
	///
	/// - Returns: A `privmx.StoreFileHandle` used for writing data to the File.
	///
	/// - Throws: An error if the file handle creation fails.
	func createFile(
		in storeId: String,
		withPublicMeta publicMeta: Data,
		withPrivateMeta privateMeta: Data,
		ofSize size: Int64
	) throws -> privmx.StoreFileHandle
	
	/// Updates an existing File by overwriting its content and metadata.
	///
	/// This method creates a new file handle for updating an existing File, allowing the content 
	/// and metadata to be replaced. The file can then be written using `writeToFile()` and finalized with `closeFile()`.
	///
	/// - Parameters:
	///   - fileId: The unique identifier of the File to be updated.
	///   - publicMeta: New public metadata for the File, which will be unencrypted.
	///   - privateMeta: New private metadata for the File, which will be encrypted.
	///   - size: The new size of the File in bytes.
	///
	/// - Returns: A `privmx.StoreFileHandle` for writing data to the updated File.
	///
	/// - Throws: An error if the file handle creation or update fails.
	func updateFile(
		_ fileId: String,
		replacingPublicMeta publicMeta: Data,
		replacingPrivateMeta privateMeta: Data,
		replacingSize size: Int64
	) throws -> privmx.StoreFileHandle
	
	/// Opens a File for reading and returns a file handle (`StoreFileHandle`).
	///
	/// This method opens an existing File, identified by its file ID, and returns a handle that can be used
	/// to read the file's content.
	///
	/// - Parameter fileId: The unique identifier of the File to open.
	///
	/// - Returns: A `privmx.StoreFileHandle` for reading the File's content.
	///
	/// - Throws: An error if the file cannot be opened.
	func openFile(
	_ fileId: String
	) throws -> privmx.StoreFileHandle
	
	/// Reads a specified number of bytes from an open File.
	///
	/// This method reads a defined amount of data from a file that has been opened using a StoreFileHandle.
	///
	/// - Parameters:
	///   - handle: The StoreFileHandle of the opened File.
	///   - length: The number of bytes to read from the File.
	///
	/// - Returns: A `Data` object containing the bytes read from the File.
	///
	/// - Throws: An error if the read operation fails.
	func readFromFile(
		withHandle handle: privmx.StoreFileHandle,
		length: Int64
	) throws -> Data
	
	/// Writes a chunk of data to an open File.
	///
	/// This method uploads a chunk of data to a file that has been opened for writing using a file handle.
	///
	/// - Parameters:
	///   - handle: The handle of the opened File.
	///   - dataChunk: The data to write to the File.
	///
	/// - Throws: An error if the write operation fails.
	func writeToFile(
		withHandle handle: privmx.StoreFileHandle,
		uploading dataChunk: Data
	) throws -> Void
	
	/// Moves the read/write cursor within an open File.
	///
	/// This method repositions the read/write cursor in a file, allowing for random access operations
	/// such as reading or writing from a specific position.
	///
	/// - Parameters:
	///   - handle: The handle of the opened File.
	///   - position: The new position for the cursor, in bytes.
	///
	/// - Throws: An error if the seek operation fails.
	func seekInFile(
		withHandle handle: privmx.StoreFileHandle,
		toPosition position: Int64
	) throws -> Void
	
	/// Closes an open File and finalizes any pending operations.
	///
	/// This method closes a file that was opened using `openFile()` or created with `createFile()`. 
	/// It ensures that all pending write operations are completed and releases the file handle.
	///
	/// - Parameter handle: The handle of the opened File to close.
	///
	/// - Returns: A `String` representing the ID of the closed File.
	///
	/// - Throws: An error if the file cannot be closed.
	func closeFile(
		withHandle handle: privmx.StoreFileHandle
	) throws -> String
	
	/// Permanently deletes a File from the platform.
	///
	/// This method removes a file, identified by its file ID, and all its associated data from the platform.
	///
	/// - Parameter fileId: The unique identifier of the File to delete.
	///
	/// - Throws: An error if the file deletion fails.
	func deleteFile(
		_ fileId: String
	) throws -> Void
	
	/// Subscribes to events related to Stores.
	///
	/// This method allows the client to receive notifications about changes to Stores, such as updates 
	/// or new Stores being created, by subscribing to Store-related events.
	///
	/// - Throws: An error if the subscription fails.
	func subscribeForStoreEvents(
	) throws -> Void
	
	/// Subscribes to events related to Files in a specific Store.
	///
	/// This method subscribes to file-related events for a specific Store, enabling the client to receive 
	/// notifications about changes to Files, such as uploads or deletions.
	///
	/// - Parameter storeId: The unique identifier of the Store for which to subscribe to file events.
	///
	/// - Throws: An error if the subscription fails.
	func subscribeForFileEvents(
		in storeId:String
	) throws -> Void

	/// Unsubscribes from events related to Stores.
	///
	/// This method stops the client from receiving notifications about Store-related events.
	///
	/// - Throws: An error if the unsubscribing fails.
	func unsubscribeFromStoreEvents(
	) throws -> Void
	
	/// Unsubscribes from events related to Files in a specific Store.
	///
	/// This method stops the client from receiving notifications about file-related events in a specific Store.
	///
	/// - Parameter storeId: The unique identifier of the Store for which to unsubscribe from file events.
	///
	/// - Throws: An error if the unsubscribing fails.
	func unubscribeFromFileEvents(
		in storeId:String
	) throws -> Void
}

