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
	
	func eventsKvdbStart(){
		
		let kvdbId = "KVDB_ID"
		let entryKey = "ENTRY_KEY"
		
		Task{
			try? await endpointContainer?.startListening()
		}
		
		let registrationErrors = endpointSession?.registerCallbacksInBulk(
			[
				PMXEventCallbackRegistration(
					request: .kvdb(
						eventType: privmx.endpoint.kvdb.KVDB_CREATE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a new kvdb created
					}),
				PMXEventCallbackRegistration(
					request: .kvdb(
						eventType: privmx.endpoint.kvdb.KVDB_UPDATE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a kvdb is updated
					}),
				PMXEventCallbackRegistration(
					request: .kvdb(
						eventType: privmx.endpoint.kvdb.KVDB_UPDATE,
						selectorType: .Container,
						selectorId: kvdbId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a kvdb is updated
					}),
				PMXEventCallbackRegistration(
					request: .kvdb(
						eventType: privmx.endpoint.kvdb.KVDB_STATS,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a kvdb's stats change
					}),
				PMXEventCallbackRegistration(
					request: .kvdb(
						eventType: privmx.endpoint.kvdb.KVDB_STATS,
						selectorType: .Container,
						selectorId: kvdbId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a kvdb's stats change
					}),
				PMXEventCallbackRegistration(
					request: .kvdb(
						eventType: privmx.endpoint.kvdb.KVDB_DELETE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a kvdb is deleted
					}),
				PMXEventCallbackRegistration(
					request: .kvdb(
						eventType: privmx.endpoint.kvdb.KVDB_DELETE,
						selectorType: .Container,
						selectorId: kvdbId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a kvdb is deleted
					}),
				PMXEventCallbackRegistration(
					request: .kvdb(
						eventType: privmx.endpoint.kvdb.COLLECTION_CHANGE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when any kvdb's contents change
					}),
				PMXEventCallbackRegistration(
					request: .kvdb(
						eventType: privmx.endpoint.kvdb.COLLECTION_CHANGE,
						selectorType: .Container,
						selectorId: kvdbId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a particular kvdb's contents change
					}),
				PMXEventCallbackRegistration(
					request: .kvdb(
						eventType: privmx.endpoint.kvdb.ENTRY_CREATE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions on any new message
					}),
				PMXEventCallbackRegistration(
					request: .kvdb(
						eventType: privmx.endpoint.kvdb.ENTRY_CREATE,
						selectorType: .Container,
						selectorId: kvdbId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions on new message in a particular kvdb
					}),
				PMXEventCallbackRegistration(
					request: .kvdb(
						eventType: privmx.endpoint.kvdb.ENTRY_UPDATE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when any message is updated
					}),
				PMXEventCallbackRegistration(
					request: .kvdb(
						eventType: privmx.endpoint.kvdb.ENTRY_UPDATE,
						selectorType: .Container,
						selectorId: kvdbId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a message in a particular kvdb is updated
					}),
				PMXEventCallbackRegistration(
					request: .kvdbEntry(
						eventType: privmx.endpoint.kvdb.ENTRY_UPDATE,
						kvdbId: kvdbId,entryKey: entryKey),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a particular message is updated
					}),
				
				PMXEventCallbackRegistration(
					request: .kvdb(
						eventType: privmx.endpoint.kvdb.ENTRY_DELETE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when any message is deleted
					}),
				
				PMXEventCallbackRegistration(
					request: .kvdb(
						eventType: privmx.endpoint.kvdb.ENTRY_DELETE,
						selectorType: .Container,
						selectorId: kvdbId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a message in a particular kvdb is deleted
					}),
				PMXEventCallbackRegistration(
					request: .kvdbEntry(
						eventType: privmx.endpoint.kvdb.ENTRY_DELETE,
						kvdbId: kvdbId,entryKey: entryKey),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a particular message is deleted
					})
			])
		
	}
}
