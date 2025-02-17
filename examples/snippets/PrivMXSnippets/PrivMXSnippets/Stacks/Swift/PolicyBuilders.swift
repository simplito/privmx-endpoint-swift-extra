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
    
    func buildPolicy(){
        ContainerPolicyBuilder()
                .setUpdate(.all)
                .setGet(.all)
                .setItem(ItemPolicyBuilder()
                        .setUpdate(
                            .itemOwner
                            .or(.manager)
                            .or(.owner.and(.user)))
                        .setGet(.all)
                        .build())
                .build()
    }
    
    func buildPolicyWithoutItem(){
        ContainerPolicyBuilder()
            .setUpdate(.all)
            .setGet(.all)
            .buildWithoutItem()
    }
    
   func buildItemPolicy(){
        ItemPolicyBuilder()
            .setUpdate(
                .itemOwner
                .or(.manager)
                .or(.owner
                    .and(.user)
                    )
                )
            .setGet(.all)
            .build()
    }
    
}
