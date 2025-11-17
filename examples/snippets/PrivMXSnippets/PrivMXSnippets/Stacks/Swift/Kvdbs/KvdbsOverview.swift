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

var kvdbApi: KvdbApi!
extension PrivMXSnippetClass {
	
	var KVDB_ID : String { "ID of your KVDB"}
	var KVDB_ENTRY_KEY : String { "KEY"}
	var KVDB_ENTRY_KEY_1 : String { "KEY_1"}
	var KVDB_ENTRY_KEY_2 : String { "KEY_2"}
	
	func guardKvdbSetup(){
		guard let sessionKvdbApi = endpointSession?.kvdbApi
		else {return}
		kvdbApi = sessionKvdbApi
	}
	
	func creatingKvdbBasic() throws{

		let kvdbId = try kvdbApi.createKvdb(
			in: CONTEXT_ID,
			for: [privmx.endpoint.core.UserWithPubKey(
				userId: USER1_ID,
				pubKey: USER1_PUBLIC_KEY)
				],
			managedBy: [privmx.endpoint.core.UserWithPubKey(
				userId: USER1_ID,
				pubKey: USER1_PUBLIC_KEY)
				],
			withPublicMeta: Data(),
			withPrivateMeta: Data())
	}
	
	func creatingKvdbNamed() throws{
		
		let name = "CUSTOM KVDB NAME"

		let kvdbId = try kvdbApi.createKvdb(
			in: CONTEXT_ID,
			for: [privmx.endpoint.core.UserWithPubKey(
				userId: USER1_ID,
				pubKey: USER1_PUBLIC_KEY)
				],
			managedBy: [privmx.endpoint.core.UserWithPubKey(
				userId: USER1_ID,
				pubKey: USER1_PUBLIC_KEY)
				],
			withPublicMeta: Data(name.utf8),
			withPrivateMeta: Data())
	}
	
	func creatingKvdbMeta() throws{
		
		struct PublicKVDBMeta : Codable{
			var tags : [String]
			var name : String
		}
		
		let publicKVDBMeta = try PublicKVDBMeta(
			tags: ["TAG1", "TAG2", "TAG3"],
			name: "Custom KVDB Name")
		let publicMeta = try JSONEncoder().encode(publicKVDBMeta)
		
		let kvdbId = try kvdbApi.createKvdb(
			in: CONTEXT_ID,
			for: [privmx.endpoint.core.UserWithPubKey(
				userId: USER1_ID,
				pubKey: USER1_PUBLIC_KEY)
				],
			managedBy: [privmx.endpoint.core.UserWithPubKey(
				userId: USER1_ID,
				pubKey: USER1_PUBLIC_KEY)
				],
			withPublicMeta: publicMeta,
			withPrivateMeta: Data())
	}
	
	func updatingKvdb() throws {
		let KVDB_ID = "ID of your KVDB"
		
		let currentKvdb = try kvdbApi.getKvdb(KVDB_ID)
		
		try kvdbApi.updateKvdb(
			KVDB_ID,
			atVersion: currentKvdb.version,
			replacingUsers: [privmx.endpoint.core.UserWithPubKey(
				userId: USER1_ID,
				pubKey: USER1_PUBLIC_KEY)
				],
			replacingManagers: [privmx.endpoint.core.UserWithPubKey(
				userId: USER1_ID,
				pubKey: USER1_PUBLIC_KEY)
				],
			replacingPublicMeta: Data(from:currentKvdb.publicMeta),
			replacingPrivateMeta: Data(from: currentKvdb.privateMeta),
			force: false,
			forceGenerateNewKey: false)
	}
	
	func deletingKvdb() throws{
		let KVDB_ID = "ID of your KVDB"
		
		try kvdbApi.deleteKvdb(KVDB_ID)
	}
	
	func listingKvdbs() throws{
		let kvdbList = try kvdbApi.listKvdbs(
			from: CONTEXT_ID,
			basedOn: privmx.endpoint.core.PagingQuery(
				skip: 0,
				limit: 25,
				sortOrder: .desc))
	}
	
	func gettingKvdb() throws{
		let KVDB_ID = "ID of your KVDB"
		
		let kvdb = try kvdbApi.getKvdb(KVDB_ID)
	}
}
