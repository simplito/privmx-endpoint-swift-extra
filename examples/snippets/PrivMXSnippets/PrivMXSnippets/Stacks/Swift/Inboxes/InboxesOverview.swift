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


struct InboxPublicMeta:Codable{
    let tags: [String]
    //definition by developer
}



extension PrivMXSnippetClass {
 
    
    public func accessingInboxAPI() async{
         
        
        guard let endpointSession = try? await endpointContainer?.newEndpoint(enabling: [.inbox], connectingAs: USER1_PRIVATE_KEY, to: SOLUTION_ID, on: BRIDGE_URL ) else {return}
        endpointSession.inboxApi // instance of InboxApi

    }
    
    public func accessingInboxAPIPublic() async{
       
        
        guard let endpointSession = try? await endpointContainer?.newPublicEndpoint(enabling: [.inbox], to: SOLUTION_ID, on: BRIDGE_URL ) else {return}
        endpointSession.inboxApi // instance of Public InboxApi

    }
    
    
    public func creatingInboxes(contextId:String){
         
        let users = [privmx.endpoint.core.UserWithPubKey]() //should be prepared by developer
        let managers = [privmx.endpoint.core.UserWithPubKey]() //should be prepared by developer
        let publicMeta = Data()
        let privateMeta = Data()

        let inboxId = try? endpointSession?.inboxApi?.createInbox(
            in: contextId,
            for: users,
            managedBy: managers,
            withPublicMeta: publicMeta,
            withPrivateMeta: privateMeta,
            withFilesConfig: nil,
            withPolicies: nil
            )

    }
    
    public func creatingInboxesWithConfig(contextId:String){

        let privMXFilesConfig = privmx.endpoint.inbox.FilesConfig(
            minCount:0,
            maxCount:10,
            maxFileSize:500,
            maxWholeUploadSize:2000
            )


         
        let users = [privmx.endpoint.core.UserWithPubKey]() //should be prepared by developer
        let managers = [privmx.endpoint.core.UserWithPubKey]() //should be prepared by developer
        let publicMeta = Data()
        let privateMeta = Data()

        let inboxId = try? endpointSession?.inboxApi?.createInbox(
            in: contextId,
            for: users,
            managedBy: managers,
            withPublicMeta: publicMeta,
            withPrivateMeta: privateMeta,
            withFilesConfig:privMXFilesConfig,
            withPolicies: nil
            )



    }
    
    
    public func creatingInboxesWithName(contextId:String){
        
         
        let users = [privmx.endpoint.core.UserWithPubKey]() //should be prepared by developer
        let managers = [privmx.endpoint.core.UserWithPubKey]() //should be prepared by developer
        let publicMeta = Data()
        guard let privateMeta = "Inbox Name".data(using: .utf8) else {return}
        
        let inboxId = try? endpointSession?.inboxApi?.createInbox(
            in: contextId,
            for: users,
            managedBy: managers,
            withPublicMeta: publicMeta,
            withPrivateMeta: privateMeta,
            withFilesConfig:nil,
            withPolicies:nil
        )
        
    }
    public func creatingInboxesWithPublicMeta(contextId:String){
      
         
        let inboxPublicMeta = InboxPublicMeta(tags: ["TAG1","TAG2","TAG3"])
        
        let users = [privmx.endpoint.core.UserWithPubKey]() //should be prepared by developer
        let managers = [privmx.endpoint.core.UserWithPubKey]() //should be prepared by developer
        guard let inboxPublicMetaData =   try? JSONEncoder().encode(inboxPublicMeta) else {return}
        guard let privateMeta = "Inbox Name".data(using: .utf8) else {return}
        
        let inboxId = try? endpointSession?.inboxApi?.createInbox(
            in: contextId,
            for: users,
            managedBy: managers,
            withPublicMeta: inboxPublicMetaData,
            withPrivateMeta: privateMeta,
            withFilesConfig:nil,
            withPolicies:nil
        )
    }
    
    
    public func gettingMostRecentInboxes(contextId:String){
        let startIndex:Int64 = 0
        let pageSize:Int64 = 100
         
        guard let pagingList = try? endpointSession?.inboxApi?
            .listInboxes(
                from:contextId,
                basedOn: .init(skip: startIndex, limit: pageSize, sortOrder: .desc)) else {return}

        let inboxes = pagingList.readItems.map { $0 }
    }
    
    
    public func gettingOldestInboxes(contextId:String){
    
        let startIndex:Int64 = 0
        let pageSize:Int64 = 100
         
        guard let pagingList = try? endpointSession?.inboxApi?
            .listInboxes(
                from:contextId,
                basedOn: .init(skip: startIndex, limit: pageSize, sortOrder: .asc)) else {return}

        let inboxes = pagingList.readItems.map { $0 }
    }
    
    
    func gettingInboxById(){
        var inboxID = "INBOX_ID"

        guard let inbox = try? endpointSession?.inboxApi?
            .getInbox(inboxID) else {return}
    }
    
    
    func gettingPublicView(){
        

        let inboxID = "INBOX_ID"
        let inboxApi = endpointSession?.inboxApi
        guard let inboxPublicView = try? inboxApi?.getInboxPublicView(for: inboxID) else {return}
        guard let inboxPublicMetaData = inboxPublicView.publicMeta.getData() else {return}
        let inboxPublicMetaDecoded = try? JSONDecoder().decode(InboxPublicMeta.self, from: inboxPublicMetaData)
        



    }
    
