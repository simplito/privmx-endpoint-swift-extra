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
import PrivMXEndpointSwift
import PrivMXEndpointSwiftNative

public extension privmx.endpoint.core.ListQuery{
	init(
		skip: Int64,
		limit: Int64,
		sortOrder: PMXSortOrder,
		lastId:String? = nil
	){
		var lid = privmx.OptionalString()
		if let lastId{
			lid = privmx.makeOptional(std.string(lastId))
		}
		self.init(skip: skip,limit: limit,sortOrder: sortOrder.rawValue,lastId: lid)
	}
}
