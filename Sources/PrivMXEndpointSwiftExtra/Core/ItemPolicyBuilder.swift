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

public class ItemPolicyBuilder{
	
	private var ip = privmx.endpoint.core.ItemPolicy()
	
	public init(){}
	
	/// Initalises the builder with existing policies.
	public init(
		from policy: privmx.endpoint.core.ItemPolicy
	) {
		self.ip = policy
	}
	
	/// Returns the configured `ItemPolicy`
	public func build(
	) -> privmx.endpoint.core.ItemPolicy {
		return ip
	}
	
	/// Configures the `get`policy
	public func setGet(
		_ value:ItemPolicyValue?
	) -> ItemPolicyBuilder{
		if let value{
			let optval = privmx.makeOptional(value.rawValue)
			ip.get = optval
		} else {
			ip.get = nil
		}
		return self
	}
	
	/// Configures the `listMy`policy
	public func setListMy(
		_ value:ItemPolicyValue?
	) -> ItemPolicyBuilder{
		if let value{
			let optval = privmx.makeOptional(value.rawValue)
			ip.listMy = optval
		} else {
			ip.listMy = nil
		}
		return self
	}
	
	/// Configures the `listAll`policy
	public func setListAll(
		_ value:ItemPolicyValue?
	) -> ItemPolicyBuilder{
		if let value{
			let optval = privmx.makeOptional(value.rawValue)
			ip.listAll = optval
		} else {
			ip.listAll = nil
		}
		return self
	}
	
	/// Configures the `create`policy
	public func setCreate(
		_ value:ItemPolicyValue?
	) -> ItemPolicyBuilder{
		if let value{
			let optval = privmx.makeOptional(value.rawValue)
			ip.create = optval
		} else {
			ip.create = nil
		}
		return self
	}
	
	/// Configures the `update`policy
	public func setUpdate(
		_ value:ItemPolicyValue?
	) -> ItemPolicyBuilder{
		if let value{
			let optval = privmx.makeOptional(value.rawValue)
			ip.update = optval
		} else {
			ip.update = nil
		}
		return self
	}
	
	/// Configures the `delete`policy
	public func setDelete(
		_ value:ItemPolicyValue?
	) -> ItemPolicyBuilder{
		if let value{
			let optval = privmx.makeOptional(value.rawValue)
			ip.delete_ = optval
		} else {
			ip.delete_ = nil
		}
		return self
	}
}
