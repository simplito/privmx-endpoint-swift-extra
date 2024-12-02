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
import PrivMXEndpointSwiftNative

public enum ContainerPolicyValue: RawRepresentable{
	public var rawValue: std.string {
		switch self{
			case .all:
				return "all"
			case .default:
				return "default"
			case .none:
				return "none"
			case .owner:
				return "owner"
			case .inherit:
				return "inherit"
			case .user:
				return "user"
			case .manager:
				return "manager"
			case .complex(let val):
				return std.string(val)
		}
	}
	
	
	public init?(rawValue: std.string) {
		let conNorm = String(rawValue).split(separator: ",")
		if conNorm.count > 1 {
			self = .complex("")
			for con in conNorm{
				var cas :ContainerPolicyValue = .default
				var flag = false
				let alts = String(con).split(separator: "&")
				for alt in alts{
					guard let c = ContainerPolicyValue(rawValue:std.string(String(alt))) else {return}
					if !flag{
						cas = c
						flag = true
					}
					else{
						cas.and(c)
					}
				}
				self.or(cas)
			}
		} else {
			switch rawValue{
				case "all":
					self = .all
				case "none":
					self = .none
				case "default":
					self = .default
				case "owner":
					self = .owner
				case "inherit":
					self = .inherit
				case "user":
					self = .user
				case "manager":
					self = .manager
				default:
					return nil
			}
		}
	}
	
	public typealias RawValue = std.string
	
	/// All Context users can perform this action
	case all
	/// No one can perform this action
	case none
	/// Take the default value
	case `default`
	/// Only Container owner can perform this action
	case owner
	/// Take value from the Context
	case inherit
	/// All Container users can perform this action
	case user
	/// All Container managers can perform this action
	case manager
	
	/// This case sould not be used directly, It's here to represent values generated by `and(_:)` &`or(_:)`
	case complex(String)
	
	/// Changes `self` to `.complex`, where the associated value consists of `self.rawValue` and `val.rawValue`connected with `&`.
	///
	/// - Parameter val: Policy value to be appended with "AND" operator
	/// - Returns: modified `self`
	@discardableResult
	public mutating func and(
		_ val:ContainerPolicyValue
	) -> ContainerPolicyValue{
		self = .complex("\(self.rawValue)&\(val.rawValue)")
		return self
	}
	
	/// Changes `self` to `.complex`, where the associated value consists of `self.rawValue` and `val.rawValue`connected with `,`.
	///
	/// - Parameter val: Policy value to be appended with "OR" operator
	/// - Returns: modified `self`
	@discardableResult
	public mutating func or(
		_ val:ContainerPolicyValue
	) -> ContainerPolicyValue{
		self = .complex("\(self.rawValue),\(val.rawValue)")
		return self
	}
}
