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
            ofSize: Int64(fileContentData.count),
			randomWriteSupport: false)
        else {return}
		try? endpointSession?.storeApi?.writeToFile(
			withHandle: storeFileHandle,
			uploading: fileContentData,
			truncate: false)
		let storeFileId = try? endpointSession?.storeApi?.closeFile(withHandle: storeFileHandle)

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
            ofSize: Int64(fileContentData.count),
			randomWriteSupport: false)
        else {return}

        try? endpointSession?.storeApi?.writeToFile(
			withHandle: storeFileHandle,
			uploading: fileContentData,
			truncate: false)
		
		let storeFileId = try? endpointSession?.storeApi?.closeFile(withHandle: storeFileHandle)

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
    
	public func uploadingForRW(){
		let storeID = "STORE_ID"
		guard let fileContentData = "Text file content".data(using: .utf8 ) else {return}
		guard let storeFileHandle = try? endpointSession?.storeApi?.createFile(
			in: storeID,
			withPublicMeta: Data(),
			withPrivateMeta: Data(),
			ofSize: Int64(fileContentData.count),
			randomWriteSupport: true)
		else {return}
		
		try? endpointSession?.storeApi?.writeToFile(
			withHandle: storeFileHandle,
			uploading: fileContentData,
			truncate: false)
		
		let storeFileId = try? endpointSession?.storeApi?.closeFile(withHandle: storeFileHandle)

	}
	
	public func readWriteFile(){
		let fileId = "FILE_ID_WITH_RR_SUPPORT"
		guard let rwHandle = try? endpointSession?.storeApi?.openFile(fileId) else {return}
		
		let readData = try? endpointSession?.storeApi?.readFromFile(withHandle: rwHandle, length: 128)
		
		try? endpointSession?.storeApi?.seekInFile(withHandle: rwHandle, toPosition: 64)
		try? endpointSession?.storeApi?.writeToFile(
				withHandle: rwHandle,
				uploading: Data("some new data".utf8),
				truncate: true)
	}
	
	public func syncHandle(){
		let rwHandle = privmx.StoreFileHandle() // normally retrieved by opening a file
		
		try? endpointSession?.storeApi?.syncFile(withHandle: rwHandle)
		try? endpointSession?.storeApi?.seekInFile(withHandle: rwHandle, toPosition: 0)
		
		let newData = try? endpointSession?.storeApi?.readFromFile(withHandle: rwHandle, length: 79)
	}
	
    func gettingFilesMostRecent(){
        let startIndex:Int64 = 0
        let pageSize:Int64 = 100
        let storeId = "STORE_ID"
        guard let pagingList = try? endpointSession?.storeApi?
            .listFiles(
                from:storeId,
                basedOn: .init(skip: startIndex, limit: pageSize, sortOrder: .desc)) else {return}

        let files = pagingList.readItems.map { $0 }
    }
	
	
    
    func getingFilesOldest(){
        let startIndex:Int64 = 0
        let pageSize:Int64 = 100
        let storeId = "STORE_ID"
        guard let pagingList = try? endpointSession?.storeApi?
            .listFiles(
                from:storeId,
                basedOn: .init(skip: startIndex, limit: pageSize, sortOrder: .asc)) else {return}

        let files = pagingList.readItems.map { $0 }
    }
    
    func gettingFilesByID(){
        let fileID = "FILE_ID"
        guard let file = try? endpointSession?.storeApi?
            .getFile(fileID) else {return}
    }
    
    
    func changingFilename(){

        let fileID = "FILE_ID"
        guard let file = try? endpointSession?.storeApi?
            .getFile(fileID) else {return}
        let newFilePrivateMeta = FilePrivateMeta(name: "New Filename.txt", mimetype: "text/plain")
        guard let newFilePrivateMetaData = try? JSONEncoder().encode(newFilePrivateMeta) else {return}
        guard let filePublicMetaData = file.publicMeta.getData() else {return}
        try? endpointSession?.storeApi?
            .updateFileMeta(
				of: fileID,
				replacingPublicMeta:  filePublicMetaData,
				replacingPrivateMeta: newFilePrivateMetaData)
    }
    
	func overwritingFile(){
		
		let fileID = "FILE_ID"
		let URL = URL(fileURLWithPath: "/path/to/file/Filename.txt")
		
		let newFilePrivateMeta = FilePrivateMeta(name: "New file title", mimetype: "text/plain")
		
		guard let fileHandle =  try? FileHandle(forReadingFrom: URL),
			  let newFilePrivateMetaData = try? JSONEncoder().encode(newFilePrivateMeta),
			  let storeApi = endpointSession?.storeApi,
			  let newFileSize = try? URL.resourceValues(forKeys: [.fileSizeKey]).fileSize else {return}
		
		guard let updater = try? PrivMXStoreFileHandler.getStoreFileUpdater(
			for: fileID,
			withReplacement: fileHandle,
			using: storeApi,
			replacingPublicMeta: Data(),
			replacingPrivateMeta: newFilePrivateMetaData,
			replacingFileSize: Int64(newFileSize),
			chunkSize: PrivMXStoreFileHandler.RecommendedChunkSize) else {return}
		
		while updater.hasDataLeft{
			try? updater.writeChunk()
		}
		
		try? updater.close()
	}
	
	
	
    func deletingFile(){
        let fileID = "FILE_ID"
        try? endpointSession?.storeApi?.deleteFile(fileID)

    }
}
