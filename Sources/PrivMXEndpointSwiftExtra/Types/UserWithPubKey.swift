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

import PrivMXEndpointSwiftNative

public extension privmx.endpoint.core.UserWithPubKey{
	init(
		userId: String,
		pubKey: String
	){
		self.init(userId: std.string(userId),
				  pubKey: std.string(pubKey))
	}
}
