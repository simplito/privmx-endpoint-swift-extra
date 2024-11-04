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

/// Extension of `StoreApi`, providing conformance for protocol using Swift types.
extension StoreApi : PrivMXStore{
	
	public func listStores(
		from contextId: String,
		basedOn query: privmx.endpoint.core.PagingQuery
	) throws -> privmx.StoreList {
		try listStores(contextId: std.string(contextId),
					   query:query)
	}
	
	
	public func getStore(
		_ storeId: String
	) throws -> privmx.endpoint.store.Store {
		try getStore(storeId:std.string(storeId))
	}
	
	public func createStore(
		in contextId: String,
		for users: [privmx.endpoint.core.UserWithPubKey],
		managedBy managers: [privmx.endpoint.core.UserWithPubKey],
		withPublicMeta publicMeta: Data,
		withPrivateMeta privateMeta: Data
	) throws -> String {
		return try String(createStore(contextId: std.string(contextId),
									  users: privmx.UserWithPubKeyVector(users),
									  managers: privmx.UserWithPubKeyVector(managers),
									  publicMeta: publicMeta.asBuffer(),
									  privateMeta: privateMeta.asBuffer()))
	}
	
	public func updateStore(
		_ storeId: String,
		atVersion version: Int64,
		replacingUsers users: [privmx.endpoint.core.UserWithPubKey],
		replacingManagers managers: [privmx.endpoint.core.UserWithPubKey],
		replacingPublicMeta publicMeta: Data,
		replacingPrivateMeta privateMeta: Data,
		force: Bool,
		forceGenerateNewKey: Bool
	) throws -> Void {
		try updateStore(storeId:std.string(storeId),
						version: version,
						users: privmx.UserWithPubKeyVector(users),
						managers: privmx.UserWithPubKeyVector(managers),
						publicMeta: publicMeta.asBuffer(),
						privateMeta: privateMeta.asBuffer(),
						force: force,
						forceGenerateNewKey: forceGenerateNewKey)
	}
	
	public func deleteStore(
		_ storeId: String
	) throws -> Void {
		try deleteStore(storeId: std.string(storeId))
	}
	
	public func getFile(
		_ fileId: String
	) throws -> privmx.endpoint.store.File {
		try getFile(fileId: std.string(fileId))
	}
	
	public func listFiles(
		from storeId: String,
		basedOn query: privmx.endpoint.core.PagingQuery
	) throws -> privmx.FileList {
		try listFiles(storeId: std.string(storeId),
					  query: query)
	}
	
	
	public func createFile(
		in storeId: String,
		withPublicMeta publicMeta: Data,
		withPrivateMeta privateMeta: Data,
		ofSize size: Int64
	) throws -> privmx.StoreFileHandle {
		try createFile(storeId: std.string(storeId),
					   publicMeta: publicMeta.asBuffer(),
					   privateMeta: privateMeta.asBuffer(),
					   size: size)
	}
	
	
	public func updateFile(
		_ fileId: String,
		replacingPublicMeta publicMeta: Data,
		replacingPrivateMeta privateMeta: Data,
		replacingSize size: Int64
	) throws -> privmx.StoreFileHandle {
		try updateFile(fileId:std.string(fileId),
					   publicMeta: publicMeta.asBuffer(),
					   privateMeta: privateMeta.asBuffer(),
					   size: size)
	}
	
	
	public func openFile(
		_ fileId: String
	) throws -> privmx.StoreFileHandle {
		try openFile(fileId: std.string(fileId))
	}
	
	/// Reads from an opened file.
	///
	/// - Parameter handle: the handle to an opened File
	/// - Parameter length: amount of bytes to be read
	///
	/// - Returns: `privmx.StoreFileHandle` for reading
	///
	/// - Throws: When the operation fails
	public func readFromFile(
		withHandle handle: privmx.StoreFileHandle,
		length: Int64
	) throws -> Data {
		try Data(from: readFromFile(handle: handle,
									length: length))
	}
	
	/// Writes a chunk of data to an opened file on the Platform.
	///
	/// - Parameter handle: the handle to an opened file
	/// - Parameter dataChunk:  the data to be uploaded
	///
	/// - Throws: `PrivMXEndpointError.failedWritingToFile` if an exception was thrown in C++ code, or another error occurred.
	public func writeToFile(
		withHandle handle: privmx.StoreFileHandle,
		uploading dataChunk: Data
	) throws -> Void {
		try writeToFile(handle: handle,
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
		withHandle handle: privmx.StoreFileHandle
	) throws -> String {
		try String(closeFile(handle: handle))
	}
	
	/// Deletes the specified File.
	///
	/// - Parameter fileId: which File should be deleted
	///
	/// - Returns: True if the file was deleted successfully, false otherwise.
	///
	/// - Throws: `PrivMXEndpointError.failedDeletingFile` if an exception was thrown in C++ code, or another error occurred.
	public func deleteFile(
		_ fileId: String
	) throws -> Void {
		try deleteFile(fileId: std.string(fileId))
	}
	
	public func seekInFile(
		withHandle handle: privmx.StoreFileHandle,
		toPosition position: Int64
	) throws -> Void {
		try seekInFile(handle: handle,
					   position: position)
	}
	
	public func unubscribeFromFileEvents(
		in storeId: String
	) throws -> Void {
		try unsubscribeFromFileEvents(storeId: std.string(storeId))
	}
	
	public func subscribeForFileEvents(
		in storeId: String
	) throws -> Void {
		try subscribeForFileEvents(storeId: std.string(storeId))
	}
}
