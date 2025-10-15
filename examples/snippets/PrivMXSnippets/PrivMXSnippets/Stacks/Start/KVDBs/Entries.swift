//
// PrivMX Endpoint Swift Extra
// Copyright © 2025 Simplito sp. z o.o.
//
// This file is part of the PrivMX Platform (https://privmx.dev).
// This software is Licensed under the MIT License.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import PrivMXEndpointSwiftNative
import PrivMXEndpointSwiftExtra
import PrivMXEndpointSwift

extension PrivMXSnippetClass{
	func sendKVDBEntryStart(){
		
		// creating Entries
		try? kvdbApi.setEntry(
			in: "KVDB_ID",
			for: "KVDB_ENTRY_KEY",
			withPublicMeta: Data("Some public metadata".utf8),
			withPrivateMeta: Data("Some private metadata".utf8),
			containing: Data("Some entry data".utf8))
	}
	
	func listKVDBEntrysStart(){
		let query = privmx.endpoint.core.PagingQuery(
			skip: 0,
			limit: 10,
			sortOrder: .desc)
		 
		let pagedList = try? endpointSession?.kvdbApi?.listEntries(
			from: KVDB_ID,
			basedOn: query)
		
		pagedList?.readItems.forEach {
			print("KVDB Entry Key:",$0.info.key)
		}
	}
	
	func updateEntryStart(){
		guard let entry = try? endpointSession?.kvdbApi?.getEntry(
			from: KVDB_ID,
			for: KVDB_ENTRY_KEY)
		else {return}
		
		try? kvdbApi.setEntry(
			in: String(entry.info.kvdbId),
			for: String(entry.info.key),
			atVersion: entry.version,
			withPublicMeta: Data("NEW PUBLIC META".utf8),
			withPrivateMeta: Data("NEW PRIVATE META".utf8),
			containing: Data("New entry data".utf8))
	}
	
	func deleteKvdbEntryStart(){
		try? endpointSession?.kvdbApi?.deleteEntry(
			from: KVDB_ID,
			for:KVDB_ENTRY_KEY)
	}
}
