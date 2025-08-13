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

public struct LibEventType:PMXEventType, Sendable {
	public init?(rawValue: Int64 = -1) {
		if rawValue <= 0,rawValue >= -4{
			self.rawValue = rawValue
		}else{
			return nil
		}
	}
	
	public var rawValue: Int64
	
	public static var CONTEXT_CUSTOM :LibEventType { LibEventType(rawValue: 0)!}
	public static var LIB_CONNECTED :LibEventType { LibEventType(rawValue: -1)!}
	public static var LIB_BREAK :LibEventType { LibEventType(rawValue: -2)!}
	public static var LIB_DISCONNECTED :LibEventType { LibEventType(rawValue: -3)!}
	public static var LIB_PLATFORM_DISCONNECTED :LibEventType { LibEventType(rawValue: -4)!}
}
