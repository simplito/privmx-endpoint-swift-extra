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

public struct BufferDataSource:FileDataSource{
	
	private var buffer: Data
	
	public mutating func getNextChunk(
		ofSize chunkSize: Int64
	) throws -> Data {
		let buf = buffer.prefix(Int(chunkSize))
		if buf.count < chunkSize{
			buffer = Data()
		}else{
			buffer = buffer.advanced(by: buf.count)
		}
		return buf
	}
	
	public mutating func close() throws {}
	
	public let privateMeta: Data
	
	public let publicMeta: Data
	
	public let size: Int64
	
	public var hasDataLeft: Bool{
		return !buffer.isEmpty
	}
	
	public let id: ObjectIdentifier
}
