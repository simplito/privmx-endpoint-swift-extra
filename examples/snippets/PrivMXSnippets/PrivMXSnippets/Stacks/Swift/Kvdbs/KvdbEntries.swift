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
import PrivMXEndpointSwiftExtra

extension PrivMXSnippetClass {
	
	func creatingEntries() throws{
		try kvdbApi.setEntry(
			in: KVDB_ID,
			for: KVDB_ENTRY_KEY,
			withPublicMeta: Data("Some public metadata".utf8),
			withPrivateMeta: Data("Some private metadata".utf8),
			containing: Data("Some entry data".utf8))
	}
	
	func updatingEntries() throws{
		
		try kvdbApi.setEntry(
			in: KVDB_ID,
			for: KVDB_ENTRY_KEY,
			atVersion: 1,
			withPublicMeta: Data("NEW PUBLIC META".utf8),
			withPrivateMeta: Data("NEW PRIVATE META".utf8),
			containing: Data("New entry data".utf8))
	}
	
	
	func listingKeys() throws {
		
		let keysList = try kvdbApi.listEntriesKeys(
			from: KVDB_ID,
			basedOn: privmx.endpoint.core.PagingQuery(
				skip:0,
				limit:100,
				sortOrder:.desc
			))
	}
	
	func checkingEntry() throws{
		
		let entryExists = try kvdbApi.hasEntry(
			kvdbId: KVDB_ID,
			key: KVDB_ENTRY_KEY)
		
	}
	
	func fetchingEntries() throws {
		
		let entry = try kvdbApi.getEntry(
			from: KVDB_ID,
			for: KVDB_ENTRY_KEY)
		
		let entriesList = try kvdbApi.listEntries(
			from: KVDB_ID,
			basedOn: privmx.endpoint.core.PagingQuery(
				skip:0,
				limit: 10,
				sortOrder: .desc
			))
		
	}
	
	func deletingEntries() throws {
		
		try kvdbApi.deleteEntry(
			from: KVDB_ID,
			for: KVDB_ENTRY_KEY)
		
		let deletionStatus = try kvdbApi.deleteEntries(
			from: KVDB_ID,
			for: [
				KVDB_ENTRY_KEY_1,
				KVDB_ENTRY_KEY_2
			])
		
		for status in deletionStatus{
			print(status)
		}
		
	}
}
