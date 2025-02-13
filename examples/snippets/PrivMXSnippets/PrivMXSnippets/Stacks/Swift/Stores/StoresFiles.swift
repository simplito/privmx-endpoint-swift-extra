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

struct FilePrivateMeta:Codable{
    let name: String
    let mimetype: String
}


extension PrivMXSnippetClass {

    
    public func basicUpload(){
        let storeID = "STORE_ID"
        guard let fileContentData = "Text file content".data(using: .utf8 ) else {return}
        guard let storeFileHandle = try? endpointSession?.storeApi?.createFile(
            in: storeID,
            withPublicMeta: Data(),
            withPrivateMeta: Data(),
            ofSize: Int64(fileContentData.count))
        else {return}
        try? endpointSession?.storeApi?.writeToFile(withHandle: storeFileHandle, uploading: fileContentData)
    }
    
    public func uploadWithFileMeta(){
       
        let storeID = "STORE_ID"
        guard let fileContentData = "Text file content".data(using: .utf8 ) else {return}

        let filePrivateMeta = FilePrivateMeta(name: "Example text file", mimetype: "text/plain")
        guard let filePrivateMetaData = try? JSONEncoder().encode(filePrivateMeta) else {return}
        guard let storeFileHandle = try? endpointSession?.storeApi?.createFile(
            in: storeID,
            withPublicMeta: Data(),
            withPrivateMeta: filePrivateMetaData,
            ofSize: Int64(fileContentData.count))
        else {return}
        try? endpointSession?.storeApi?.writeToFile(withHandle: storeFileHandle, uploading: fileContentData)

    }
    
    public func uploadUsingSwiftIO(){
        
        Task{
            let storeID = "STORE_ID"
            let URL = URL(fileURLWithPath: "/path/to/file/Filename.txt")
            guard let fileHandle =  try? FileHandle(forReadingFrom: URL) else { return }
            let fileSize:Int64 = 0 //to be provided by app
            let filePrivateMeta = FilePrivateMeta(name: "Filename.txt", mimetype: "text/plain")
            guard let filePrivateMetaData = try? JSONEncoder().encode(filePrivateMeta) else {return}
            let newFileId = try? await endpointSession?.startUploadingNewFile(fileHandle,
                                        to: storeID,
                                        withPublicMeta: Data(),
                                        withPrivateMeta: filePrivateMetaData,
                                        sized: fileSize)
        }




    }
    
    func gettingFilesMostRecent(){
        let startIndex:Int64 = 0
        let pageSize:Int64 = 100
        let storeId = "STORE_ID"
        guard let pagingList = try? endpointSession?.storeApi?
            .listFiles(
                from:storeId,
                basedOn: .init(skip: startIndex, limit: pageSize, sortOrder: .desc)) else {return}

        let files =
        pagingList.readItems.map { $0 }
    }
    
    func getingFilesOldest(){
        let startIndex:Int64 = 0
        let pageSize:Int64 = 100
        let storeId = "STORE_ID"
        guard let pagingList = try? endpointSession?.storeApi?
            .listFiles(
                from:storeId,
                basedOn: .init(skip: startIndex, limit: pageSize, sortOrder: .asc)) else {return}

        let files =
        pagingList.readItems.map { $0 }
    }
    
    func gettingFilesByID(){
        let fileID = "FILE_ID"
        guard let file = try? endpointSession?.storeApi?
            .getFile(fileID) else {return}
    }
    
    
    func changingFilename(){
       
        var fileID = "FILE_ID"
        guard let file = try? endpointSession?.storeApi?
            .getFile(fileID) else {return}
        let newFilePrivateMeta = FilePrivateMeta(name: "New Filename.txt", mimetype: "text/plain")
        guard let newFilePrivateMetaData = try? JSONEncoder().encode(newFilePrivateMeta) else {return}
        guard let filePublicMetaData = file.publicMeta.getData() else {return}
        try? endpointSession?.storeApi?
            .updateFile(fileID,
                        replacingPublicMeta:  filePublicMetaData,
                        replacingPrivateMeta: newFilePrivateMetaData,
                        replacingSize: file.size)
    }
    
    func deletingFile(){
        var fileID = "FILE_ID"
        try? endpointSession?.storeApi?.deleteFile(fileID)


    }
}
