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
/// Protocol declaring methods of StoreApi, with Swift Types
public protocol PrivMXStore{
	
	/// Lists Stores the user has access to in provided Context.
	///
	/// - Parameter contextId: from which Context should the Stores be listed
	/// - Parameter query: parameters of the query
	///
	/// - Returns:`privmx.endpoint.store.StoresList`instance.
	///
	/// - Throws: When the operation fails
	func listStores(
		from contextId: String,
		query: privmx.endpoint.core.ListQuery
	) throws -> privmx.endpoint.store.StoresList
	
	/// Retrieves information about a Store.
	///
	/// - Parameter storeId : information about which Store is to be retrieved.
	///
	/// - Returns: Information about a Store
	///
	/// - Throws: When the operation fails
	func getStore(
		_ storeId: String
	) throws -> privmx.endpoint.store.StoreInfo
	
	/// Creates a new Store in the specified Context.
	///
	/// Note that managers do not gain acess to the Store without being added as users.
	///
	/// - Parameter contextId: in which Context should the Store be created
	/// - Parameter users: who can access the Store
	/// - Parameter managers: who can manage the Store
	/// - Parameter name: the name of the Store
	///
	/// - Returns:Id of the newly created Store
	///
	/// - Throws: When the operation fails
	func createStore(
		in contextId: String,
		with users: [privmx.endpoint.core.UserWithPubKey],
		managedBy managers: [privmx.endpoint.core.UserWithPubKey],
		named title: String
	) throws -> String
	
	/// Deletes a Store.
	///
	/// - Parameter storeId: which Store is to be deleted
	///
	/// - Throws: When the operation fails
	func deleteStore(
		_ storeId: String
	) throws -> Void
	
	/// Updates an existing Store.
	///
	/// The provided values override preexisting values.
	///
	/// - Parameter contextId: which Store is to be updated
	/// - Parameter users: who can access the Store
	/// - Parameter managers: who can manage the Store
	/// - Parameter name: the title of the Store
	/// - Parameter version: current version of the Store
	/// - Parameter force: force the update by disregarding the version check
	/// - Parameter generateNewKeyId: force regeneration of new keyId for Store
	/// - Parameter accessToOldDataForNewUsers: placeholder parameter (does nothing for now)
	///
	/// - Throws: When the operation fails
	func updateStore(
		_ storeId: String,
		users: [privmx.endpoint.core.UserWithPubKey],
		managers: [privmx.endpoint.core.UserWithPubKey],
		name: String,
		version:Int64,
		force: Bool,
		generateNewKeyId: Bool,
		accessToOldDataForNewUsers: Bool
	) throws -> Void
	
	/// Retrieves information about a File.
	///
	/// - Parameter fileId : information about which File is to be retrieved.
	///
	/// - Returns: Information about a File
	///
	/// - Throws: When the operation fails
	func getFile(
		_ fileId: String
	) throws -> privmx.endpoint.core.FileInfo
	
	/// Lists  information about  Files in a Store
	///
	/// This does not download the files themselves, for that see `fileOpen()` and `fileRead()`
	///
	/// - Parameter storeId: from which Store should the Files be listed
	/// - Parameter query: parameters of the query
	///
	/// - Returns:`privmx.endpoint.core.FilesList`instance.
	///
	/// - Throws: When the operation fails
	func listFiles(
		from storeId: String,
		query: privmx.endpoint.core.ListQuery
	) throws -> privmx.endpoint.core.FilesList
	
	/// Creates a new file handle for writing in a Store
	///
	/// This creates a temporary file, use `fileWrite()` to upload data and `fileClose()` to finish the process.
	///
	/// - Parameter storeId:in which Store should the File be created
	/// - Parameter size:the size of the file
	/// - Parameter mimetype:type of the file
	/// - Parameter name:the name of the file
	///
	/// - Returns: `privmx.PMXFileHandle` for writing,
	///
	/// - Throws: When the operation fails
	func createFile(
		in storeId: String,
		size: Int64,
		mimetype: String,
		name: String
	) throws -> privmx.PMXFileHandle
	
	/// Creates a new file handle for overwiting a file.
	///
	/// - Parameter fileId: Which File should be updated
	/// - Parameter size:the size of the file
	/// - Parameter mimetype:type of the file
	/// - Parameter name:the name of the file
	///
	/// - Returns: `privmx.PMXFileHandle` for writing,
	///
	/// - Throws: When the operation fails
	func updateFile(
		_ fileId: String,
		size: Int64,
		mimetype: String,
		name: String
	) throws -> privmx.PMXFileHandle
	
	/// Creates a new file handle for reading a File.
	///
	/// - Parameter fileId: which File should be opened
	///
	/// - Returns: `privmx.PMXFileHandle` for reading
	///
	/// - Throws: When the operation fails
	func openFile(
		_ fileId: String
	) throws -> privmx.PMXFileHandle
	
	/// Reads from an opened file.
	///
	/// - Parameter handle: the handle to an opened File
	/// - Parameter length: amount of bytes to be read
	///
	/// - Returns: `privmx.PMXFileHandle` for reading
	///
	/// - Throws: When the operation fails
	func readFile(
		handle: privmx.PMXFileHandle,
		length: Int64
	) throws -> Data
	
	/// - Throws: When the operation fails
	func writeFile(
		handle: privmx.PMXFileHandle,
		dataChunk: Data
	) throws -> Void
	
	/// Moves read cursor in an open File.
	///
	/// - Parameter handle: the handle to an opened file
	/// - Parameter pos: new position of the cursor
	///
	/// - Throws: When the operation fails
	func seekInFile(
		handle: privmx.PMXFileHandle,
		pos: Int64
	) throws -> Void
	
	/// Closes an open File
	///
	/// - Parameter handle: the handle to an open file
	///
	/// - Returns: The Id of the File
	///
	/// - Throws: When the operation fails
	func closeFile(
		handle: privmx.PMXFileHandle
	) throws -> String
	
	/// - Throws: When the operation fails
	func deleteFile(
		_ fileId: String
	) throws -> Bool
}

