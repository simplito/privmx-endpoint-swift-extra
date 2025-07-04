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

import PrivMXEndpointSwiftNative
import PrivMXEndpointSwift
import Foundation

extension KvdbApi {
	
	/// Creates a new KVDB in given Context.
	///
	/// - Parameter contextId: ID of the Context to create the KVDB in
	/// - Parameter users: array of UserWithPubKey structs which indicates who will have access to the created KVDB
	/// - Parameter managers: array of UserWithPubKey structs which indicates who will have access (and management rights) to the created KVDB
	/// - Parameter publicMeta: public (unencrypted) metadata
	/// - Parameter privateMeta: private (encrypted) metadata
	/// - Parameter policies: KVDB's policies
	///
	/// - Returns: Id of the created KVDB
	///
	/// - Throws: `PrivMXEndpointError.failedCreatingKvdb` if creating a Kvdb fails.
	public func createKvdb(
		in contextId: String,
		for users: [privmx.endpoint.core.UserWithPubKey],
		managedBy managers: [privmx.endpoint.core.UserWithPubKey],
		withPublicMeta publicMeta: Data,
		withPrivateMeta privateMeta: Data,
		withPolicies policies: privmx.endpoint.core.ContainerPolicy? = nil
	) throws -> String {
		var op = privmx.OptionalContainerPolicy()
		if let policies{
			op = privmx.makeOptional(policies)
		}
		
		var uv = privmx.UserWithPubKeyVector()
		uv.reserve(users.count)
		for u in users{
			uv.push_back(u)
		}
		var mv = privmx.UserWithPubKeyVector()
		mv.reserve(managers.count)
		for m in mv{
			mv.push_back(m)
		}
		
		return try String(self.createKvdb(
			contextId: std.string(contextId),
			users: uv,
			managers: mv,
			publicMeta: publicMeta.asBuffer(),
			privateMeta: privateMeta.asBuffer(),
			policies: op))
	}

		
	/// Updates an existing KVDB.
	///
	/// - Parameter kvdbId: ID of the KVDB to update
	/// - Parameter users: array of UserWithPubKey structs which indicates who will have access to the created KVDB
	/// - Parameter managers: array of UserWithPubKey structs which indicates who will have access (and management rights) to the created KVDB
	/// - Parameter publicMeta: public (unencrypted) metadata
	/// - Parameter privateMeta: private (encrypted) metadata
	/// - Parameter version: current version of the updated KVDB
	/// - Parameter force: force update (without checking version)
	/// - Parameter forceGenerateNewKey: force to regenerate a key for the KVDB
	/// - Parameter policies: KVDB's policies
	///
	/// - Throws: `PrivMXEndpointError.failedUpdatingKvdb` when the operation fails.
	public func updateKvdb(
		_ kvdbId: String,
		replacingUsers users: [privmx.endpoint.core.UserWithPubKey],
		replacingManagers managers: [privmx.endpoint.core.UserWithPubKey],
		replacingPublicMeta publicMeta: Data,
		replacingPrivateMeta privateMeta: Data,
		atVersion version: Int64,
		force: Bool,
		forceGenerateNewKey:Bool,
		replacingPolicies policies: privmx.endpoint.core.ContainerPolicy? = nil
	) throws -> Void {
		var op = privmx.OptionalContainerPolicy()
		if let policies{
			op = privmx.makeOptional(policies)
		}
		
		var uv = privmx.UserWithPubKeyVector()
		uv.reserve(users.count)
		for u in users{
			uv.push_back(u)
		}
		var mv = privmx.UserWithPubKeyVector()
		mv.reserve(managers.count)
		for m in mv{
			mv.push_back(m)
		}
		
		try self.updateKvdb(
			kvdbId: std.string(kvdbId),
			users: uv,
			managers: mv,
			publicMeta: publicMeta.asBuffer(),
			privateMeta: privateMeta.asBuffer(),
			version: version,
			force: force,
			forceGenerateNewKey: forceGenerateNewKey,
			policies: op)
	}
	
	/// Deletes a KVDB by given KVDB ID.
	///
	/// - Parameter kvdbId: ID of the KVDB to delete
	///
	/// - Throws: `PrivMXEndpointError.failedDeletingKvdb` if deleting the KVDB fails.
	public func deleteKvdb(
		_ kvdbId: String
	) throws -> Void {
		try self.deleteKvdb(kvdbId: std.string(kvdbId))
	}
	
	/// Gets a KVDB by given KVDB ID.
	///
	/// - Parameter kvdbId:ID of KVDB to get
	///
	/// - Returns: struct containing info about the KVDB
	///
	/// - Throws: `PrivMXEndpointError.failedGettingKvdb` if the operation fails.
	public func getKvdb(
		_ kvdbId: String
	) throws -> privmx.endpoint.kvdb.Kvdb {
		try self.getKvdb(kvdbId: std.string(kvdbId))
	}
	
	/// Gets a list of Kvdbs in given Context.
	///
	/// - Parameter contextId: ID of the Context to get the Kvdbs from
	/// - Parameter pagingQuery: with list query parameters
	///
	/// - Returns: struct containing a list of Kvdbs
	///
	/// - Throws: `PrivMXEndpointError.failedListingKvdbs` if the operation fails.
	public func listKvdbs(
		from contextId: String,
		basedOn pagingQuery: privmx.endpoint.core.PagingQuery
	) throws -> privmx.KvdbList {
		try self.listKvdbs(
			contextId: std.string(contextId),
			pagingQuery: pagingQuery)
	}
	
