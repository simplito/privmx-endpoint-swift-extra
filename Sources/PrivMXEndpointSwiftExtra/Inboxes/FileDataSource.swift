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

public protocol FileDataSource: Sendable,Identifiable{
	
	mutating func getNextChunk(
		ofSize chunkSize:Int64
	) throws -> Data
	
	mutating func close(
	) throws
	
	var privateMeta:Data { get }
	
	var publicMeta:Data { get }
	
	var size:Int64 { get }
	
	var hasDataLeft:Bool { get }
}
