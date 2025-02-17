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
    struct ThreadPublicMeta: Codable {
        let tags: [String]
    }

    func createThread(contextId: String) throws {
        
                    
        let users = [privmx.endpoint.core.UserWithPubKey]() //should be prepared by developer
        let managers = [privmx.endpoint.core.UserWithPubKey]() //should be prepared by developer
        let publicMeta = Data()
        let privateMeta = Data()

        _ = try? endpointSession?.threadApi?.createThread(
            in: contextId,
            for: users,
            managedBy: managers,
            withPublicMeta: publicMeta,
            withPrivateMeta: privateMeta,
            withPolicies: nil
           )
       }
    
    func createThreadWithName(contextId: String) throws {
         
        let users = [privmx.endpoint.core.UserWithPubKey]() //should be prepared by developer
        let managers = [privmx.endpoint.core.UserWithPubKey]() //should be prepared by developer
        guard let publicMeta = "Title".data(using: .utf8) else {return}
        let privateMeta = Data()

        _ = try? endpointSession?.threadApi?.createThread(
            in: contextId,
            for: users,
            managedBy: managers,
            withPublicMeta: publicMeta,
            withPrivateMeta: privateMeta,
            withPolicies: nil)
    }
    
    func createThreadWithMeta(contextId: String) throws {
         
       
        struct ThreadPublicMeta: Codable{
            let tags: [String]
        }
        
                
        let users = [privmx.endpoint.core.UserWithPubKey]() //should be prepared by developer
        let managers = [privmx.endpoint.core.UserWithPubKey]() //should be prepared by developer
        let threadPublicMeta = ThreadPublicMeta(tags: ["TAG1","TAG2","TAG3"])
        guard let privateMeta = "Title".data(using: .utf8) else {return}
        guard let publicMeta = try? JSONEncoder().encode(threadPublicMeta) else {return}

        _ = try? endpointSession?.threadApi?.createThread(
            in: contextId,
            for: users,
            managedBy: managers,
            withPublicMeta: publicMeta,
            withPrivateMeta: privateMeta,
            withPolicies: nil)
    }
    
    
    func gettingMostRecentThreads(contextId: String) throws {
         
       
        var startIndex:Int64 = 0
        var pageSize:Int64 = 100
        
        guard let pagingList = try? endpointSession?.threadApi?
        .listThreads(
            from:contextId,
            basedOn: .init(skip: startIndex, limit: pageSize, sortOrder: .desc)) else {return}

        let threads = pagingList.readItems.map { $0 }
    }
    
    func gettingOldestThreads(contextId: String) throws {

         
       
        var startIndex:Int64 = 0
        var pageSize:Int64 = 100
                
        guard let pagingList = try? endpointSession?.threadApi?
        .listThreads(
            from:contextId,
            basedOn: .init(skip: startIndex, limit: pageSize, sortOrder: .asc)) else {return}

        let threads =
        pagingList.readItems.map { $0 }

    }
    
    func gettingThreadByThreadID(contextId: String) throws  {
         
       
        var threadID = "THREAD_ID"
        
        guard let thread = try? endpointSession?.threadApi?
            .getThread(threadID) else {return}
        
    }
    
    func renameThread(contextId:String) throws{
         
       
        struct ThreadPublicMeta:Codable{
            let tags: [String]
        }
        var threadID = "THREAD_ID"

                
        let threadPublicMeta = ThreadPublicMeta(tags: ["TAG1","TAG2","TAG3"])
        guard let publicMeta = try? JSONEncoder().encode(threadPublicMeta) else {return}
        guard let thread = try? endpointSession?.threadApi?
            .getThread(threadID) else {return}

        //users list to be extracted from thread
        let users = thread.users.map{
            //Your application must provide a way,
            //to get user's public key from their userId.
            privmx.endpoint.core.UserWithPubKey(userId: $0, pubKey: "PUB")
        }
        //managers list to be extracted from thread
        let managers = thread.managers.map{
            //Your application must provide a way,
            //to get user's public key from their userId.
            privmx.endpoint.core.UserWithPubKey(userId: $0, pubKey: "PUB")
        }

        guard let newPrivateMeta = "New thread name".data(using: .utf8) else {return}

        _ = try? endpointSession?.threadApi?.updateThread(
            threadID,
            atVersion: thread.version,
            replacingUsers: users,
            replacingManagers: managers,
            replacingPublicMeta: thread.publicMeta.getData() ?? Data(),
            replacingPrivateMeta: newPrivateMeta,
            force:false,
            forceGenerateNewKey: false,
            replacingPolicies: nil)

    }
     
    func removingUsers(contextId:String) throws{
         
       
        struct ThreadPublicMeta:Codable{
            let tags: [String]
        }
        var threadID = "THREAD_ID"
                
        let threadPublicMeta = ThreadPublicMeta(tags: ["TAG1","TAG2","TAG3"])
        guard let publicMeta = try? JSONEncoder().encode(threadPublicMeta) else {return}
        guard let thread = try? endpointSession?.threadApi?
            .getThread(threadID) else {return}

        //users list to be extracted from thread
        let users = thread.users.filter{
            $0 != "username-to-remove"
        }.map{
            //Your application must provide a way,
            //to get user's public key from their userId.
            privmx.endpoint.core.UserWithPubKey(userId: $0, pubKey: "PUB")
        }
        //managers list to be extracted from thread
        let managers = thread.managers.map{
            //Your application must provide a way,
            //to get user's public key from their userId.
            privmx.endpoint.core.UserWithPubKey(userId: $0, pubKey: "PUB")
        }

        guard let newPrivateMeta = "New thread name".data(using: .utf8) else {return}

        _ = try? endpointSession?.threadApi?.updateThread(
            threadID,
            atVersion: thread.version,
            replacingUsers: users,
            replacingManagers: managers,
            replacingPublicMeta: thread.publicMeta.getData() ?? Data(),
            replacingPrivateMeta: newPrivateMeta,
            force:false,
            forceGenerateNewKey: false,
            replacingPolicies: nil)

    }
    
    func deletingThread() throws {
         
       
        var threadID = "THREAD_ID"

        try? endpointSession?.threadApi?.deleteThread(threadID)
    }
    
}
