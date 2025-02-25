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
    
    
    func startListening(){
        Task{
            try? await endpointContainer?.startListening()
        }
    }
    
    func addEventListener(){
        var storeId = "STORE_ID"
        _ = try? endpointSession?.registerCallback(
            for: privmx.endpoint.store.StoreFileUpdatedEvent.self,
            from: EventChannel.storeFiles(storeID: storeId), identified: "some_id"
        ) {
            eventData in
        }
    }
    
    func removeEventListener(){
        var storeId = "STORE_ID"
        guard let callbackId = try? endpointSession?.registerCallback(
            for: privmx.endpoint.store.StoreFileUpdatedEvent.self,
            from: EventChannel.storeFiles(storeID: storeId), identified: "some_id",
            { eventData in
            }
        ) else {return}

        endpointContainer?.getEndpoint(endpointId)?.deleteCallbacks(identified: "some_id")
        
    }
    
    func unregisterCallbacks(){
        endpointContainer?.getEndpoint(endpointId)?.clearCallbacks(for: .platform )


    }
    
    func unregisterAllCallbacks(){
        endpointContainer?.getEndpoint(endpointId)?.clearAllCallbacks()
    }
    
    
}
