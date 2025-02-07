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


struct InboxPublicEntry:Codable{
    let name: String
    let surname: String
    let email: String
    let comment: String
}


extension PrivMXSnippetClass {
    
    public func sendingEntriesPublicBasic(solutionId:String,platformURL:String){
        
        guard var connection = try? Connection.connectPublic(to: solutionId, on: platformURL) as? Connection
        else {return}
        
        guard var storeApi = try? StoreApi.create(connection: &connection) else {return}
        guard var threadApi = try? ThreadApi.create(connection: &connection) else {return}
        guard let inboxApi = try? InboxApi.create(connection: &connection,
                                                  threadApi: &threadApi,
                                                  storeApi: &storeApi) else {return}
        
        let inboxID = "INBOX_ID"
        
        let inboxPublicEntry = InboxPublicEntry(
            name: "name",
            surname: "surname",
            email: "email",
            comment: "comment")
        
        guard let inboxPublicEntryData = try? JSONEncoder().encode(inboxPublicEntry) else {return}
        
        
        
        guard let inboxHandle = try? inboxApi.prepareEntry(in: inboxID, containing: inboxPublicEntryData, attaching: [], as: nil)  else {return}
        
        try? inboxApi.sendEntry(to: inboxHandle)
        
    }
    
    
    public func sendingEntriesPublicFiles(solutionId:String,platformURL:String){
        
        
       
        
        guard var connection = try? Connection.connectPublic(to: solutionId, on: platformURL) as? Connection
        else {return}
        
        guard var storeApi = try? StoreApi.create(connection: &connection) else {return}
        guard var threadApi = try? ThreadApi.create(connection: &connection) else {return}
        guard let inboxApi = try? InboxApi.create(connection: &connection,
                                                  threadApi: &threadApi,
                                                  storeApi: &storeApi) else {return}
        

        
        //1
        let inboxID = "INBOX_ID"
        
        let fileSize:Int64 = 0 // actual file size
        let data:Data = Data() // actual file data
        
        let inboxPublicEntry = InboxPublicEntry(
            name: "name",
            surname: "surname",
            email: "email",
            comment: "comment")
        
        guard let inboxPublicEntryData = try? JSONEncoder().encode(inboxPublicEntry) else {return}
        
        
        
        
        
        guard let inboxFileHandle = try? inboxApi.createFileHandle(
            publicMeta: privmx.endpoint.core.Buffer(),
            privateMeta: privmx.endpoint.core.Buffer(),
            fileSize: fileSize) else {return}
        
        //2
        
       

        guard let inboxHandle = try? inboxApi.prepareEntry(
            in: inboxID,
            containing: inboxPublicEntryData, //as in Basic Example
            attaching: [inboxFileHandle],
            as: nil)  else {return}

        //3
        try? inboxApi.writeToFile(inboxFileHandle, in: inboxHandle, uploading: data)

        try? inboxApi.closeFile(fileHandle: inboxFileHandle)

        //4
        try? inboxApi.sendEntry(to: inboxHandle)


        
        
    }

    
    public func readingNewestEntries(){
        let inboxID = "INBOX_ID"
        let startIndex:Int64 = 0
        let pageSize:Int64 = 100
         
        let inboxApi = endpointSession?.inboxApi

        var entires = try? inboxApi?.listEntries(
            from: inboxID,
            basedOn: privmx.endpoint.core.PagingQuery(skip: startIndex, limit: pageSize, sortOrder: .desc)
        )
        
    }
    
    public func readingOldestEntries(){
        let inboxID = "INBOX_ID"
        let startIndex:Int64 = 0
        let pageSize:Int64 = 100
         
        let inboxApi = endpointSession?.inboxApi

        var entires = try? inboxApi?.listEntries(
            from: inboxID,
            basedOn: privmx.endpoint.core.PagingQuery(skip: startIndex, limit: pageSize, sortOrder: .asc)
        )
    }
    
    public func readingEntryFiles(){
        let inboxID = "INBOX_ID"
        let entryID = "ENTRY_ID"
        let startIndex:Int64 = 0
        let pageSize:Int64 = 100
        
        
        let inboxApi = endpointSession?.inboxApi

        let inboxEntry = try? inboxApi?.readEntry(entryID)

        var files =  inboxEntry?.files
        var filesContents = files.map { file in
            try? inboxApi?.openFile("\(file[0].info.fileId)")
        }?.map{ fileHandle in
            var content = Data()
            var chunk : Data
            repeat {
                chunk = (try? inboxApi?.readFromFile(withHandle: fileHandle, length: PrivMXStoreFileHandler.RecommendedChunkSize)) ?? Data()
                content.append(chunk)
            } while chunk.count == PrivMXStoreFileHandler.RecommendedChunkSize
            return content
        }



    }
}
