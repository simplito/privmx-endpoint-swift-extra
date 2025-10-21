//
//  Downloading.swift
//  PrivMXSnippets
//
//  Created by Simplito on 14/10/2025.
//
import Foundation
import PrivMXEndpointSwiftNative
import PrivMXEndpointSwift
import PrivMXEndpointSwiftExtra

extension PrivMXSnippetClass{
	func uploadingStartSmall(){
		
		struct FilePrivateMeta:Codable{
			let name: String
			let mimetype: String
		}

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

		let newFileId = try? endpointSession?.storeApi?.closeFile(withHandle:storeFileHandle)
	}
	func uploadingStartStream(){
		
		struct FilePrivateMeta:Codable{
			let name: String
			let mimetype: String
		}
		
		Task{
			let storeID = "STORE_ID"
			let URL = URL(fileURLWithPath: "/path/to/file/Filename.txt")
			let filePrivateMeta = FilePrivateMeta(
				name: "Filename.txt",
				mimetype: "text/plain")
			
			guard let fileHandle =  try? FileHandle(forReadingFrom: URL),
				  let fileSize = try? URL.resourceValues(forKeys: [.fileSizeKey]).fileSize,
				  let filePrivateMetaData = try? JSONEncoder().encode(filePrivateMeta)
			else { return }
			
			let newFileId = try? await endpointSession?.startUploadingNewFile(
				fileHandle,
				to: storeID,
				withPublicMeta: Data(),
				withPrivateMeta: filePrivateMetaData,
				sized: Int64(fileSize))
		}
	}
}
