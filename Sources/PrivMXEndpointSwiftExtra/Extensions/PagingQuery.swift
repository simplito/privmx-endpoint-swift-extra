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
import PrivMXEndpointSwift
import PrivMXEndpointSwiftNative

/// Helper extensions for `PagingQuery` sort order.
/// This is a helper structure, since sort order is identified by strings in low-level Endpoint.
public extension privmx.endpoint.core.PagingQuery{
	init(
		skip: Int64,
		limit: Int64,
		sortOrder: PMXSortOrder,
		lastId:String? = nil,
		queryAsJson: String? = nil
	){
		var lid = privmx.OptionalString()
		if let lastId{
			lid = privmx.makeOptional(std.string(lastId))
		}
		var qaj = privmx.OptionalString()
		if let queryAsJson{
			qaj = privmx.makeOptional(std.string(queryAsJson))
		}
		self.init(skip: skip,limit: limit,sortOrder: sortOrder.rawValue,lastId: lid,queryAsJson: qaj)
	}
}

/// Accepted sort orders for `PagingQuery` instances
public enum PMXSortOrder:std.string{
	case asc,desc
}
