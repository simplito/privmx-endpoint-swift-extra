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

public extension privmx.endpoint.core.Buffer {
	
	/// Creates a new `Data` instance from underlying bytes
	///
	/// - Returns: a new `Data` instance
	func getData (
	) -> Data{
		guard let bufstr = self.__dataUnsafe() else {
			return Data()
		}
		return Data(bytes: bufstr, count: self.size())
	}
	
	/// Creates a privmx.endpoint.core.Buffer instance from Data
	///
	/// - Parameter data: Source data.
	///
	/// - Returns: New `privmx.endpoint.core.Buffer` instance
	static func from(
		_ data: Data
	) -> privmx.endpoint.core.Buffer {
		
		Self.from([UInt8](data),data.count)
	}
}
