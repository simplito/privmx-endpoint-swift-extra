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

extension privmx.endpoint.thread.ThreadMessage
:Identifiable,Hashable{
	public var id: String{
		String(messageId)
	}
	
	public static func == (
		lhs:privmx.endpoint.thread.ThreadMessage,
		rhs:privmx.endpoint.thread.ThreadMessage
	)->Bool{
		rhs.messageId == rhs.messageId
		&& lhs.author == rhs.author
		&& lhs.createDate == rhs.createDate
		&& lhs.data == rhs.data
		&& lhs.threadId == rhs.threadId
	}
	
	public func hash(
		into hasher: inout Hasher
	) -> Void {
		hasher.combine(messageId)
		hasher.combine(threadId)
	}
}
