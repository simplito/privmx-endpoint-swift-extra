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

extension privmx.endpoint.thread.ThreadMessageClientAuthor:Hashable{
	public func hash(
		into hasher: inout Hasher
	) -> Void {
		hasher.combine(pubKey)
	}
	
	public static func == (
		lhs: privmx.endpoint.thread.ThreadMessageClientAuthor,
		rhs: privmx.endpoint.thread.ThreadMessageClientAuthor
	) -> Bool {
		lhs.pubKey == rhs.pubKey
		&& lhs.userId == rhs.userId
	}
	
}
