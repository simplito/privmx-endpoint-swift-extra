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
	
	func eventsStoreStart(){
		
		let storeId = "STORE_ID"
		let fileId = "FILE_ID"
		
		Task{
			try? await endpointContainer?.startListening()
		}
		
		let registrationErrors = endpointSession?.registerCallbacksInBulk(
			[
				PMXEventCallbackRegistration(
					request: .store(
						eventType: privmx.endpoint.store.STORE_CREATE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a new store created
					}),
				PMXEventCallbackRegistration(
					request: .store(
						eventType: privmx.endpoint.store.STORE_UPDATE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a store is updated
					}),
				PMXEventCallbackRegistration(
					request: .store(
						eventType: privmx.endpoint.store.STORE_UPDATE,
						selectorType: .Container,
						selectorId: storeId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a store is updated
					}),
				PMXEventCallbackRegistration(
					request: .store(
						eventType: privmx.endpoint.store.STORE_STATS,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a store's stats change
					}),
				PMXEventCallbackRegistration(
					request: .store(
						eventType: privmx.endpoint.store.STORE_STATS,
						selectorType: .Container,
						selectorId: storeId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a store's stats change
					}),
				PMXEventCallbackRegistration(
					request: .store(
						eventType: privmx.endpoint.store.STORE_DELETE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a store is deleted
					}),
				PMXEventCallbackRegistration(
					request: .store(
						eventType: privmx.endpoint.store.STORE_DELETE,
						selectorType: .Container,
						selectorId: storeId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a store is deleted
					}),
				PMXEventCallbackRegistration(
					request: .store(
						eventType: privmx.endpoint.store.COLLECTION_CHANGE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when any store's contents change
					}),
				PMXEventCallbackRegistration(
					request: .store(
						eventType: privmx.endpoint.store.COLLECTION_CHANGE,
						selectorType: .Container,
						selectorId: storeId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a particular store's contents change
					}),
				PMXEventCallbackRegistration(
					request: .store(
						eventType: privmx.endpoint.store.FILE_CREATE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions on any new file
					}),
				PMXEventCallbackRegistration(
					request: .store(
						eventType: privmx.endpoint.store.FILE_CREATE,
						selectorType: .Container,
						selectorId: storeId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions on new file in a particular store
					}),
				PMXEventCallbackRegistration(
					request: .store(
						eventType: privmx.endpoint.store.FILE_UPDATE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when any file is updated
					}),
				PMXEventCallbackRegistration(
					request: .store(
						eventType: privmx.endpoint.store.FILE_UPDATE,
						selectorType: .Container,
						selectorId: storeId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a file in a particular store is updated
					}),
				PMXEventCallbackRegistration(
					request: .store(
						eventType: privmx.endpoint.store.FILE_UPDATE,
						selectorType: .Item,
						selectorId: fileId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a particular file is updated
					}),
				
				PMXEventCallbackRegistration(
					request: .store(
						eventType: privmx.endpoint.store.FILE_DELETE,
						selectorType: .Context,
						selectorId: CONTEXT_ID),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when any file is deleted
					}),
				
				PMXEventCallbackRegistration(
					request: .store(
						eventType: privmx.endpoint.store.FILE_DELETE,
						selectorType: .Container,
						selectorId: storeId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a file in a particular store is deleted
					}),
				PMXEventCallbackRegistration(
					request: .store(
						eventType: privmx.endpoint.store.FILE_DELETE,
						selectorType: .Item,
						selectorId: fileId),
					group: "SOME_UNIQUE_IDENTIFIER",
					cb:{ eventData in
						// some actions when a particular file is deleted
					})
			])
		
	}
}
