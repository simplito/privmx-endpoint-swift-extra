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
import PrivMXEndpointSwiftExtra
import PrivMXEndpointSwiftNative

extension PrivMXSnippetClass {
	
	let CHANNEL_NAME = "CUSTOM_CHANNEL"
	let channel = EventChannel.custom(contextId: CONTEXT_ID , name: CHANNEL_NAME)
	
	func emittingCustomEvents(){
		endpointSession?.eventApi?.emitEvent(in: CONTEXT_ID,
											 to: [privmx.endpoint.core.UserWithPubKey]()//should be prepared by developer,
											 on: channel,
											 containing: Data())
	}
	
	func handlingCustomEvents(){
		endpointSession?.registerCallback(
			for: privmx.endpoint.event.ContextCustomEvent.self,
			from: channel,
			identified: "SOME_UNIQUE_IDENTIFIER",
			{ data in
				// some actions when a custom event is received
			})
	}
}