	/// Check whether the KVDB entry exists.
	///
	/// - Parameter kvdbId: KVDB ID of the KVDB entry to check
	/// - Parameter key: key of the KVDB entry to check
	///
	/// - Returns: 'true' if the KVDB has an entry with given key, 'false' otherwise
	public func hasEntry(
		kvdbId: String,
		key: String
	) throws -> Bool {
		try self.hasEntry(kvdbId: std.string(kvdbId), key: std.string(key))
	}
	
	/// Gets a KVDB entry by given KVDB entry key and KVDB ID.
	///
	/// - Parameter kvdbId: KVDB ID of the KVDB entry to get
	/// - Parameter key: key of the KVDB entry to get
	///
	/// - Returns: struct containing the KVDB entry
	///
	/// - Throws: `PrivMXEndpointError.failedGettingKvdbEntry` if the operation fails.
	public func getEntry(
		from kvdbId: String,
		for key: String,
	) throws -> privmx.endpoint.kvdb.KvdbEntry{
		try self.getEntry(
			kvdbId: std.string(kvdbId),
			key: std.string(key))
	}
	
	/// Gets a list of KVDB entries keys from a KVDB.
	///
	/// - Parameter kvdbId: ID of the KVDB to list KVDB entries from
	/// - Parameter pagingQuery: with list query parameters
	///
	/// - Returns: struct containing a list of KVDB entries
	///
	/// - Throws: `PrivMXEndpointError.failedListingKvdbEntriesKeys` if the operation fails.
	public func listEntriesKeys(
		_ kvdbId: String,
		basedOn pagingQuery: privmx.endpoint.core.PagingQuery
	) throws -> privmx.StringList {
		try self.listEntriesKeys(
			kvdbId: std.string(kvdbId),
			pagingQuery: pagingQuery)
	}
	
	/// Gets a list of KVDB entries from a KVDB.
	///
	/// - Parameter kvdbId: ID of the KVDB to list KVDB entries from
	/// - Parameter pagingQuery:  with list query parameters
	///
	/// - Returns: struct containing a list of KVDB entries
	///
	/// - Throws: `PrivMXEndpointError.failedListingKvdbEntries` if the operation fails.
	public func listEntries(
		from kvdbId: String,
		basedOn pagingQuery: privmx.endpoint.core.PagingQuery
	) throws -> privmx.KvdbEntryList {
		try self.listEntries(
			kvdbId: std.string(kvdbId),
			pagingQuery: pagingQuery)
	}
	
	
	/// Sets a KVDB entry in the given KVDB.
	///
	/// - Parameter kvdbId: ID of the KVDB to set the entry to
	/// - Parameter version: the version of the Entry to set, the default value is 0 for creating a new KVDB Entry
	/// - Parameter key: KVDB entry key
	/// - Parameter publicMeta: public KVDB entry metadata
	/// - Parameter privateMeta: private KVDB entry metadata
	/// - Parameter data: content of the KVDB entry
	///
	/// - Returns: ID of the new KVDB entry
	///
	/// - Throws: PrivMXEndpointError.failedSettingKvdbEntry.
	public func setEntry(
		in kvdbId: String,
		for key: String,
		atVersion version: Int64 = 0,
		withPublicMeta publicMeta: Data,
		withPrivateMeta privateMeta: Data,
		containing data: Data
	) throws -> Void {
		try self.setEntry(
			kvdbId: std.string(kvdbId),
			key: std.string(key),
			publicMeta: publicMeta.asBuffer(),
			privateMeta: privateMeta.asBuffer(),
			data: data.asBuffer(),
			version: version)
	}
	
	/// Deletes a KVDB entry by given KVDB entry ID.
	///
	/// - Parameter kvdbId: KVDB ID of the KVDB entry to delete
	/// - Parameter key: key of the KVDB entry to delete
	///
	/// - Throws: `PrivMXEndpointError.failedDeletingKvdbEntry` if the operation fails.
	public func deleteEntry(
		from kvdbId: String,
		for key: String
	) throws -> Void {
		try self.deleteEntry(
			kvdbId: std.string(kvdbId),
			key: std.string(key))
	}
	
	/// Deletes KVDB entries by given KVDB IDs and the list of entry keys.
	///
	/// - Parameter kvdbId: ID of the KVDB database to delete from
	/// - Parameter keys: vector of the keys of the KVDB entries to delete
	///
	/// - Returns: map with the statuses of deletion for every key
	public func deleteEntries(
		from kvdbId: String,
		for keys: [String]
	) throws -> [String:Bool] {
		var sv = privmx.StringVector()
		sv.reserve(keys.count)
		for k in keys{
			sv.push_back(std.string(k))
		}
		var result = [String:Bool]()
		try self.deleteEntries(
			kvdbId: std.string(kvdbId),
			keys: sv).forEach({result[String($0.first)] = $0.second})
		return result
	}
	
	/// Subscribes for events in given KVDB.
	///
	/// - Parameter kvdbId: ID of the KVDB to subscribe
	/// - Throws: `PrivMXEndpointError.failedSubscribingForEvents` if the operation fails.
	public func subscribeForEntryEvents(
		in kvdbId: String
	) throws -> Void {
		try self.subscribeForEntryEvents(kvdbId: std.string(kvdbId))
	}
	
	/// Unsubscribes from events in given KVDB.
	///
	/// - Parameter kvdbId: ID of the KVDB to unsubscribe
	///
	/// - Throws: `PrivMXEndpointError.failedUnsubscribingFromEvents` if the operation fails.
	public func unsubscribeFromEntryEvents(
		in kvdbId: String
	) throws -> Void {
		try self.unsubscribeFromEntryEvents(kvdbId: std.string(kvdbId))
	}
}
