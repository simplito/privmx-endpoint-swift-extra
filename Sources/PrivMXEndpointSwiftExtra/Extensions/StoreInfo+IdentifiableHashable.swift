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
import CxxStdlib
import PrivMXEndpointSwiftNative

extension privmx.endpoint.store.StoreInfo : Identifiable, Hashable {
	public static func == (
		lhs: privmx.endpoint.store.StoreInfo,
		rhs: privmx.endpoint.store.StoreInfo
	) -> Bool {
		lhs.storeId == rhs.storeId
		&& lhs.contextId == rhs.contextId
		&& lhs.createDate == rhs.createDate
		&& lhs.creator == rhs.creator
		&& lhs.data == rhs.data
		&& lhs.filesCount == rhs.filesCount
		&& lhs.lastFileDate == rhs.lastFileDate
		&& lhs.lastModificationDate == rhs.lastModificationDate
		&& lhs.lastModifier == rhs.lastModifier
		&& lhs.managers == rhs.managers
		&& lhs.users == rhs.users
		&& lhs.version == rhs.version
	}
	
	public var id:String{
		String(self.storeId)
	}
	
	public func hash(
		into hasher: inout Hasher
	) -> Void {
		hasher.combine(id)
		hasher.combine(lastModificationDate)
		hasher.combine(version)
	}
}
