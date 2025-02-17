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
	///
	/// - parameter policy: preexisting Policy object.
	public init(
		from policy: privmx.endpoint.core.ItemPolicy
	) {
		self.ip = policy
	}
	
	/// This methods returns a `ItemPolicy` that was configured by this instance.
	///
	/// - Returns:  configured `ItemPolicy`
	public func build(
	) -> privmx.endpoint.core.ItemPolicy {
		return ip
	}
	
	/// Configures the `get` policy
	///
	/// - Parameter value: the policy value that will be set
	///
	/// - Returns: this object for further configuration
	@available(*, deprecated)
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
	
	/// Configures the `listMy` policy
	///
	/// - Parameter value: the policy value that will be set
	///
	/// - Returns: this object for further configuration
	@available(*, deprecated)
	public func setListMy(
		_ value:ContainerPolicyValue?
	) -> ItemPolicyBuilder{
		if let value{
			let optval = privmx.makeOptional(value.rawValue)
			ip.listMy = optval
		} else {
			ip.listMy = nil
		}
		return self
	}
	
	/// Configures the `listAll` policy
	/// - Parameter value: the policy value that will be set
	/// - Returns: this object for further configuration
	@available(*, deprecated)
	public func setListAll(
		_ value:ContainerPolicyValue?
	) -> ItemPolicyBuilder{
		if let value{
			let optval = privmx.makeOptional(value.rawValue)
			ip.listAll = optval
		} else {
			ip.listAll = nil
		}
		return self
	}
	
	/// Configures the `create` policy
	///
	/// - Parameter value: the policy value that will be set
	///
	/// - Returns: this object for further configuration
	@available(*, deprecated)
	public func setCreate(
		_ value:ContainerPolicyValue?
	) -> ItemPolicyBuilder{
		if let value{
			let optval = privmx.makeOptional(value.rawValue)
			ip.create = optval
		} else {
			ip.create = nil
		}
		return self
	}
	
	/// Configures the `update` policy
	///
	/// - Parameter value: the policy value that will be set
	///
	/// - Returns: this object for further configuration
	@available(*, deprecated)
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
	
	/// Configures the `delete` policy
	///
	/// - Parameter value: the policy value that will be set
	///
	/// - Returns: this object for further configuration
	@available(*, deprecated)
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

	/// Configures the `get` policy
	///
	/// - Parameter value: the policy value that will be set
	///
	/// - Returns: this object for further configuration
	public func setGet(
		_ value:ItemPolicyValue
	) -> ItemPolicyBuilder{
		let optval = privmx.makeOptional(value.rawValue)
		ip.get = optval
		return self
	}
	
	/// Configures the `listMy` policy
	///
	/// - Parameter value: the policy value that will be set
	///
	/// - Returns: this object for further configuration
	public func setListMy(
		_ value:ContainerPolicyValue
	) -> ItemPolicyBuilder{
		let optval = privmx.makeOptional(value.rawValue)
		ip.listMy = optval
		return self
	}
	
	/// Configures the `listAll` policy
	/// - Parameter value: the policy value that will be set
	/// - Returns: this object for further configuration
	public func setListAll(
		_ value:ContainerPolicyValue
	) -> ItemPolicyBuilder{
		let optval = privmx.makeOptional(value.rawValue)
		ip.listAll = optval
		return self
	}
	
	/// Configures the `create` policy
	///
	/// - Parameter value: the policy value that will be set
	///
	/// - Returns: this object for further configuration
	public func setCreate(
		_ value:ContainerPolicyValue
	) -> ItemPolicyBuilder{
		let optval = privmx.makeOptional(value.rawValue)
		ip.create = optval
		return self
	}
	
	/// Configures the `update` policy
	///
	/// - Parameter value: the policy value that will be set
	///
	/// - Returns: this object for further configuration
	public func setUpdate(
		_ value:ItemPolicyValue
	) -> ItemPolicyBuilder{
		let optval = privmx.makeOptional(value.rawValue)
		ip.update = optval
		return self
	}
	
	/// Configures the `delete` policy
	///
	/// - Parameter value: the policy value that will be set
	///
	/// - Returns: this object for further configuration
	public func setDelete(
		_ value:ItemPolicyValue
	) -> ItemPolicyBuilder{
		let optval = privmx.makeOptional(value.rawValue)
		ip.delete_ = optval
		return self
	}
}
