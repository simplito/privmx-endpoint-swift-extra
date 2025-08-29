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
        
         
        let inboxID = "INBOX_ID"
        
        let inboxPublicEntry = InboxPublicEntry(
            name: "name",
            surname: "surname",
            email: "email",
            comment: "comment")
        
        guard let inboxPublicEntryData = try? JSONEncoder().encode(inboxPublicEntry) else {return}
        
		guard let inboxHandle = try? publicEndpointSession?.inboxApi?.prepareEntry(
			in: inboxID,
			containing: inboxPublicEntryData,
			attaching: [],
			publicKeyDerivedFrom: nil)  else {return}
        
        try? publicEndpointSession?.inboxApi?.sendEntry(inboxHandle)
        
    }
    
    
    public func sendingEntriesPublicFiles(solutionId:String,platformURL:String){
        
        
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
        
        
        guard let inboxFileHandle = try? publicEndpointSession?.inboxApi?.createFileHandle(
            withPublicMeta: Data(),
            withPrivateMeta: Data(),
            forSize: fileSize) else {return}
        
        //2
        
       

        guard let entryHandle = try? publicEndpointSession?.inboxApi?.prepareEntry(
            in: inboxID,
            containing: inboxPublicEntryData, //as in Basic Example
            attaching: [inboxFileHandle],
			publicKeyDerivedFrom: nil)  else {return}

        //3
        try? publicEndpointSession?.inboxApi?.writeToFile(inboxFileHandle, of: entryHandle, uploading: data)

        //4
        try? publicEndpointSession?.inboxApi?.sendEntry(entryHandle)


        
        
    }

    
    public func readingNewestEntries(){
        let inboxID = "INBOX_ID"
        let startIndex:Int64 = 0
        let pageSize:Int64 = 100

        var entires = try? endpointSession?.inboxApi?.listEntries(
            from: inboxID,
            basedOn: privmx.endpoint.core.PagingQuery(skip: startIndex, limit: pageSize, sortOrder: .desc)
        )
        
    }
    
    public func readingOldestEntries(){
        let inboxID = "INBOX_ID"
        let startIndex:Int64 = 0
        let pageSize:Int64 = 100

        var entires = try? endpointSession?.inboxApi?.listEntries(
            from: inboxID,
            basedOn: privmx.endpoint.core.PagingQuery(skip: startIndex, limit: pageSize, sortOrder: .asc)
        )
    }
    
    public func readingEntryFiles(){
        let inboxID = "INBOX_ID"
        let entryID = "ENTRY_ID"
        let startIndex:Int64 = 0
        let pageSize:Int64 = 100
        
        let inboxEntry = try? endpointSession?.inboxApi?.readEntry(entryID)

        var files =  inboxEntry?.files
        var filesContents = files.map { file in
            try? endpointSession?.inboxApi?.openFile("\(file[0].info.fileId)")
        }?.map{ fileHandle in
            var content = Data()
            var chunk : Data
            repeat {
                chunk = (try? endpointSession?.inboxApi?.readFromFile(withHandle: fileHandle, length: PrivMXStoreFileHandler.RecommendedChunkSize)) ?? Data()
                content.append(chunk)
            } while chunk.count == PrivMXStoreFileHandler.RecommendedChunkSize
            return content
        }



    }
}
