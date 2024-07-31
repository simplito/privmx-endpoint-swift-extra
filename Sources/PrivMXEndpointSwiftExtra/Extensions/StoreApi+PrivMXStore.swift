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

extension StoreApi : PrivMXStore{
	
	/// Lists Stores the user has access to in provided Context.
	///
	/// - Parameter contextId: from which Context should the Stores be listed
	/// - Parameter query: parameters of the query
	///
	/// - Returns:`privmx.endpoint.store.StoresList`instance.
	///
	/// - Throws: `PrivMXEndpointError.failedListingStores` if an exception was thrown in C++ code, or another error occurred.
	public func listStores(
		from contextId: String,
		query: privmx.endpoint.core.ListQuery
	) throws -> privmx.endpoint.store.StoresList {
		try listStores(from: std.string(contextId),
					   query:query)
	}
	
	/// Retrieves information about a Store.
	///
	/// - Parameter storeId : information about which Store is to be retrieved.
	///
	/// - Returns: Information about a Store
	///
	/// - Throws: `PrivMXEndpointError.failedGettingStore` if an exception was thrown in C++ code, or another error occurred.
	public func getStore(
		_ storeId: String
	) throws -> privmx.endpoint.store.StoreInfo {
		try getStore(std.string(storeId))
	}
	
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
	/// - Throws: `PrivMXEndpointError.failedCreatingStore` if an exception was thrown in C++ code, or another error occurred.
	public func createStore(
		in contextId: String,
		with users: [privmx.endpoint.core.UserWithPubKey],
		managedBy managers: [privmx.endpoint.core.UserWithPubKey],
		named title: String
	) throws -> String {
		
		var v = privmx.UserWithPubKeyVector()
		for u in users{
			v.push_back(u)
		}
		
		var m = privmx.UserWithPubKeyVector()
		for u in managers{
			m.push_back(u)
		}
		
		return try String(createStore(in: std.string(contextId),
									  with: v,
									  managedBy: m,
									  named: std.string(title)))
	}
	
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
	/// - Throws: `PrivMXEndpointError.failedUpdatingStore` if an exception was thrown in C++ code, or another error occurred.
	public func updateStore(
		_ storeId: String,
		users: [privmx.endpoint.core.UserWithPubKey],
		managers: [privmx.endpoint.core.UserWithPubKey],
		name: String,
		version: Int64,
		force: Bool,
		generateNewKeyId: Bool,
		accessToOldDataForNewUsers: Bool
	) throws -> Void {
		var v = privmx.UserWithPubKeyVector()
		for u in users{
			v.push_back(u)
		}
		
		var m = privmx.UserWithPubKeyVector()
		for u in managers{
			m.push_back(u)
		}
		
		try updateStore(std.string(storeId),
						users: v,
						managers: m,
						name: std.string(name),
						version: version,
						force: force,
						generateNewKeyId: generateNewKeyId,
						accessToOldDataForNewUsers: accessToOldDataForNewUsers)
	}
	
	/// Deletes a Store.
	///
	/// - Parameter storeId: which Store is to be deleted
	///
	/// - Throws: `PrivMXEndpointError.failedDeletingStore` if an exception was thrown in C++ code, or another error occurred.
	public func deleteStore(
		_ storeId: String
	) throws -> Void {
		try deleteStore(std.string(storeId))
	}
	
	/// Retrieves information about a File.
	///
	/// - Parameter fileId : information about which File is to be retrieved.
	///
	/// - Returns: Information about a File
	///
	/// - Throws: `PrivMXEndpointError.failedGettingFile` if an exception was thrown in C++ code, or another error occurred.
	public func getFile(
		_ fileId: String
	) throws -> privmx.endpoint.core.FileInfo {
		try getFile(std.string(fileId))
	}
	
