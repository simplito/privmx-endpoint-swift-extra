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
import PrivMXEndpointSwift

public class ContainerPolicyBuilder{
	
	private var cpwi = privmx.endpoint.core.ContainerPolicyWithoutItem()
	private var cp = privmx.endpoint.core.ContainerPolicy()
	
	/// Creates a fresh ContainerPolicyBuilder
	public init(){}
	
	/// Initalises the builder with existing policies.
	///
	/// - parameter policy: preexisting policy object.
	public init(
		from policy: privmx.endpoint.core.ContainerPolicy
	) {
		self.cp = policy
		self.cpwi = privmx.endpoint.core.ContainerPolicyWithoutItem(get: policy.get,
																	update: policy.update,
																	delete_: policy.delete_,
																	updatePolicy: policy.updatePolicy,
																	updaterCanBeRemovedFromManagers: policy.updaterCanBeRemovedFromManagers,
																	ownerCanBeRemovedFromManagers: policy.ownerCanBeRemovedFromManagers)
	}
	
	/// Initalises the builder with existing policies.
	///
	/// - parameter policy: preexisting policy object.
	public init(
		from policy: privmx.endpoint.core.ContainerPolicyWithoutItem
	){
		self.cpwi = policy
		self.cp = privmx.endpoint.core.ContainerPolicy()
		cp.get = policy.get
		cp.update = policy.update
		cp.delete_ = policy.delete_
		cp.updatePolicy = policy.updatePolicy
		cp.updaterCanBeRemovedFromManagers = policy.updaterCanBeRemovedFromManagers
		cp.ownerCanBeRemovedFromManagers = policy.ownerCanBeRemovedFromManagers
	}
	
	/// This methods returns a `ContainerPolicy` that was configured by this instance.
	/// - Returns:  configured `ContainerPolicy`
	public func build(
	) -> privmx.endpoint.core.ContainerPolicy {
		return cp
	}
	
	/// This methods returns a `ContainerPolicyWithoutItem` that was configured by this instance.
	/// - Returns:  configured `ContainerPolicyWithoutItem`
	public func buildWithoutItem(
	) -> privmx.endpoint.core.ContainerPolicyWithoutItem {
		return cpwi
	}
	
	/// Configures the `get` policy
	///
	/// - Parameter value: the policy value that will be set
	/// 
	/// - Returns: this object for further configuration
	@available(*, deprecated)
	public func setGet(
		_ value:ContainerPolicyValue?
	) -> ContainerPolicyBuilder{
		if let value{
			let optval = privmx.makeOptional(value.rawValue)
			cp.get = optval
			cpwi.get = optval
		} else {
			cp.get = nil
			cpwi.get = nil
		}
		return self
	}
	
	/// Configures the `get` policy
	///
	/// - Parameter value: the policy value that will be set
	/// 
	/// - Returns: this object for further configuration
	public func setGet(
		_ value:ContainerPolicyValue
	) -> ContainerPolicyBuilder{
		let optval = privmx.makeOptional(value.rawValue)
		cp.get = optval
		cpwi.get = optval
		return self
	}
	
	/// Configures the `update` policy
	///
	/// - Parameter value: the policy value that will be set
	///
	/// - Returns: this object for further configuration
	@available(*, deprecated)
	public func setUpdate(
		_ value:ContainerPolicyValue?
	) -> ContainerPolicyBuilder{
		if let value{
			let optval = privmx.makeOptional(value.rawValue)
			cp.update = optval
			cpwi.update = optval
		} else {
			cp.update = nil
			cpwi.update = nil
		}
		return self
	}
	
	/// Configures the `update` policy
	///
	/// - Parameter value: the policy value that will be set
	///
	/// - Returns: this object for further configuration
	public func setUpdate(
		_ value:ContainerPolicyValue
	) -> ContainerPolicyBuilder{
		let optval = privmx.makeOptional(value.rawValue)
		cp.update = optval
		cpwi.update = optval
		return self
	}
	
