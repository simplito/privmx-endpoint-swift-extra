//
//  PMXEventSubscription.swift
//  privmx-endpoint-swift-extra
//
//  Created by Simplito on 19/08/2025.
//


public struct PMXEventRegistration: Sendable{
	/// Callback that will be executed whenever an appropriate event arrives
	var cb:(@Sendable @MainActor (Any?) -> Void)
	
	/// Enum value representing the particular registration data
	var registration: PMXEventSubscriptionRequest
	
	/// Group indicator for management of events, used when deleting events in batches
	var group: String
}
