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

/// FileDataSource using an internal `Data` buffer
public struct BufferDataSource:FileDataSource{
	
	public init(
		buffer: Data,
		privateMeta: Data,
		publicMeta: Data,
		size: Int64
	) {
		self.buffer = buffer
		self.privateMeta = privateMeta
		self.publicMeta = publicMeta
		self.size = size
	}
	
	private var buffer: Data
	
	/// Advances the internal buffer by `chunkSize` bytes.
	///
	/// - Parameter chunkSize: amount of bytes to be retrieved
	///
	/// - Returns: First `chunkSize` bytes of the Internal buffer
	public mutating func getNextChunk(
		ofSize chunkSize: Int64
	) -> Data {
		let buf = buffer.prefix(Int(chunkSize))
		if buf.count < chunkSize{
			buffer = Data()
		}else{
			buffer = buffer.advanced(by: buf.count)
		}
		return buf
	}
	
	/// This method does nothing
	public func close() throws {}
	
	public let privateMeta: Data
	
	public let publicMeta: Data
	
	public let size: Int64
	
	public var hasDataLeft: Bool{
		return !buffer.isEmpty
	}
}
