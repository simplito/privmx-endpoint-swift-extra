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
	func listFilesStart(){
		
		let storeID = "STORE_ID"
		let query = privmx.endpoint.core.PagingQuery(
			skip: 0,
			limit: 10,
			sortOrder: .desc)
		 
		let pagedList = try? endpointSession?.storeApi?.listFiles(
			from: storeID,
			basedOn: query)
		
		let files = pagedList?.readItems.map{$0}
	}
	
	func deleteFIleStart(){
		try? endpointSession?.storeApi?.deleteFile("YOUR_FILE_ID")
	}
}
