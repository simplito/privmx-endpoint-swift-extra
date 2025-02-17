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

struct StorePublicMeta:Codable{
    let tags: [String]
}

extension PrivMXSnippetClass {
    
    public func createStore(){
        let contextId = "CONTEXT_ID"
         
        let users = [privmx.endpoint.core.UserWithPubKey]() //should be prepared by developer
        let managers = [privmx.endpoint.core.UserWithPubKey]() //should be prepared by developer
        let publicMeta = Data()
        let privateMeta = Data()

        let storeId = try? endpointSession?.storeApi?
            .createStore(in: contextId,
                for: users,
                managedBy: managers,
                withPublicMeta: publicMeta,
                withPrivateMeta: privateMeta,
                withPolicies: nil)

    }
    
    public func createStoreWithName(){
        let contextId = "CONTEXT_ID"
         
        let users = [privmx.endpoint.core.UserWithPubKey]() //should be prepared by developer
        let managers = [privmx.endpoint.core.UserWithPubKey]() //should be prepared by developer
        let publicMeta = Data()
        guard let storeNameAsPrivateMeta =  "New store".data(using: .utf8) else {return}

        let storeId = try? endpointSession?.storeApi?
            .createStore(in: contextId,
                            for: users,
                            managedBy: managers,
                            withPublicMeta: publicMeta,
                         withPrivateMeta: storeNameAsPrivateMeta,
                         withPolicies: nil)



    }
    
    public func createStoreWithPublicMeta(){
        
        let contextId = "CONTEXT_ID"
         
        let users = [privmx.endpoint.core.UserWithPubKey]() //should be prepared by developer
        let managers = [privmx.endpoint.core.UserWithPubKey]() //should be prepared by developer

        let storePublicMeta = StorePublicMeta(tags: ["TAG1","TAG2","TAG3"])
        guard let storePublicMetaData = try? JSONEncoder().encode(storePublicMeta) else {return}

        guard let storeNameAsPrivateMeta =  "New store".data(using: .utf8) else {return}

        let storeId = try? endpointSession?.storeApi?
            .createStore(in: contextId,
                        for: users,
                        managedBy: managers,
                        withPublicMeta: storePublicMetaData,
                        withPrivateMeta: storeNameAsPrivateMeta,
                         withPolicies: nil)

        
    }
    
    public func gettingMostRecentStores(){
        var startIndex:Int64 = 0
        var pageSize:Int64 = 100

        let contextId = "CONTEXT_ID"

         
        guard let pagingList = try? endpointSession?.storeApi?
            .listStores(
                from:contextId,
                basedOn: .init(skip: startIndex, limit: pageSize, sortOrder: .asc)) else {return}

        let stores =
        pagingList.readItems.map { $0 }
    }
    
    public func gettingOldestStores(){
        var startIndex:Int64 = 0
        var pageSize:Int64 = 100

        let contextId = "CONTEXT_ID"

         
        guard let pagingList = try? endpointSession?.storeApi?
            .listStores(
                from:contextId,
                basedOn: .init(skip: startIndex, limit: pageSize, sortOrder: .desc)) else {return}

        let stores =
        pagingList.readItems.map { $0 }



    }
    public func gettingByStoreId(){
        var storeID = "STORE_ID"
                    
         
        guard let file = try? endpointSession?.storeApi?
            .getStore(storeID) else {return}

    }
    
    public func renamingStore(){
        var storeId = "STORE_ID"
                    
        guard let store = try? endpointSession?.storeApi?
            .getStore(storeId) else {return}

        //users list to be extracted from store
        let users = store.users
            .map{
            //Your application must provide a way,
            //to get user's public key from their userId.
            privmx.endpoint.core.UserWithPubKey(userId: $0, pubKey: "PUB")
        }
        //managers list to be extracted from store
        let managers = store.managers.map{
            //Your application must provide a way,
            //to get user's public key from their userId.
            privmx.endpoint.core.UserWithPubKey(userId: $0, pubKey: "PUB")
        }

        guard let newPrivateMeta = "New store name".data(using: .utf8) else {return}

        _ = try? endpointSession?.storeApi?.updateStore(
            storeId,
            atVersion: store.version,
            replacingUsers: users,
            replacingManagers: managers,
            replacingPublicMeta: store.publicMeta.getData() ?? Data(),
            replacingPrivateMeta: newPrivateMeta,
            force:false,
            forceGenerateNewKey: false,
            replacingPolicies:nil)

    }
    
    
    public func removingUser(){
        var storeId = "STORE_ID"
                    
        guard let store = try? endpointSession?.storeApi?
            .getStore(storeId) else {return}

        //users list to be extracted from store
        let users = store.users
            .filter{
                $0 != "username-to-remove"
            }
            .map{
            //Your application must provide a way,
            //to get user's public key from their userId.
            privmx.endpoint.core.UserWithPubKey(userId: $0, pubKey: "PUB")
        }
        //managers list to be extracted from store
        let managers = store.managers.map{
            //Your application must provide a way,
            //to get user's public key from their userId.
            privmx.endpoint.core.UserWithPubKey(userId: $0, pubKey: "PUB")
        }

        guard let newPrivateMeta = "New store name".data(using: .utf8) else {return}

        _ = try? endpointSession?.storeApi?.updateStore(
            storeId,
            atVersion: store.version,
            replacingUsers: users,
            replacingManagers: managers,
            replacingPublicMeta: store.publicMeta.getData() ?? Data(),
            replacingPrivateMeta: store.privateMeta.getData() ?? Data(),
            force:false,
            forceGenerateNewKey: false,
            replacingPolicies: nil)

    }
    
    public func deletingStore(){
        var storeId = "STORE_ID"
         
        try? endpointSession?.storeApi?.deleteStore(storeId)
    }
}
    
