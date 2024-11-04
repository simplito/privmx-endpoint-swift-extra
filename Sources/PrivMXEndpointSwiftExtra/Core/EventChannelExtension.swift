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

/// Definition of `EventChannel` available for reading Events.
/// This is a helper structure, since channels are identified by strings in low-level Endpoint.
extension EventChannel {
	public var name: String {
		switch self {
			case .platform:
				return "platform"
			case .store:
				return "store"
			case .storeFiles(let storeID):
				return "store/\(storeID)/files"
			case .threadMessages(let threadID):
				return "thread/\(threadID)/messages"
			case .thread:
				return "thread"
			case .inbox:
				return "inbox"
			case .inboxEntries(inboxID: let inboxID):
				return "inbox/\(inboxID)/entries"
		}
	}
}
