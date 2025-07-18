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

extension PrivMXSnippetClass {
	
	func creatingEntries() throws{
		try kvdbApi.setEntry(
			in: KVDB_ID,
			for: KVDB_ENTRY_KEY,
			withPublicMeta: publicMeta,
			withPrivateMeta: privateMeta,
			containing: Data("Some entry data".utf8))
	}
	
	func updatingEntries(){
		
		try kvdbApi.setEntry(
			in: KVDB_ID,
			for: KVDB_ENTRY_KEY,
			atVersion: 1,
			withPublicMeta: Data("NEW PUBLIC META"),
			withPrivateMeta: Data("NEW PRIVATE META"),
			containing: Data("New entry data".utf8))
	}
	
	
	func listingKeys(){
		
		let keysList = kvdbApi.listEntriesKeys(
			from: KVDB_ID,
			basedOn: privmx.endpoint.core.PagingQuery(
				skip:0,
				limit:100,
				sortOrder:.desc
			))
	}
	
	func checkingEntry(){
		
		let entryExists = try kvdbApi.hasEntry(
			kvdbId: KVDB_ID,
			key: KVDB_ENTRY_KEY)
		
	}
	
	func fetchingEntries(){
		
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
	
	func deletingEntries(){
		
		try kvdbApi.deleteEntry(
			from: KVDB_ID,
			for: KVDB_ENTRY_KEY)
		
		let deletionStatus = kvdbApi.deleteEntries(
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
