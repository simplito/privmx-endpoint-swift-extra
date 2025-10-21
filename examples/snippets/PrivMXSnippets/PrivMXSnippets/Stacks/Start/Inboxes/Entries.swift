//
// PrivMX Endpoint Swift Extra
// Copyright © 2025 Simplito sp. z o.o.
//
// This file is part of the PrivMX Platform (https://privmx.dev).
// This software is Licensed under the MIT License.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import PrivMXEndpointSwiftNative
import PrivMXEndpointSwiftExtra
import PrivMXEndpointSwift

extension PrivMXSnippetClass{
	func sendInboxEntryBasicStart(){
		//1
		struct EntryContent:Codable{
			let answer: String
		}
		struct InboxPublicEntry:Codable{
			let content: EntryContent
			let version: Int
			let type: String
		}
		 
		let response = InboxPublicEntry(
			content: EntryContent(answer: "USER PROVIDED TEXT"),
			version: 1,
			type: "text_answer")
		 
		guard let entryData = try? JSONEncoder().encode(response)
		else {return}
		 
		guard let entryHandle = try? publicEndpointSession?.inboxApi?.prepareEntry(
			in: "INBOX ID",
			containing: entryData,
			attaching: [],
			publicKeyDerivedFrom: nil)
		else {return}
		
		//2
		
		try? publicEndpointSession?.inboxApi?.sendEntry(entryHandle)
	}
	
	func sendInboxEntryFilesStart(){
		//1
		struct FilePrivateMeta:Codable{
			let name: String
			let mimetype: String
		}
		
		
		let filePrivateMeta = FilePrivateMeta(
			name: "FILE NAME",
			mimetype: "FILE MIMETYPE")
		
		let URL = URL(filePath: "/path/to/file")
		guard let privateMetaData = try? JSONEncoder().encode(filePrivateMeta),
			  let fileSize = try? URL.resourceValues(forKeys: [.fileSizeKey]).fileSize,
			  let fileHandle = try? publicEndpointSession?.inboxApi?.createFileHandle(
				withPublicMeta: Data(),
				withPrivateMeta: privateMetaData,
				forSize: Int64(fileSize))
		else{return}
		
		//2
		struct EntryContent:Codable{
			let answer: String
		}
		struct InboxPublicEntry:Codable{
			let content: EntryContent
			let version: Int
			let type: String
		}
		 
		let response = InboxPublicEntry(
			content: EntryContent(answer: "USER PROVIDED TEXT"),
			version: 1,
			type: "text_answer")
		 
		guard let entryData = try? JSONEncoder().encode(response)
		else {return}
		 
		guard let entryHandle = try? publicEndpointSession?.inboxApi?.prepareEntry(
			in: "INBOX ID",
			containing: entryData,
			attaching: [fileHandle],
			publicKeyDerivedFrom: nil)
		else {return}
		
		//3
		
		guard let fileData = try? FileHandle(forReadingFrom: URL)
		else {return}
		 
		while let chunk = try? fileData.read(upToCount: Int(PrivMXStoreFileHandler.RecommendedChunkSize)),
				!chunk.isEmpty{
			try? publicEndpointSession?.inboxApi?.writeToFile(
				fileHandle,
				of: entryHandle,
				uploading: chunk)
		}
		
		//4
		try? publicEndpointSession?.inboxApi?.sendEntry(entryHandle)
	}
	
	func listInboxEntriesStart(){
		
		let query = privmx.endpoint.core.PagingQuery(
			skip: 0,
			limit: 10,
			sortOrder: .desc)
		 
		let pagedList = try? endpointSession?.inboxApi?.listEntries(
			from: "INBOX_ID",
			basedOn: query)
		 
		let decodedEntries = pagedList?.readItems.map {
			return try? JSONDecoder().decode(
				InboxPublicEntry.self,
				from: Data(from:$0.data))
		}
	}
	
	func listEntriesWithFilesSwift (){
		let query = privmx.endpoint.core.PagingQuery(
			skip: 0,
			limit: 10,
			sortOrder: .desc)
		 
		let pagedList = try? endpointSession?.inboxApi?.listEntries(
			from: "INBOX_ID",
			basedOn: query)
		 
		let decodedEntries = pagedList?.readItems.map {
			return try? JSONDecoder().decode(
				InboxPublicEntry.self,
				from: Data(from:$0.data))
		}
	}
	
	func deleteInboxEntryStart(){
		try? endpointSession?.inboxApi?.deleteEntry("ID OF THE ENTRY")
	}
}
