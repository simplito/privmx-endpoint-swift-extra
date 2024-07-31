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

extension privmx.endpoint.thread.ThreadMessageClientData : Hashable{
	public static func == (lhs: privmx.endpoint.thread.ThreadMessageClientData, rhs: privmx.endpoint.thread.ThreadMessageClientData) -> Bool {
		lhs.msgId == rhs.msgId
		&& lhs.deleted == rhs.deleted
		&& lhs.author == rhs.author
		&& lhs.date == rhs.date
		&& lhs.destination == rhs.destination
		&& lhs.text == rhs.text
		&& lhs.type == rhs.type
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(msgId)
		hasher.combine(date)
		hasher.combine(text)
		hasher.combine(author)
	}
}
