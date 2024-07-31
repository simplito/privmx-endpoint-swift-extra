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

extension privmx.endpoint.thread.ThreadClientMeta:Hashable{
	public static func == (lhs: privmx.endpoint.thread.ThreadClientMeta, rhs: privmx.endpoint.thread.ThreadClientMeta) -> Bool {
		return lhs.title == rhs.title
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(title)
	}
	
}
