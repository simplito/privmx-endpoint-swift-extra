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

extension privmx.endpoint.core.LibPlatformDisconnectedEvent : PMXEvent{
	public static func typeStr(
	) -> String {
		return "libPlatformDisconnected"
	}
	public func handleWith(
		cb: @escaping ((_ data: Any?) -> Void)
	) -> Void {
		cb(nil)
	}
}
