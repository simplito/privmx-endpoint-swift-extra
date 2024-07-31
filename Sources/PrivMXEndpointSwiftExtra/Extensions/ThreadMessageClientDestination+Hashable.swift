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

extension privmx.endpoint.thread.ThreadMessageClientDestination:Hashable{
	public func hash(
		into hasher: inout Hasher
	) -> Void {
		hasher.combine(contextId)
		hasher.combine(server)
		hasher.combine(threadId)
	}
	
	public static func == (
		lhs: privmx.endpoint.thread.ThreadMessageClientDestination,
		rhs: privmx.endpoint.thread.ThreadMessageClientDestination
	) -> Bool {
		lhs.contextId == rhs.contextId
		&& lhs.server == rhs.server
		&& lhs.threadId == rhs.server
	}
	
	
}
