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
import PrivMXEndpointSwiftNative
import PrivMXEndpointSwift

///FileSoure getting data using a Swift FileHandle.
public struct FileHandleDataSource:FileDataSource{
	
	public init(
		file: FileHandle,
		privateMeta: Data,
		publicMeta: Data,
		size: Int64,
		hasDataLeft: Bool
	) {
		self.file = file
		self.privateMeta = privateMeta
		self.publicMeta = publicMeta
		self.size = size
		self.hasDataLeft = hasDataLeft
	}
	
	/// Handle to a local file
	var file:FileHandle
	
	public mutating func getNextChunk(
		ofSize chunkSize: Int64
	) throws -> Data {
		guard let chunk = try file.read(upToCount: Int(chunkSize))
		else{
			throw PrivMXEndpointError.otherFailure(privmx.InternalError(name: "Unexpectedly received nil data",
																		message: "",
																		description: "",
																		code: nil)
			)
		}
		if chunk.count < chunkSize{
			hasDataLeft = false
		}
		
		return chunk
	}
	
	public mutating func close(
	) throws -> Void {
		try file.close()
	}
	
	public var privateMeta: Data
	
	public var publicMeta: Data
	
	public var size: Int64
	
	public private(set) var hasDataLeft: Bool = true
}
