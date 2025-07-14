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
        try? endpointSession?.registerCallback(
            for: privmx.endpoint.core.LibConnectedEvent.self,
            from: .platform, identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when lib connect
            })
            
        try? endpointSession?.registerCallback(
            for: privmx.endpoint.core.LibDisconnectedEvent.self,
            from: .platform, identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when lib disconnects
            })
    }
    
    func handlingThreadEvents(){
        try? endpointSession?.registerCallback(
            for: privmx.endpoint.thread.ThreadCreatedEvent.self,
            from: .thread, identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when new thread created
            })
            
        try? endpointSession?.registerCallback(
            for: privmx.endpoint.thread.ThreadUpdatedEvent.self,
            from: .thread, identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when thread updated
            })

        try? endpointSession?.registerCallback(
            for: privmx.endpoint.thread.ThreadStatsChangedEvent.self,
            from: .thread, identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when  thread stats changes
            })
            
        try? endpointSession?.registerCallback(
            for: privmx.endpoint.thread.ThreadDeletedEvent.self,
            from: .thread, identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when thread deleted
            })
    }
    
    func handlingMessagesEvents(){
        var threadId = "THREAD_ID"
                        
        try? endpointSession?.registerCallback(
            for: privmx.endpoint.thread.ThreadNewMessageEvent.self,
            from: .threadMessages(threadID: threadId), identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions on new message
            })
            
        try? endpointSession?.registerCallback(
            for: privmx.endpoint.thread.ThreadMessageDeletedEvent.self,
            from: .threadMessages(threadID: threadId), identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when message deleted
            })

        try? endpointSession?.registerCallback(
            for: privmx.endpoint.thread.ThreadMessageDeletedEvent.self,
            from: .threadMessages(threadID: threadId), identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when message updated
            })



    }
    
    func handlingStoresEvents(){
        try? endpointSession?.registerCallback(
            for: privmx.endpoint.store.StoreCreatedEvent.self,
            from: .store, identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when new store created
            })
            
        try? endpointSession?.registerCallback(
            for: privmx.endpoint.store.StoreUpdatedEvent.self,
            from: .store, identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when store updated
            })

        try? endpointSession?.registerCallback(
            for: privmx.endpoint.store.StoreStatsChangedEvent.self,
            from: .store, identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when store stats changes
            })
            
        try? endpointSession?.registerCallback(
            for: privmx.endpoint.store.StoreDeletedEvent.self,
            from: .store, identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when store deleted
            })
    }
    
    func handlingFilesEvents(){
        
        var storeId = "STORE_ID"
                        
        try? endpointSession?.registerCallback(
            for: privmx.endpoint.store.StoreFileCreatedEvent.self,
            from: .storeFiles(storeID: storeId), identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions on new file
            })
            
        try? endpointSession?.registerCallback(
            for: privmx.endpoint.store.StoreFileUpdatedEvent.self,
            from: .storeFiles(storeID: storeId), identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when file updated
            })

        try? endpointSession?.registerCallback(
            for: privmx.endpoint.store.StoreFileDeletedEvent.self,
            from: .storeFiles(storeID: storeId), identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when message updated
            })


    }
    
    func handlingInboxesEvents(){
        
        try? endpointSession?.registerCallback(
            for: privmx.endpoint.inbox.InboxCreatedEvent.self,
            from: .inbox, identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when new inbox created
            })
            
        try? endpointSession?.registerCallback(
            for: privmx.endpoint.inbox.InboxUpdatedEvent.self,
            from: .inbox, identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when inbox updated
            })

        try? endpointSession?.registerCallback(
            for: privmx.endpoint.inbox.InboxDeletedEvent.self,
            from: .inbox, identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when inbox deleted
            })
    }
    
    func handlingEntriesEvents(){
        var inboxId = "INBOX_ID"
                        
        try? endpointSession?.registerCallback(
            for: privmx.endpoint.inbox.InboxEntryCreatedEvent.self,
            from: .inboxEntries(inboxID: inboxId), identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions on new inbox entry
            })
            
        try? endpointSession?.registerCallback(
            for: privmx.endpoint.inbox.InboxEntryDeletedEvent.self,
            from: .inboxEntries(inboxID: inboxId), identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when inbox entry deleted
            })
    }
	func handlingKvdbsEvents(){
        
        try? endpointSession?.registerCallback(
            for: privmx.endpoint.kvdb.KvdbCreatedEvent.self,
            from: .kvdb, identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when new kvdb created
            })
            
        try? endpointSession?.registerCallback(
            for: privmx.endpoint.kvdb.KvdbUpdatedEvent.self,
            from: .kvdb, identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when kvdb updated
            })

        try? endpointSession?.registerCallback(
            for: privmx.endpoint.kvdb.KvdbDeletedEvent.self,
            from: .kvdb, identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when kvdb updated
            })
    }
    
    func handlingEntriesEvents(){
        var kvdbId = "KVDB_ID"
                        
        try? endpointSession?.registerCallback(
            for: privmx.endpoint.kvdb.KvdbNewEntryEvent.self,
            from: .kvdbEntries(kvdbID: kvdbId), identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions on new kvdb entry
            })
		
		try? endpointSession?.registerCallback(
            for: privmx.endpoint.kvdb.KvdbUpdatedEvent.self,
            from: .kvdbEntries(kvdbID: kvdbId), identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions on new kvdb entry
            })
            
        try? endpointSession?.registerCallback(
            for: privmx.endpoint.kvdb.KvdbEntryDeletedEvent.self,
            from: .kvdbEntries(kvdbID: kvdbId), identified: "SOME_UNIQUE_IDENTIFIER",
            { eventData in
                // some actions when kvdb entry deleted
            })
    }
	
	
}
