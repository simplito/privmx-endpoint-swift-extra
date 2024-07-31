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

extension privmx.endpoint.store.StoreFileClientMeta : Hashable {
	public static func == (
		lhs: privmx.endpoint.store.StoreFileClientMeta,
		rhs: privmx.endpoint.store.StoreFileClientMeta
	) -> Bool {
		lhs.name == rhs.name
		&& lhs.mimetype == rhs.mimetype
		&& lhs.size == rhs.size
		&& lhs.author == rhs.author
		&& lhs.destination == rhs.destination
	}
	
	
	public func hash(
		into hasher: inout Hasher
	) -> Void {
		hasher.combine(name)
		hasher.combine(size)
	}
}
