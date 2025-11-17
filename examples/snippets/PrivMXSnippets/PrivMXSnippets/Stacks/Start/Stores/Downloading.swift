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
	func downloadingStart(){
		let fileID = "FILE_ID"
		let URL = URL(fileURLWithPath: "/path/to/file/Filename.txt")
		 
		guard let fileHandle =  try? FileHandle(forWritingTo: URL)
		else { return }
		 
		Task{
			try? await endpointSession?.startDownloadingToFile(
				fileHandle,
				from: fileID)
			//The hanlder will close the fileHandle
		}
		
	}
}
