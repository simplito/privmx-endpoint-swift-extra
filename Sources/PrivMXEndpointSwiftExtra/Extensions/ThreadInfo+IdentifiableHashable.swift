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
import Cxx
import CxxStdlib
import PrivMXEndpointSwiftNative

extension privmx.endpoint.thread.ThreadInfo
:Identifiable,Hashable{
	public static func == (
		lhs: privmx.endpoint.thread.ThreadInfo,
		rhs: privmx.endpoint.thread.ThreadInfo
	) -> Bool {
		lhs.threadId == rhs.threadId
		&& lhs.contextId == rhs.contextId
		&& lhs.createDate == rhs.createDate
		&& lhs.creator == rhs.creator
		&& lhs.lastModifier == rhs.lastModifier
		&& lhs.lastModificationDate == rhs.lastModificationDate
		&& lhs.messagesCount == rhs.messagesCount
		&& lhs.lastMsgDate == rhs.lastMsgDate
		&& lhs.data == rhs.data
		&& lhs.users == rhs.users
		&& lhs.managers == rhs.managers
		&& lhs.version == rhs.version
		
		
	}
	
	public var id: String{
		String(self.threadId)
	}
	
	public func hash(
		into hasher: inout Hasher
	) -> Void {
		hasher.combine(threadId)
		hasher.combine(lastModificationDate)
		hasher.combine(version)
	}
}

