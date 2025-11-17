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


extension PrivMXSnippetClass {
 
    
    public func basicDownloads(){
        let fileId = "FILE_ID"
		 
        guard let handle = try? endpointSession?.storeApi?.openFile(fileId) else {return}
		guard let file = try? endpointSession?.storeApi?.getFile(fileId) else {return}
         
		let fileData = try? endpointSession?.storeApi?.readFromFile(withHandle: handle, length: file.size)
         
		_ = try? endpointSession?.storeApi?.closeFile(withHandle: handle)
    }
    
	public func downloadWithHandler(){
		let fileID = "FILE_ID"
		let URL = URL(fileURLWithPath: "/path/to/file/Filename.txt")
		
		guard let fileHandle = try? FileHandle(forWritingTo: URL),
			  let storeApi = endpointSession?.storeApi
		else { return }
		
		let fileHandler = try? PrivMXStoreFileHandler.getStoreFileReader(
			saveTo: fileHandle,
			readFrom: fileID,
			with:storeApi)
		repeat{
			try? fileHandler?.readChunk()
		}while fileHandler?.hasDataLeft == true
		
		try? fileHandler?.close()
	}
	
    public func downloadWithStreams(){
        let fileID = "FILE_ID"
		
        let URL = URL(fileURLWithPath: "/path/to/file/Filename.txt")

        guard let fileHandle =  try? FileHandle(forWritingTo: URL) else { return }

		Task{
            try? await endpointSession?.startDownloadingToFile(fileHandle, from: fileID)
            try? await endpointSession?.startDownloadingToFile(fileHandle, from: fileID)
        }
    }
}
