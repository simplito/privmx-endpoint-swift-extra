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
	
    public func manualUpload(){
        let storeID = "STORE_ID"
		let fileContentData = Data("Text file content".utf8)
		
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
	
	public func uploadWithHandlerSIO(){
        /*let storeID = "STORE_ID"
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

		 */
    }
		 
		 
	public func uploadWithHandlerBuffer(){
       /* let storeID = "STORE_ID"
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

    */}
    
    public func uploadWithFileMeta(){
       
        let storeID = "STORE_ID"
		let fileContentData = Data("Text file content".utf8)
		let filePrivateMeta = FilePrivateMeta(
			name: "Example text file",
			mimetype: "text/plain")
         
		guard let filePrivateMetaData = try? JSONEncoder().encode(filePrivateMeta)
		else {return}
         
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
        
        Task<String?,Error>{
            let storeID = "STORE_ID"
            
			let URL = URL(fileURLWithPath: "/path/to/file/Filename.txt")
			let fileSize:Int64 = 0 //to be provided by app
            let filePrivateMeta = FilePrivateMeta(
				name: "Filename.txt",
				mimetype: "text/plain")
            
			let fileHandle =  try FileHandle(forReadingFrom: URL)
			let filePrivateMetaData = try JSONEncoder().encode(filePrivateMeta)
			
           
			let newFileId = try await endpointSession?.startUploadingNewFile(
				fileHandle,
				to: storeID,
				withPublicMeta: Data(),
				withPrivateMeta: filePrivateMetaData,
				sized: fileSize)
			
			return newFileId
		}
		
    }
    
	public func uploadingForRW(){
		let storeID = "STORE_ID"
		let fileContentData = Data("Text file content".utf8)
		
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
	
	public func seekingInFile(){
		let fileId = "FILE_ID"
		guard let readHandle = try? endpointSession?.storeApi?.openFile(fileId)
		else {return}
		 
		try? endpointSession?.storeApi?.seekInFile(
			withHandle: readHandle,
			toPosition: 128)
	}
	
	public func readWriteFile(){
		//1
		let fileId = "FILE_ID_WITH_RW_SUPPORT"
		guard let rwHandle = try? endpointSession?.storeApi?.openFile(fileId) else {return}
		
		//2
		var readData = try? endpointSession?.storeApi?.readFromFile(withHandle: rwHandle, length: 128)
		
		//3
		try? endpointSession?.storeApi?.seekInFile(
			withHandle: rwHandle,
			toPosition: 64)

		//4
		try? endpointSession?.storeApi?.writeToFile(
				withHandle: rwHandle,
				uploading: Data("some new data".utf8),
				truncate: true)
		//5
		try? endpointSession?.storeApi?.closeFile(withHandle: rwHandle)
	}
	
	public func syncHandle(){
		let rwHandle = privmx.StoreFileHandle() // normally retrieved by opening a file
		
		try? endpointSession?.storeApi?.syncFile(withHandle: rwHandle)
		try? endpointSession?.storeApi?.seekInFile(
			withHandle: rwHandle,
			toPosition: 0)
		
		let newData = try? endpointSession?.storeApi?.readFromFile(
			withHandle: rwHandle,
			length: 79)
	}
	
    func gettingFilesMostRecent(){
        let startIndex:Int64 = 0
        let pageSize:Int64 = 100
        let storeId = "STORE_ID"
        guard let pagingList = try? endpointSession?.storeApi?
            .listFiles(
                from:storeId,
                basedOn: .init(
					skip: startIndex,
					limit: pageSize,
					sortOrder: .desc))
		else {return}

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
		let newFilePrivateMeta = FilePrivateMeta(name: "New Filename.txt", mimetype: "text/plain")
		
        guard let file = try? endpointSession?.storeApi?.getFile(fileID),
			  let newFilePrivateMetaData = try? JSONEncoder().encode(newFilePrivateMeta),
			  let filePublicMetaData = file.publicMeta.getData()
		else {return}
		
        try? endpointSession?.storeApi?
            .updateFileMeta(
				of: fileID,
				replacingPublicMeta:  filePublicMetaData,
				replacingPrivateMeta: newFilePrivateMetaData)
    }
    
	func overwritingFile(){
		Task{
			let fileID = "FILE_ID"
			let URL = URL(fileURLWithPath: "/path/to/file/Filename.txt")
			
			let newFilePrivateMeta = FilePrivateMeta(
				name: "New file title",
				mimetype: "text/plain")
			
			let fileHandle = try FileHandle(forReadingFrom: URL)
			let newFilePrivateMetaData = try JSONEncoder().encode(newFilePrivateMeta)
			guard let newFileSize = try URL.resourceValues(forKeys: [.fileSizeKey]).fileSize
			else {return}
			
			try await endpointSession?.startUploadingUpdatedFile(
				fileHandle,
				as: fileID,
				replacingPublicMeta: Data(),
				replacingPrivateMeta: newFilePrivateMetaData,
				replacingSize: Int64(newFileSize))
			
		}
	}
	
	func overwritingFileHandler(){
		let fileID = "FILE_ID"
		let URL = URL(fileURLWithPath: "/path/to/file/Filename.txt")
		
		let newFilePrivateMeta = FilePrivateMeta(
			name: "New file title",
			mimetype: "text/plain")
		
		guard let newFileSize = try? URL.resourceValues(forKeys: [.fileSizeKey]).fileSize,
			  let newFilePrivateMetaData = try? JSONEncoder().encode(newFilePrivateMeta),
			  let fileHandle = try? FileHandle(forReadingFrom: URL),
			  let storeApi = endpointSession?.storeApi
		else {return}
		
		let fileHandler = try? PrivMXStoreFileHandler.getStoreFileUpdater(
			for: fileID,
			withReplacement: fileHandle,
			using: storeApi,
			replacingPublicMeta: Data(),
			replacingPrivateMeta: newFilePrivateMetaData,
			replacingFileSize: Int64(newFileSize))
		
		while fileHandler?.hasDataLeft == true{
			try? fileHandler?.writeChunk()
		}
		
		try? fileHandler?.close()
	}
	
	func overwritingFileManual(){
		let fileID = "FILE_ID"
		let URL = URL(fileURLWithPath: "/path/to/file/Filename.txt")
		let chunkSize = 128*1024
		
		let newFilePrivateMeta = FilePrivateMeta(
			name: "New file title",
			mimetype: "text/plain")
		
		guard let newFileSize = try? URL.resourceValues(forKeys: [.fileSizeKey]).fileSize,
			  let newFilePrivateMetaData = try? JSONEncoder().encode(newFilePrivateMeta),
			  let fileHandle = try? FileHandle(forReadingFrom: URL),
			  let writeHandle = try? endpointSession?.storeApi?.updateFile(
				fileID,
				replacingPublicMeta: Data(),
				replacingPrivateMeta: newFilePrivateMetaData,
				replacingSize: Int64(newFileSize))
		else {return}
		
		while let chunk = try? fileHandle.read(upToCount: chunkSize), !chunk.isEmpty{
			try? endpointSession?.storeApi?.writeToFile(
				withHandle: writeHandle,
				uploading: chunk,
				truncate: false)
		}
		
		try? endpointSession?.storeApi?.closeFile(withHandle: writeHandle)
	}
	
	
	
    func deletingFile(){
        let fileID = "FILE_ID"
        try? endpointSession?.storeApi?.deleteFile(fileID)

    }
}
