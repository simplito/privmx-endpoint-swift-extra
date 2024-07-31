//
// PrivMX Endpoint Swift Extra
// Copyright © 2024 Simplito sp. z o.o.
//
// This file is part of the PrivMX Platform (https://privmx.cloud).
// This software is Licensed under the MIT License.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import PrivMXEndpointSwiftNative

extension privmx.endpoint.store.StoreFileInfo : Identifiable, Hashable{
	public static func == (
		lhs: privmx.endpoint.store.StoreFileInfo,
		rhs: privmx.endpoint.store.StoreFileInfo
	) -> Bool {
		lhs.fileId == rhs.fileId
		&& lhs.storeId == rhs.storeId
		&& lhs.author == rhs.author
		&& lhs.createDate == rhs.createDate
		&& lhs.size == rhs.size
		&& lhs.data == rhs.data
	}
	
	public var id: String{
		String(self.fileId)
	}
	
	public func hash(
		into hasher: inout Hasher
	) -> Void {
		hasher.combine(id)
	}
}

