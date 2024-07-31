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
import PrivMXEndpointSwift

public extension PrivMXCrypto{
	func signBase64(
		data:String,
		key:String
	) throws -> String{
		if let data = data.data(using: .utf8){
			return try sign(data:data,key:key).base64EncodedString()
		}else{
			throw PrivMXEndpointError.failedSigning(msg: "Base64 encoding failed")
		}
	}
}
