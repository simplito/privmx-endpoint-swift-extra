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
	
	func createThreadStart(){
		
		let users: [privmx.endpoint.core.UserWithPubKey] = [
			.init(userId: USER1_ID, pubKey: USER1_PUBLIC_KEY),
			.init(userId: USER2_ID, pubKey: USER2_PUBLIC_KEY)
		]
		let managers: [privmx.endpoint.core.UserWithPubKey] = [
			.init(userId: USER1_ID, pubKey: USER1_PUBLIC_KEY)
		]
		let publicMeta = Data("Some Public Metadata".utf8)
		let privateMeta = Data("Some Private Metadata".utf8)
		
		let newThreadId = try? endpointSession?.threadApi?.createThread(
			in: CONTEXT_ID,
			for: users,
			managedBy: managers,
			withPublicMeta: publicMeta,
			withPrivateMeta: privateMeta,
			withPolicies: nil)
		
	}
	
	func listThreadsStart(){
		let query = privmx.endpoint.core.PagingQuery(
			skip: 0,
			limit: 10,
			sortOrder: .desc)
		 
		let pagedList = try? endpointSession?.threadApi?.listThreads(
			from: CONTEXT_ID,
			basedOn: query)
		
		pagedList?.readItems.forEach {
			print($0.threadId)
		}
	}
	
	func updateThreadStart(){
		
		let threadId = "THREAD_ID"
		 
		guard let threadInfo = try? endpointSession?.threadApi?.getThread(threadId)
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
		 
		try? endpointSession?.threadApi?.updateThread(
			threadId,
			atVersion: threadInfo.version,
			replacingUsers: newUsers,
			replacingManagers: newManagers,
			replacingPublicMeta: newPublicMeta,
			replacingPrivateMeta: newPrivateMeta,
			force: false,
			forceGenerateNewKey: false,
			replacingPolicies: threadInfo.policy)
	}
	
	func deleteThreadStart(){
		let threadId = "THREAD_ID"
		try? endpointSession?.threadApi?.deleteThread(threadId)
	}
}
