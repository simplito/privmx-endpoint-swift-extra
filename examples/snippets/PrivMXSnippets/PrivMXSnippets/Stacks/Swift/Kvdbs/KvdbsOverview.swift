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
	
	var kvdbApi : KvdbApi
	let KVDB_ID = "ID of your KVDB"
	let KVDB_ENTRY_KEY = "KEY"
	let publicMeta = Data()
	let privateMeta = Data()
	
	func guardKvdbSetup(){
		guard let sessionKvdbApi = endpointSession?.kvdbApi
		else {return}
		kvdbApi = eskvdbApi
	}
	
	func creatingKvdb(){
		
		let publicMeta = Data()
		let privateMeta = Data()

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
			withPrivateMeta: privateMeta)
	}
	
	func updatingKvdb(){
		let KVDB_ID = "ID of your KVDB"
		
		let currentKvdb = try kvdbApi.getKvdb(KVDB_ID)
		
		try kvdbApi.updateKvdb(
			kvdbId,
			atVersion: 1,
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
	
	func deletingKvdb(){
		
	}
	
	func gettingKvdb(){
		
	}
	
	func listingKvdbs()
}