    func renamingInbox(){
        let inboxId = "INBOX_ID"
        let inboxPublicMeta = InboxPublicMeta(tags: ["TAG1","TAG2","TAG3"])
        guard let publicMeta = try? JSONEncoder().encode(inboxPublicMeta) else {return}
        guard let inbox = try? endpointSession?.inboxApi?
            .getInbox(inboxId) else {return}

        //users list to be extracted from inbox
        let users = inbox.users.map{
            //Your application must provide a way,
            //to get user's public key from their userId.
            privmx.endpoint.core.UserWithPubKey(userId: $0, pubKey: "PUB")
        }
        //managers list to be extracted from inbox
        let managers = inbox.managers.map{
            //Your application must provide a way,
            //to get user's public key from their userId.
            privmx.endpoint.core.UserWithPubKey(userId: $0, pubKey: "PUB")
        }

        guard let newPrivateMeta = "New Inbox name".data(using: .utf8) else {return}
        guard let filesConfig:privmx.endpoint.inbox.FilesConfig = inbox.filesConfig.value else {return}

        _ = try? endpointSession?.inboxApi?.updateInbox(
            inboxId,
            replacingUsers: users,
            replacingManagers: managers,
            replacingPublicMeta: inbox.publicMeta.getData() ?? Data(),
            replacingPrivateMeta: newPrivateMeta,
            replacingFilesConfig: filesConfig,
            atVersion: inbox.version,
            force:false,
            forceGenerateNewKey: false,
            replacingPolicies:nil)


    }
    
    func removingInboxUser(){
        
        let inboxId = "INBOX_ID"

        let inboxPublicMeta = InboxPublicMeta(tags: ["TAG1","TAG2","TAG3"])
        guard let publicMeta = try? JSONEncoder().encode(inboxPublicMeta) else {return}
        guard let inbox = try? endpointSession?.inboxApi?
            .getInbox(inboxId) else {return}

        //users list to be extracted from inbox
        let users = inbox.users.filter{
            $0 != "username-to-remove"
        }.map{
            //Your application must provide a way,
            //to get user's public key from their userId.
            privmx.endpoint.core.UserWithPubKey(userId: $0, pubKey: "PUB")
        }
        //managers list to be extracted from inbox
        let managers = inbox.managers.map{
            //Your application must provide a way,
            //to get user's public key from their userId.
            privmx.endpoint.core.UserWithPubKey(userId: $0, pubKey: "PUB")
        }

        guard let newPrivateMeta = "New Inbox name".data(using: .utf8) else {return}
        guard let filesConfig:privmx.endpoint.inbox.FilesConfig = inbox.filesConfig.value else {return}

        _ = try? endpointSession?.inboxApi?.updateInbox(
            inboxId,
            replacingUsers: users,
            replacingManagers: managers,
            replacingPublicMeta: inbox.publicMeta.getData() ?? Data(),
            replacingPrivateMeta: newPrivateMeta,
            replacingFilesConfig: filesConfig,
            atVersion: inbox.version,
            force:false,
            forceGenerateNewKey: false,
            replacingPolicies:nil)



    }
    
    func deletingInbox(){
        let inboxID = "INBOX_ID"
         
        try? endpointSession?.inboxApi?.deleteInbox(inboxID)

    }
}
