//
// PrivMX Endpoint Swift Extra
// Copyright © 2025 Simplito sp. z o.o.
//
// This file is part of the PrivMX Platform (https://privmx.dev).
// This software is Licensed under the MIT License.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//

import PrivMXEndpointSwiftNative
import PrivMXEndpointSwift
import PrivMXEndpointSwiftExtra
import Foundation

extension PrivMXSnippetClass{
	
	func eventsThreadStart(){
		
		let threadId = "THREAD_ID"
		let messageId = "MESSAGE_ID"
		
		Task{
			try? await endpointContainer?.startListening()
		}
		
		let registrationErrors = endpointSession?.registerCallbacksInBulk(
			[
				PMXEventCallbackRegistration(
					request: .thread(
						eventType: privmx.endpoint.thread.THREAD_CREATE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a new thread created
					}),
				PMXEventCallbackRegistration(
					request: .thread(
						eventType: privmx.endpoint.thread.THREAD_UPDATE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a thread is updated
					}),
				PMXEventCallbackRegistration(
					request: .thread(
						eventType: privmx.endpoint.thread.THREAD_UPDATE,
						selectorType: .Container,
						selectorId: threadId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a thread is updated
					}),
				PMXEventCallbackRegistration(
					request: .thread(
						eventType: privmx.endpoint.thread.THREAD_STATS,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a thread's stats change
					}),
				PMXEventCallbackRegistration(
					request: .thread(
						eventType: privmx.endpoint.thread.THREAD_STATS,
						selectorType: .Container,
						selectorId: threadId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a thread's stats change
					}),
				PMXEventCallbackRegistration(
					request: .thread(
						eventType: privmx.endpoint.thread.THREAD_DELETE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a thread is deleted
					}),
				PMXEventCallbackRegistration(
					request: .thread(
						eventType: privmx.endpoint.thread.THREAD_DELETE,
						selectorType: .Container,
						selectorId: threadId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a thread is deleted
					}),
				PMXEventCallbackRegistration(
					request: .thread(
						eventType: privmx.endpoint.thread.COLLECTION_CHANGE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when any thread's contents change
					}),
				PMXEventCallbackRegistration(
					request: .thread(
						eventType: privmx.endpoint.thread.COLLECTION_CHANGE,
						selectorType: .Container,
						selectorId: threadId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a particular thread's contents change
					}),
				PMXEventCallbackRegistration(
					request: .thread(
						eventType: privmx.endpoint.thread.MESSAGE_CREATE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions on any new message
					}),
				PMXEventCallbackRegistration(
					request: .thread(
						eventType: privmx.endpoint.thread.MESSAGE_CREATE,
						selectorType: .Container,
						selectorId: threadId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions on new message in a particular thread
					}),
				PMXEventCallbackRegistration(
					request: .thread(
						eventType: privmx.endpoint.thread.MESSAGE_UPDATE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when any message is updated
					}),
				PMXEventCallbackRegistration(
					request: .thread(
						eventType: privmx.endpoint.thread.MESSAGE_UPDATE,
						selectorType: .Container,
						selectorId: threadId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a message in a particular thread is updated
					}),
				PMXEventCallbackRegistration(
					request: .thread(
						eventType: privmx.endpoint.thread.MESSAGE_UPDATE,
						selectorType: .Item,
						selectorId: messageId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a particular message is updated
					}),
				
				PMXEventCallbackRegistration(
					request: .thread(
						eventType: privmx.endpoint.thread.MESSAGE_DELETE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when any message is deleted
					}),
				
				PMXEventCallbackRegistration(
					request: .thread(
						eventType: privmx.endpoint.thread.MESSAGE_DELETE,
						selectorType: .Container,
						selectorId: threadId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a message in a particular thread is deleted
					}),
				PMXEventCallbackRegistration(
					request: .thread(
						eventType: privmx.endpoint.thread.MESSAGE_DELETE,
						selectorType: .Item,
						selectorId: messageId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a particular message is deleted
					})
			])
		
	}
}
