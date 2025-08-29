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
        try? endpointSession?.registerCallback(
			for: .init(
				cb: {
					eventData in
					// some actions to take
				},
				request: .store(eventType: privmx.endpoint.store.StoreCreatedEvent.self,
								selectorType: PMXEventSelectorType.Context,
								selectorId: CONTEXT_ID),
				group: "some_group")
        )
    }
    
	func removeEventListenerByGroup(){
		var storeId = "STORE_ID"
		do{
			try endpointSession?.registerCallback(
				for: .init(
					cb: {
						eventData in
						// some actions to take
					},
					request: .store(eventType: privmx.endpoint.store.StoreFileCreatedEvent.self,
									selectorType: PMXEventSelectorType.Container,
									selectorId: storeId),
					group: "some_group")
			)
			
			try endpointContainer?.getEndpoint(endpointId)?.clearCallbacks(in: "some_group")
		} catch {
			print(error)
		}
		
	}
    
	func unregisterCallbacksByRequest(){
		let threadId = "THREAD_ID"
		try? endpointContainer?.getEndpoint(endpointId)?.clearCallbacks(
			for: .thread(
				eventType: privmx.endpoint.thread.ThreadMessageUpdatedEvent.self,
				selectorType: PMXEventSelectorType.Container,
				selectorId: threadId))
	}
    
    func unregisterAllCallbacks(){
		try? endpointContainer?.getEndpoint(endpointId)?.clearAllCallbacks()
    }
    
    
}
