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


struct MessagePublicMeta:Codable{
    let responseTo: String
}
struct MessageData:Codable{
    let content: String
    let type: String
}
struct MessageItem:Codable{
    let messageId: String
    let publicMeta: MessagePublicMeta?
    let data: MessageData?
}



extension PrivMXSnippetClass {

    /// Sends a plain text message into the specified thread.
    func sendPlainTextMessage() throws {
        let threadId = "SOME_THREAD_ID"
        guard let messageData = "".data(using: .utf8) else {return}
        // In this example, both publicMeta and privateMeta are empty.
        let messageID = try? endpointSession?.threadApi?.sendMessage(
            in: threadId,
            withPublicMeta: Data(),
            withPrivateMeta: Data(),
            containing: messageData)
        
    }
    func sendPlainTextMessage2() throws {
        let threadId = "SOME_THREAD_ID"
        guard let messageData = "This is my message".data(using: .utf8) else {return}
        guard let privateMeta = "This is my private Meta".data(using: .utf8) else {return}
        guard let publicMeta = "This is my public Meta".data(using: .utf8) else {return}
        let messageID = try? endpointSession?.threadApi?.sendMessage(
            in: threadId,
            withPublicMeta: publicMeta,
            withPrivateMeta: privateMeta,
            containing: messageData)
        
    }
    
    func sendPlainTextMessageWithMeta()  throws {
        let threadId = "SOME_THREAD_ID"
        
        //As an example we can put in publicMeta a reference to message we are respoding to
        //This structure is entirely optional and is contingent upon the developer’s decisions.
        let messsageIdToRespond = "MESSAGE_ID_TO_RESPOND"
        struct MessagePublicMeta:Codable{
            let responseTo: String
        }
        
        guard let messageData = "Message text".data(using: .utf8) else {return}

        let publicMeta = MessagePublicMeta(responseTo: messsageIdToRespond)
        guard let publicMetaData = try? JSONEncoder().encode(publicMeta) else {return}

        let messageID = try? endpointSession?.threadApi?
            .sendMessage(in: threadId,
                            withPublicMeta: publicMetaData,
                            withPrivateMeta:  Data(),
                            containing: messageData)

    }
    
    
    
    
    /// Retrieves a specific message by its messageID.
    func getMessageByID() throws {
        let messageId = "MESSAGE_ID"
        guard let message = try? endpointSession?.threadApi?
        .getMessage(messageId) else {return}

        let messageItem =
            MessageItem(
                messageId: message.id,
                publicMeta: try? JSONDecoder().decode(MessagePublicMeta.self, from: message.publicMeta.getData() ?? Data()),
                data: try? JSONDecoder().decode(MessageData.self, from: message.data.getData() ?? Data()))





    }
    
    /// Lists messages within a thread using pagination.
    func listMessagesInThread()  throws {
        let threadId = "THREAD_ID"
        let startIndex:Int64 = 0
        let pageSize:Int64 = 100
         
        guard let pagingList = try? endpointSession?.threadApi?
            .listMessages(
                from:threadId,
                basedOn: .init(skip: startIndex, limit: pageSize, sortOrder: .desc)) else {return}

        let messages =
            pagingList.readItems.map {
                
                MessageItem(messageId: $0.id,
                        publicMeta: try? JSONDecoder().decode(MessagePublicMeta.self, from: $0.publicMeta.getData() ?? Data()),
                        data: try? JSONDecoder().decode(MessageData.self, from: $0.data.getData() ?? Data()))
                
            }
    }
    
    /// Lists messages within a thread using pagination.
    func listOldestMessagesInThread()  throws {
        let threadId = "THREAD_ID"
        let startIndex:Int64 = 0
        let pageSize:Int64 = 100
        
        guard let pagingList = try? endpointSession?.threadApi?
            .listMessages(
                from:threadId,
                basedOn: .init(skip: startIndex, limit: pageSize, sortOrder: .asc)) else {return}

        let messages =
            pagingList.readItems.map {
            MessageItem(messageId: $0.id,
                    publicMeta: try? JSONDecoder().decode(MessagePublicMeta.self, from: $0.publicMeta.getData() ?? Data()),
                    data: try? JSONDecoder().decode(MessageData.self, from: $0.data.getData() ?? Data()))
            
            }
    }
    
    /// Updates an existing message with new content.
    func updateMessage() throws {
        
        
        var messageId = "MESSAGE_ID"
         
        guard let message = try? endpointSession?.threadApi?
            .getMessage(messageId) else {return}
        let newMessage = MessageData(content: "Hello World", type: "text")
        guard let newMessageData = try?  JSONEncoder().encode(newMessage) else {return}
        guard let privateMeta = message.privateMeta.getData() else {return}
        guard let publicMeta = message.publicMeta.getData() else {return}

        try? endpointSession?.threadApi?
            .updateMessage(message.id,
                            replacingData: newMessageData ,
                            replacingPublicMeta: privateMeta,
                            replacingPrivateMeta: publicMeta)


    }
    
    /// Deletes a message identified by its messageID.
    func deleteMessage() throws {
         
        var messageId = "MESSAGE_ID"
        try? endpointSession?.threadApi?.deleteMessage(messageId)
    }
}
