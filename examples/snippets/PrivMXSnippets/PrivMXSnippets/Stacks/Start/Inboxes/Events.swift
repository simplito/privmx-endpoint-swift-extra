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
	
	func eventsInboxStart(){
		
		let inboxId = "INBOX_ID"
		let entryId = "ENTRY_ID"
		 
		Task{
			try? await endpointContainer?.startListening()
		}
		 
		let registrationErrors = endpointSession?.registerCallbacksInBulk(
			[
				PMXEventCallbackRegistration(
					request: .inbox(
						eventType: privmx.endpoint.inbox.INBOX_CREATE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a new inbox created
					}),
				PMXEventCallbackRegistration(
					request: .inbox(
						eventType: privmx.endpoint.inbox.INBOX_UPDATE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when an inbox is updated
					}),
				PMXEventCallbackRegistration(
					request: .inbox(
						eventType: privmx.endpoint.inbox.INBOX_UPDATE,
						selectorType: .Container,
						selectorId: inboxId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when an inbox is updated
					}),
				PMXEventCallbackRegistration(
					request: .inbox(
						eventType: privmx.endpoint.inbox.INBOX_DELETE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when an inbox is deleted
					}),
				PMXEventCallbackRegistration(
					request: .inbox(
						eventType: privmx.endpoint.inbox.INBOX_DELETE,
						selectorType: .Container,
						selectorId: inboxId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when an inbox is deleted
					}),
				PMXEventCallbackRegistration(
					request: .inbox(
						eventType: privmx.endpoint.inbox.COLLECTION_CHANGE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when any inbox's contents change
					}),
				PMXEventCallbackRegistration(
					request: .inbox(
						eventType: privmx.endpoint.inbox.COLLECTION_CHANGE,
						selectorType: .Container,
						selectorId: inboxId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a particular inbox's contents change
					}),
				PMXEventCallbackRegistration(
					request: .inbox(
						eventType: privmx.endpoint.inbox.ENTRY_CREATE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions on any new entry
					}),
				PMXEventCallbackRegistration(
					request: .inbox(
						eventType: privmx.endpoint.inbox.ENTRY_CREATE,
						selectorType: .Container,
						selectorId: inboxId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions on new entry in a particular inbox
					}),
				PMXEventCallbackRegistration(
					request: .inbox(
						eventType: privmx.endpoint.inbox.ENTRY_DELETE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when any entry is deleted
					}),
				PMXEventCallbackRegistration(
					request: .inbox(
						eventType: privmx.endpoint.inbox.ENTRY_DELETE,
						selectorType: .Container,
						selectorId: inboxId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a entry in a particular inbox is deleted
					}),
				PMXEventCallbackRegistration(
					request: .inbox(
						eventType: privmx.endpoint.inbox.ENTRY_DELETE,
						selectorType: .Item,
						selectorId: entryId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a particular entry is deleted
					})
			])
		
	}
}