	/// Configures the `delete` policy
	///
	/// - Parameter value: the policy value that will be set
	///
	/// - Returns: this object for further configuration
	public func setDelete(
		_ value:ContainerPolicyValue
	) -> ContainerPolicyBuilder{
		let optval = privmx.makeOptional(value.rawValue)
		cp.delete_ = optval
		cpwi.delete_ = optval
		return self
	}
	
	/// Configures the `updatePolicy` policy
	///
	/// - Parameter value: the policy value that will be set
	///
	/// - Returns: this object for further configuration
	public func setUpdatePolicy(
		_ value:ContainerPolicyValue
	) -> ContainerPolicyBuilder{
		let optval = privmx.makeOptional(value.rawValue)
		cp.updatePolicy = optval
		cpwi.updatePolicy = optval
		return self
	}
	
	/// Configures the `updaterCanBeRemovedFromManagers` policy
	///
	/// - Parameter value: the policy value that will be set
	///
	/// - Returns: this object for further configuration
	@available(*, deprecated)
	public func setUpdaterCanBeRemovedFromManagers(
		_ value: SpecialPolicyValue?
	) -> ContainerPolicyBuilder{
		if let value{
			let optval = privmx.makeOptional(value.rawValue)
			cp.updaterCanBeRemovedFromManagers = optval
			cpwi.updaterCanBeRemovedFromManagers = optval
		} else {
			cp.updaterCanBeRemovedFromManagers = nil
			cpwi.updaterCanBeRemovedFromManagers = nil
		}
		return self
	}
	
	/// Configures the `ownerCanBeRemovedFromManagers` policy
	///
	/// - Parameter value: the policy value that will be set
	///
	/// - Returns: this object for further configuration
	
	@available(*, deprecated)public func setOwnerCanBeRemovedFromManagers(
		_ value: SpecialPolicyValue?
	) -> ContainerPolicyBuilder{
		if let value{
			let optval = privmx.makeOptional(value.rawValue)
			cp.ownerCanBeRemovedFromManagers = optval
			cpwi.ownerCanBeRemovedFromManagers = optval
		} else {
			cp.ownerCanBeRemovedFromManagers = nil
			cpwi.ownerCanBeRemovedFromManagers = nil
		}
		return self
	}
	
	/// Configures the `item` policy
	///
	/// - Parameter value: the policy value that will be set
	///
	/// - Returns: this object for further configuration
	@available(*, deprecated)
	public func setItem(
		_ value: privmx.endpoint.core.ItemPolicy?
	) -> ContainerPolicyBuilder {
		if let value{
			let optval = privmx.makeOptional(value)
			cp.item = optval
		} else {
			cp.item = nil
			}
		return self
	}
	
	/// Configures the `updaterCanBeRemovedFromManagers` policy
	///
	/// - Parameter value: the policy value that will be set
	///
	/// - Returns: this object for further configuration
	public func setUpdaterCanBeRemovedFromManagers(
		_ value: SpecialPolicyValue
	) -> ContainerPolicyBuilder{
		let optval = privmx.makeOptional(value.rawValue)
		cp.updaterCanBeRemovedFromManagers = optval
		cpwi.updaterCanBeRemovedFromManagers = optval
		return self
	}
	
	/// Configures the `ownerCanBeRemovedFromManagers` policy
	///
	/// - Parameter value: the policy value that will be set
	///
	/// - Returns: this object for further configuration
	public func setOwnerCanBeRemovedFromManagers(
		_ value: SpecialPolicyValue
	) -> ContainerPolicyBuilder{
		let optval = privmx.makeOptional(value.rawValue)
		cp.ownerCanBeRemovedFromManagers = optval
		cpwi.ownerCanBeRemovedFromManagers = optval
		return self
	}
	
	/// Configures the `item` policy
	///
	/// - Parameter value: the policy value that will be set
	///
	/// - Returns: this object for further configuration
	public func setItem(
		_ value: privmx.endpoint.core.ItemPolicy
	) -> ContainerPolicyBuilder {
		let optval = privmx.makeOptional(value)
		cp.item = optval
		return self
	}
}
