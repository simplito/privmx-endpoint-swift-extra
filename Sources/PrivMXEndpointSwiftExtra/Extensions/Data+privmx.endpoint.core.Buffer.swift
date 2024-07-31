//
// PrivMX Endpoint Swift Extra
// Copyright © 2024 Simplito sp. z o.o.
//
// This file is part of the PrivMX Platform (https://privmx.cloud).
// This software is Licensed under the MIT License.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import PrivMXEndpointSwiftNative
import PrivMXEndpointSwift

public extension Data {
	/// Returns contents of this instance as `privmx.endpoint.core.Buffer`
	func asBuffer(
	) -> privmx.endpoint.core.Buffer {
		let pointer = [UInt8](self)
		let dataSize = self.count
		let resultCppString = privmx.endpoint.core.Buffer.from(pointer,dataSize)
		return resultCppString
	}
	
	/// Creates an instance of `Data` from the bytes of a `privmx.endpoint.core.Buffer`
	init(
		from str:privmx.endpoint.core.Buffer
	) throws {
		guard let cDataPtr = str.__dataUnsafe() else {
			throw PrivMXEndpointError.otherFailure(msg: "data was Nil")
		}
		let dataSize = str.size()
		self.init(bytes: cDataPtr, count: dataSize)
	}
}
