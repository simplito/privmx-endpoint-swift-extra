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
import PrivMXEndpointSwift

/// Extension of `ThreadApi`, providing conformance for protocol using Swift types.
extension ThreadApi:PrivMXThread{
	
	 public func listThreads(
		from contextId: String,
		basedOn query: privmx.endpoint.core.PagingQuery
	) throws -> privmx.ThreadList {
		
		try listThreads(contextId: std.string(contextId),
						query: query)
	}
	
	public func getThread(
		_ threadId: String
	) throws -> privmx.endpoint.thread.Thread {
		try getThread(threadId: std.string(threadId))
	}
	
	public func deleteThread(
		_ threadId: String
	) throws -> Void {
		try deleteThread(threadId: std.string(threadId))
	}
	
	public func createThread(
		in contextId: String,
		for users: [privmx.endpoint.core.UserWithPubKey],
		managedBy managers: [privmx.endpoint.core.UserWithPubKey],
		withPublicMeta publicMeta: Data,
		withPrivateMeta privateMeta: Data,
		withPolicies policies:privmx.endpoint.core.ContainerPolicy? = nil
	) throws -> String {
		
		var v = privmx.UserWithPubKeyVector()
		v.reserve(users.count)
		for u in users{
			v.push_back(u)
		}
		var m = privmx.UserWithPubKeyVector()
		m.reserve(managers.count)
		for u in managers{
			m.push_back(u)
		}
		
		return try String(createThread(contextId: std.string(contextId),
									   users: v,
									   managers: m,
									   publicMeta: publicMeta.asBuffer(),
									   privateMeta: privateMeta.asBuffer(),
									   policies: policies))
	}
	
	public func listMessages(
		from threadId: String,
		basedOn query: privmx.endpoint.core.PagingQuery
	) throws -> privmx.MessageList {
		try listMessages(threadId: std.string(threadId),
						 query: query)
	}
	
	public func getMessage(
		_ messageId: String
	) throws -> privmx.endpoint.thread.Message {
		try getMessage(std.string(messageId))
	}
	
	public func sendMessage(
		in threadId: String,
		withPublicMeta publicMeta: Data,
		withPrivateMeta privateMeta: Data,
		containing data: Data
	) throws -> String {
		try String(sendMessage(threadId: std.string(threadId),
							   publicMeta: publicMeta.asBuffer(),
							   privateMeta: privateMeta.asBuffer(),
							   data: data.asBuffer()))
	}
	
	public func updateMessage(
		_ messageId: String,
		replacingData data: Data,
		replacingPublicMeta publicMeta: Data,
		replacingPrivateMeta privMeta: Data
	) throws -> Void {
		try updateMessage(messageId: std.string(messageId),
						  publicMeta: publicMeta.asBuffer(),
						  privateMeta: privMeta.asBuffer(),
						  data: data.asBuffer())
	}
	
	public func deleteMessage(
		_ messageId: String
	) throws -> Void {
		try deleteMessage(std.string(messageId))
	}
	
	public func updateThread(
		_ threadId: String,
		atVersion version: Int64,
		replacingUsers users:[privmx.endpoint.core.UserWithPubKey],
		replacingManagers managers:[privmx.endpoint.core.UserWithPubKey],
		replacingPublicMeta publicMeta:Data,
		replacingPrivateMeta privateMeta:Data,
		force: Bool,
		forceGenerateNewKey: Bool,
		replacingPolicies policies: privmx.endpoint.core.ContainerPolicy? = nil
	) throws -> Void {
		var v = privmx.UserWithPubKeyVector()
		for u in users{
			v.push_back(u)
		}
		
		var m = privmx.UserWithPubKeyVector()
		for u in managers{
			m.push_back(u)
		}
		
		try self.updateThread(threadId: std.string(threadId),
							  version: version,
							  users: v,
							  managers: m,
							  publicMeta: publicMeta.asBuffer(),
							  privateMeta: privateMeta.asBuffer(),
							  force: force,
							  forceGenerateNewKey: forceGenerateNewKey,
							  policies:policies)
	}
	
	public func subscribeForMessageEvents(
		in threadId: String
	) throws -> Void {
		try self.subscribeForMessageEvents(threadId: std.string(threadId))
	}
	
	public func unsubscribeFromMessageEvents(
		in threadId: String
	) throws -> Void {
		try self.unsubscribeFromMessageEvents(threadId: std.string(threadId))
	}
}
