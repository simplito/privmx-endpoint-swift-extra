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

/// Definition of Channels available for reading Events.
/// This is a helper structure, since channels are identified by strings in low-level Endpoint.
public enum EventChannel {
	/// Synthetic channel, used for registering for library Events
	case platform
	/// Channel for Events regarding Stores
	case store
	/// Channel for Events regarding Files in a particular Store
	case storeFiles(storeID: String)
	/// Channel for Events regarding Messages in a particular Thread
	case threadMessages(threadID: String)
	/// Channel for Events regarding Threads
	case thread
	/// Channel for Events regarding Inboxes
	case inbox
	/// Channel for Events regarding Entries in a particular Inbox
	case inboxEntries(inboxID:String)
	/// Channels for `ContextCustomEvent`s
	case custom(contextId:String,name:String)
	/// Channel for Events regarding KVDBs
	case kvdb
	/// Channel for Events regarding Entries in a particular KVDB
	case kvdbEntries(kvdbId: String)
}