	/// Lists  information about  Files in a Store
	///
	/// This does not download the files themselves, for that see `fileOpen()` and `fileRead()`
	///
	/// - Parameter storeId: from which Store should the Files be listed
	/// - Parameter query: parameters of the query
	///
	/// - Returns:`privmx.endpoint.core.FilesList`instance.
	///
	/// - Throws: `PrivMXEndpointError.failedListingFiles` if an exception was thrown in C++ code, or another error occurred.
	public func listFiles(
		from storeId: String,
		query: privmx.endpoint.core.ListQuery
	) throws -> privmx.endpoint.core.FilesList {
		try listFiles(from: std.string(storeId),
						   query: query)
	}
	
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
	/// - Throws: `PrivMXEndpointError.failedCreatingFile` if an exception was thrown in C++ code, or another error occurred.
	public func createFile(
		in storeId: String,
		size: Int64,
		mimetype: String,
		name: String
	) throws -> privmx.PMXFileHandle {
		try createFile(in: std.string(storeId),
							size: size,
							mimetype: std.string(mimetype),
							name: std.string(name))
	}
	
	/// Creates a new file handle for overwiting a file.
	///
	/// - Parameter fileId: Which File should be updated
	/// - Parameter size:the size of the file
	/// - Parameter mimetype:type of the file
	/// - Parameter name:the name of the file
	///
	/// - Returns: `privmx.PMXFileHandle` for writing,
	///
	/// - Throws: `PrivMXEndpointError.failedUpdatingFile` if an exception was thrown in C++ code, or another error occurred.
	public func updateFile(
		_ fileId: String,
		size: Int64,
		mimetype: String,
		name: String
	) throws -> privmx.PMXFileHandle {
		try updateFile(std.string(fileId),
							size: size,
							mimetype: std.string(mimetype),
							name: std.string(name))
	}
	
	/// Creates a new file handle for reading a File.
	///
	/// - Parameter fileId: which File should be opened
	///
	/// - Returns: `privmx.PMXFileHandle` for reading
	///
	/// - Throws: When the operation fails
	public func openFile(
		_ fileId: String
	) throws -> privmx.PMXFileHandle {
		try openFile(std.string(fileId))
	}
	
	/// Reads from an opened file.
	///
	/// - Parameter handle: the handle to an opened File
	/// - Parameter length: amount of bytes to be read
	///
	/// - Returns: `privmx.PMXFileHandle` for reading
	///
	/// - Throws: When the operation fails
	public func readFile(
		handle: privmx.PMXFileHandle,
		length: Int64
	) throws -> Data {
		try Data(from: readFile(handle: handle,
									 length: length))
	}
	
	/// Writes a chunk of data to an opened file on the Platform.
	///
	/// - Parameter handle: the handle to an opened file
	/// - Parameter dataChunk:  the data to be uploaded
	///
	/// - Throws: `PrivMXEndpointError.failedWritingToFile` if an exception was thrown in C++ code, or another error occurred.
	public func writeFile(
		handle: privmx.PMXFileHandle,
		dataChunk: Data
	) throws -> Void {
		try writeFile(handle: handle,
						   dataChunk: dataChunk.asBuffer())
	}
	
	/// Closes an open File
	///
	/// - Parameter handle: the handle to an open file
	///
	/// - Returns: The Id of the File
	///
	/// - Throws: `PrivMXEndpointError.failedClosingFile` if an exception was thrown in C++ code, or another error occurred.
	public func closeFile(
		handle: privmx.PMXFileHandle
	) throws -> String {
		try String(closeFile(handle: handle))
	}
	
	/// Deletes the specified File.
	///
	/// - Parameter fileId: which File should be deleted
	///
	/// - Returns: True if the file was delted succesfuly, false othrewise
	///
	/// - Throws: `PrivMXEndpointError.failedDeletingFile` if an exception was thrown in C++ code, or another error occurred.
	public func deleteFile(
		_ fileId: String
	) throws -> Bool {
		try deleteFile(std.string(fileId))
	}
	
}
