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
	/*func sendEntryStart(){
		
		let threadId: String; // ID of thread taken from threadApi.threadList
		
		//for now we can leave them empty
		let privateMeta = Data("My private data".utf8)
		let publicMeta = Data("My public data".utf8)
		
		let message = Data("This is my message".utf8)
		
		let msgId: String = (try? endpointSession?.threadApi?.sendEntry(
			in: CONTEXT_ID,
			withPublicMeta: publicMeta,
			withPrivateMeta: privateMeta,
			containing: message)) ?? "FAILED TO SEND"
	}
	
	func listEntrysStart(){
		let threadID = "THREAD_ID"
		let query = privmx.endpoint.core.PagingQuery(
			skip: 0,
			limit: 10,
			sortOrder: .desc)
		 
		let pagedList = try? endpointSession?.threadApi?.listEntrys(
			from: threadID,
			basedOn: query)
		
		pagedList?.readItems.forEach {
			print($0.info.messageId)
		}
	}
	
	func updateEntryStart(){
		try? endpointSession?.threadApi?.updateEntry(
			"YOUR_MESSAGE_ID",
			replacingData: Data("message data".utf8),
			replacingPublicMeta: Data("some new message public meta-data".utf8),
			replacingPrivateMeta: Data("some new message private meta-data".utf8))
	}
	
	func deleteEntryStart(){
		try? endpointSession?.threadApi?.deleteEntry("YOUR_MESSAGE_ID")
	}
*/}
