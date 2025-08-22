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
	var CHANNEL_NAME: String  {"CUSTOM_CHANNEL"}
	var channel: EventChannel { EventChannel.custom(contextId: CONTEXT_ID , name: CHANNEL_NAME)}
	
	
	func emittingCustomEvents() throws {
		try endpointSession?.eventApi?.emitEvent(
			in: CONTEXT_ID,
			to: [privmx.endpoint.core.UserWithPubKey(userId: USER1_ID, pubKey: USER1_PUBLIC_KEY),
				 privmx.endpoint.core.UserWithPubKey(userId: USER2_ID, pubKey: USER2_PUBLIC_KEY),
				],
			on: channel.name,
			containing: Data())
	}
	
	func handlingCustomEvents() throws{
		try endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				cb: { data in
					//
				},
				request: .custom(channelName: CHANNEL_NAME,
								 contextId: CONTEXT_ID),
				group: "GROUP"))
	}
}
