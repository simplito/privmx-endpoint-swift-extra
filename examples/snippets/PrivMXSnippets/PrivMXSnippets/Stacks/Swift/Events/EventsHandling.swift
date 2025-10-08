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

	func handlingConnectionEvents(){
		let request : PMXEventSubscriptionRequest = PMXEventSubscriptionRequest.library(
			eventType:LibEventType.LIB_CONNECTED)
		
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: request,
				group: "SOME_GROUP",
				cb: {_ in
					// Some actions to perform after connecting
				}))
		
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .library(
					eventType: .LIB_DISCONNECTED),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when lib disconnects
				}))
		
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .library(
					eventType: .LIB_PLATFORM_DISCONNECTED),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when disconect method was called
				}))
	}
    
    func handlingThreadEvents(){		
		let threadId = "THREAD_ID"
		
        try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .thread(
					eventType: privmx.endpoint.thread.THREAD_CREATE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
                // some actions when a new thread created
            }))
            
        try? endpointSession?.registerCallback(
            for: PMXEventCallbackRegistration(
				request: .thread(
					eventType: privmx.endpoint.thread.THREAD_UPDATE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
                // some actions when a thread is updated
            }))
		
		try? endpointSession?.registerCallback(
            for: PMXEventCallbackRegistration(
				request: .thread(
					eventType: privmx.endpoint.thread.THREAD_UPDATE,
					selectorType: .Container,
					selectorId: threadId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
                // some actions when a thread is updated
            }))

        try? endpointSession?.registerCallback(
            for: PMXEventCallbackRegistration(
				request: .thread(
					eventType: privmx.endpoint.thread.THREAD_STATS,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
                // some actions when a thread's stats change
            }))
		try? endpointSession?.registerCallback(
            for: PMXEventCallbackRegistration(
				request: .thread(
					eventType: privmx.endpoint.thread.THREAD_STATS,
					selectorType: .Container,
					selectorId: threadId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
                // some actions when a thread's stats change
            }))
            
        try? endpointSession?.registerCallback(
            for: PMXEventCallbackRegistration(
				request: .thread(
					eventType: privmx.endpoint.thread.THREAD_DELETE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
                // some actions when a thread is deleted
            }))
		try? endpointSession?.registerCallback(
            for: PMXEventCallbackRegistration(
				request: .thread(
					eventType: privmx.endpoint.thread.THREAD_DELETE,
					selectorType: .Container,
					selectorId: threadId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
                // some actions when a thread is deleted
            }))
		
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .thread(
					eventType: privmx.endpoint.thread.COLLECTION_CHANGE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when any thread's contents change
			}))
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .thread(
					eventType: privmx.endpoint.thread.COLLECTION_CHANGE,
					selectorType: .Container,
					selectorId: threadId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when a particular thread's contents change
			}))
    }
    
	func handlingMessagesEvents(){
		let threadId = "THREAD_ID"
		let messageId = "MESSAGE_ID"
		
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .thread(
					eventType: privmx.endpoint.thread.MESSAGE_CREATE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions on new message
				}))
		
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .thread(
					eventType: privmx.endpoint.thread.MESSAGE_CREATE,
					selectorType: .Container,
					selectorId: threadId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions on new message in a particular thread
				}))
		
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .thread(
					eventType: privmx.endpoint.thread.MESSAGE_UPDATE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when a message is updated
				}))
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .thread(
					eventType: privmx.endpoint.thread.MESSAGE_UPDATE,
					selectorType: .Container,
					selectorId: threadId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when a message is updated in a particular thread
				}))
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .thread(
					eventType: privmx.endpoint.thread.MESSAGE_UPDATE,
					selectorType: .Item,
					selectorId: messageId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when a message is updated
				}))
	
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .thread(
					eventType: privmx.endpoint.thread.MESSAGE_DELETE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when a message is deleted
				}))
		
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .thread(
					eventType: privmx.endpoint.thread.MESSAGE_DELETE,
					selectorType: .Container,
					selectorId: threadId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when a message is deleted in a particular thread
				}))
		
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .thread(
					eventType: privmx.endpoint.thread.MESSAGE_DELETE,
					selectorType: .Item,
					selectorId: messageId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when a particular message is deleted
				}))
	}
    
    func handlingStoresEvents(){
		let storeId = "STORE_ID"
		
        try? endpointSession?.registerCallback(
            for:PMXEventCallbackRegistration(
				request: .store(
					eventType: privmx.endpoint.store.STORE_CREATE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
                // some actions when a new store is created
            }))

        try? endpointSession?.registerCallback(
            for:PMXEventCallbackRegistration(
				request: .store(
					eventType: privmx.endpoint.store.STORE_UPDATE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when any store is updated
			}))
		
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .store(
					eventType: privmx.endpoint.store.STORE_UPDATE,
					selectorType: .Container,
					selectorId: storeId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when a particular store is updated
			}))
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .store(
					eventType: privmx.endpoint.store.STORE_DELETE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when any store is deleted
			}))
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .store(
					eventType: privmx.endpoint.store.STORE_DELETE,
					selectorType: .Container,
					selectorId: storeId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when a particular store is deleted
			}))
		
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .store(
					eventType: privmx.endpoint.store.STORE_STATS,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when any store's stats change
			}))
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .store(
					eventType: privmx.endpoint.store.STORE_STATS,
					selectorType: .Container,
					selectorId: storeId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when a particular store's stats change
			}))
		
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .store(
					eventType: privmx.endpoint.store.COLLECTION_CHANGE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when any store's contents change
			}))
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .store(
					eventType: privmx.endpoint.store.COLLECTION_CHANGE,
					selectorType: .Container,
					selectorId: storeId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when a particular store's contents change
			}))
    }
    
    func handlingFilesEvents(){
        
        let storeId = "STORE_ID"
		let fileId = "FILE_ID"
		
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .store(
					eventType: privmx.endpoint.store.FILE_CREATE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when a file is cerated
				}))
		
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .store(
					eventType: privmx.endpoint.store.FILE_CREATE,
					selectorType: .Container,
					selectorId: storeId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions on new file in a particular store
				}))
		
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .store(
					eventType: privmx.endpoint.store.FILE_UPDATE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when a file is updated
				}))
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .store(
					eventType: privmx.endpoint.store.FILE_UPDATE,
					selectorType: .Container,
					selectorId: storeId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when a file is updated in a particular store
				}))
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .store(
					eventType: privmx.endpoint.store.FILE_UPDATE,
					selectorType: .Item,
					selectorId: fileId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when a file is updated
				}))
	
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .store(
					eventType: privmx.endpoint.store.FILE_DELETE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when a file is deleted
				}))
		
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .store(
					eventType: privmx.endpoint.store.FILE_DELETE,
					selectorType: .Container,
					selectorId: storeId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when a file is deleted in a particular store
				}))
		
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .store(
					eventType: privmx.endpoint.store.FILE_DELETE,
					selectorType: .Item,
					selectorId: fileId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when a particular message is deleted
				}))
       
    }
    
    func handlingInboxesEvents(){
        
		let inboxId = "INBOX_ID"
		
        try? endpointSession?.registerCallback(
            for: PMXEventCallbackRegistration(
				request: .inbox(
					eventType: privmx.endpoint.inbox.INBOX_CREATE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when a new inbox is created
				}))
            
        try? endpointSession?.registerCallback(
            for: PMXEventCallbackRegistration(
				request: .inbox(
					eventType: privmx.endpoint.inbox.INBOX_UPDATE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when any inbox is updated
				}))

        try? endpointSession?.registerCallback(
            for: PMXEventCallbackRegistration(
				request: .inbox(
					eventType: privmx.endpoint.inbox.INBOX_UPDATE,
					selectorType: .Container,
					selectorId: inboxId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when a particular inbox is updated
				}))
		
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .inbox(
					eventType: privmx.endpoint.inbox.INBOX_DELETE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when any inbox is deleted
				}))

		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .inbox(
					eventType: privmx.endpoint.inbox.INBOX_DELETE,
					selectorType: .Container,
					selectorId: inboxId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when a particular inbox is deleted
				}))
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .inbox(
					eventType: privmx.endpoint.inbox.COLLECTION_CHANGE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when any inbox's contents chenge
				}))

		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .inbox(
					eventType: privmx.endpoint.inbox.COLLECTION_CHANGE,
					selectorType: .Container,
					selectorId: inboxId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when a particular inbox's contents change
				}))
    }
    
    func handlingEntriesEvents(){
        let inboxId = "INBOX_ID"
        let entryId = "ENTRY_ID"
		
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .inbox(
					eventType: privmx.endpoint.inbox.ENTRY_CREATE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when an inbox entry is created
			}))
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .inbox(
					eventType: privmx.endpoint.inbox.ENTRY_CREATE,
					selectorType: .Container,
					selectorId: inboxId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when an inbox entry is created in a particular inbox
			}))
		
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .inbox(
					eventType: privmx.endpoint.inbox.ENTRY_DELETE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when an inbox entry is deleted
			}))
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .inbox(
					eventType: privmx.endpoint.inbox.ENTRY_DELETE,
					selectorType: .Container,
					selectorId: inboxId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when an inbox entry is deleted in a particular inbox
			}))
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .inbox(
					eventType: privmx.endpoint.inbox.ENTRY_DELETE,
					selectorType: .Item,
					selectorId: entryId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when a particular inbox entry is deleted
			}))
    }

	func handlingKvdbsEvents(){
		let kvdbId = "KVDB_ID"
		
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .kvdb(
					eventType: privmx.endpoint.kvdb.KVDB_CREATE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when a new kvdb is created
			}))

		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .kvdb(
					eventType: privmx.endpoint.kvdb.KVDB_UPDATE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when any kvdb is updated
			}))
		
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .kvdb(
					eventType: privmx.endpoint.kvdb.KVDB_UPDATE,
					selectorType: .Container,
					selectorId: kvdbId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when a particular kvdb is updated
			}))
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .kvdb(
					eventType: privmx.endpoint.kvdb.KVDB_DELETE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when any kvdb is deleted
			}))
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .kvdb(
					eventType: privmx.endpoint.kvdb.KVDB_DELETE,
					selectorType: .Container,
					selectorId: kvdbId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when a particular kvdb is deleted
			}))
		
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .kvdb(
					eventType: privmx.endpoint.kvdb.KVDB_STATS,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when any kvdb's stats change
			}))
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .kvdb(
					eventType: privmx.endpoint.kvdb.KVDB_STATS,
					selectorType: .Container,
					selectorId: kvdbId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when a particular kvdb's stats change
			}))
		
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .kvdb(
					eventType: privmx.endpoint.kvdb.COLLECTION_CHANGE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when any kvdb's contents change
			}))
		try? endpointSession?.registerCallback(
			for:PMXEventCallbackRegistration(
				request: .kvdb(
					eventType: privmx.endpoint.kvdb.COLLECTION_CHANGE,
					selectorType: .Container,
					selectorId: kvdbId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
				// some actions when a particular kvdb's contents change
			}))
	}
    
    func handlingkvdbEntriesEvents(){
        let kvdbId = "KVDB_ID"
		let entryKey = "ENTRY_KEY"
                        
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .kvdb(
					eventType: privmx.endpoint.kvdb.ENTRY_CREATE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when new entry is created
				}))
		
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .kvdb(
					eventType: privmx.endpoint.kvdb.ENTRY_CREATE,
					selectorType: .Container,
					selectorId: kvdbId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when a new entry is created in a particular kvdb
				}))
		
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .kvdb(
					eventType: privmx.endpoint.kvdb.ENTRY_UPDATE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when an entry is updated
				}))
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .kvdb(
					eventType: privmx.endpoint.kvdb.ENTRY_UPDATE,
					selectorType: .Container,
					selectorId: kvdbId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when an entry is updated in a particular kvdb
				}))
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .kvdbEntry(
					eventType: privmx.endpoint.kvdb.ENTRY_UPDATE,
					kvdbId: kvdbId,
					entryKey: entryKey),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when an entry is updated
				}))
	
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .kvdb(
					eventType: privmx.endpoint.kvdb.ENTRY_DELETE,
					selectorType: .Context,
					selectorId: CONTEXT_ID),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when an entry is deleted
				}))
		
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .kvdb(
					eventType: privmx.endpoint.kvdb.ENTRY_DELETE,
					selectorType: .Container,
					selectorId: kvdbId),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when an entry is deleted in a particular kvdb
				}))
		
		try? endpointSession?.registerCallback(
			for: PMXEventCallbackRegistration(
				request: .kvdbEntry(
					eventType: privmx.endpoint.kvdb.ENTRY_DELETE,
					kvdbId: kvdbId,
					entryKey: entryKey),
				group: "SOME_UNIQUE_IDENTIFIER",
				cb:{ eventData in
					// some actions when a particular entry is deleted
				}))
    }
}
