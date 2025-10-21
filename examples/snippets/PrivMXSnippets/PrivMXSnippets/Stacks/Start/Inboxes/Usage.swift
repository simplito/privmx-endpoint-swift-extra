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

import PrivMXEndpointSwiftNative
import PrivMXEndpointSwift
import PrivMXEndpointSwiftExtra
import Foundation

extension PrivMXSnippetClass{

	func createInboxStart(){
		
		let users: [privmx.endpoint.core.UserWithPubKey] = [
			.init(userId: USER1_ID, pubKey: USER1_PUBLIC_KEY),
			.init(userId: USER2_ID, pubKey: USER2_PUBLIC_KEY)
		]
		let managers: [privmx.endpoint.core.UserWithPubKey] = [
			.init(userId: USER1_ID, pubKey: USER1_PUBLIC_KEY)
		]
		let publicMeta = Data("Some Public Metadata".utf8)
		let privateMeta = Data("Some Private Metadata".utf8)
		 
		let newInboxId = try? endpointSession?.inboxApi?.createInbox(
			in: CONTEXT_ID,
			for: users,
			managedBy: managers,
			withPublicMeta: publicMeta,
			withPrivateMeta: privateMeta,
			withFilesConfig:nil,
			withPolicies: nil)
		
	}
	
	func listInboxsStart(){
		let query = privmx.endpoint.core.PagingQuery(
			skip: 0,
			limit: 10,
			sortOrder: .desc)
		  
		let pagedList = try? endpointSession?.inboxApi?.listInboxes(
			from: CONTEXT_ID,
			basedOn: query)
		 
		pagedList?.readItems.forEach {
			print($0.inboxId)
		}
	}
	
	func updateInboxStart(){
		
		let inboxId = "THREAD_ID"
		 
		guard let inboxInfo = try? endpointSession?.inboxApi?.getInbox(inboxId)
		else {return}
		 
		let newUsers: [privmx.endpoint.core.UserWithPubKey] = [
			.init(userId: USER1_ID, pubKey: USER1_PUBLIC_KEY),
			.init(userId: USER2_ID, pubKey: USER2_PUBLIC_KEY),
			.init(userId: USER3_ID, pubKey: USER3_PUBLIC_KEY)
		]
		let newManagers: [privmx.endpoint.core.UserWithPubKey] = [
			.init(userId: USER1_ID, pubKey: USER1_PUBLIC_KEY),
			.init(userId: USER3_ID, pubKey: USER3_PUBLIC_KEY)
		]
		let newPublicMeta = Data("Some New Public Metadata".utf8)
		let newPrivateMeta = Data("Some New Private Metadata".utf8)
		 
		try? endpointSession?.inboxApi?.updateInbox(
			inboxId,
			replacingUsers: newUsers,
			replacingManagers: newManagers,
			replacingPublicMeta: newPublicMeta,
			replacingPrivateMeta: newPrivateMeta,
			replacingFilesConfig: nil,
			atVersion: inboxInfo.version,
			force: false,
			forceGenerateNewKey: false,
			replacingPolicies: inboxInfo.policy)
	}
	
	func deleteInboxStart(){
		try? endpointSession?.inboxApi?.deleteInbox("YOUR_INBOX_ID")
	}
	
	func startInboxPublicView(){
		
		let publicView = try? publicEndpointSession?.inboxApi?.getInboxPublicView(for: "YOUR INBOS ID")
		
		print("Public Meta:", publicView?.publicMeta.getString())
	}
}
