//
// PrivMX Endpoint Swift Extra
// Copyright © 2025 Simplito sp. z o.o.
//
// This file is part of the PrivMX Platform (https://privmx.dev).
// This software is Licensed under the MIT License.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//

import PrivMXEndpointSwiftNative

public extension privmx.InternalError {
	
	init(
		name:String,
		message: String,
		description: String
	){
		self.init(name: std.__1.string(name),
				  message: std.__1.string(message),
				  description: std.__1.string(description),
				  code: nil,
				  scope: nil)
		
	}
}
