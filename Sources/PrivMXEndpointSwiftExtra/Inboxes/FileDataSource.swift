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

public protocol FileDataSource: Sendable{
	
	/// Retrieves up to `chunkSize`bytes from the data source.
	///
	/// - Parameter chunkSize:
	mutating func getNextChunk(
		ofSize chunkSize:Int64
	) throws -> Data
	
	/// Attempts to close the data source, for example when the source is a file on disc
	mutating func close(
	) throws
	
	/// Declared private (to be encrypted) metadata of the File
	var privateMeta:Data { get }
	
	/// Declared public metadata of the File
	var publicMeta:Data { get }
	
	/// Declared size of the File
	var size:Int64 { get }
	
	/// Signifies that there are still bytes that have not been retrieved
	var hasDataLeft:Bool { get }
	
}
