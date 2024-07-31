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

public extension EventChannel {
	var name: String {
		switch self {
		case .platform:
			return "platform"
		case .store:
			return "store"
		case .storeFiles(let storeID):
			return "store/\(storeID)/files"
		case .threadMessages(let threadID):
			return "thread2/\(threadID)/messages"
		case .thread2:
			return "thread2"
		}
	}
}
