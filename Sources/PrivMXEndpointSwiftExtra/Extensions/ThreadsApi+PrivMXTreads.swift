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
import PrivMXEndpointSwift

extension ThreadApi:PrivMXThread{
	
	/// Lists Threads the user has access to in provided Context.
	///
	/// - Parameter contextId: from which Context should the Threads be listed
	/// - Parameter query: parameters of the query
	///
	/// - Returns:`privmx.endpoint.thread.ThreadsList`instance.
	///
	/// - Throws: `PrivMXEndpointError.failedListingThreads` if an exception was thrown in C++ code, or another error occurred.
	public func listThreads(
		from contextId: String,
		query: privmx.endpoint.core.ListQuery
	) throws -> privmx.endpoint.thread.ThreadsList {
		
		try listThreads(from: std.string(contextId),
						query: query)
	}
	
	/// Retrieves information about a Thread.
	///
	/// - Parameter threadId : which Thread is to be retrieved.
	///
	/// - Returns:Information about a Thread
	///
	/// - Throws: `PrivMXEndpointError.failedGettingThread` if an exception was thrown in C++ code, or another error occurred.
	public func getThread(
		_ threadId: String
	) throws -> privmx.endpoint.thread.ThreadInfo {
		try getThread(std.string(threadId))
	}
	
	/// Deletes a Thread.
	///
	/// - Parameter threadId: which Thread is to be deleted
	///
	/// - Throws: `PrivMXEndpointError.failedDeletingThread` if an exception was thrown in C++ code, or another error occurred.
	public func deleteThread(
		_ threadId: String
	) throws -> Void {
		try deleteThread(std.string(threadId))
	}
	
	/// Creates a new Thread on the Platform.
	///
	/// Note that managers do not gain acess to the thread without being added as users.
	///
	/// - Parameter contextId: in which Context should the thread be created
	/// - Parameter users: who can access the Thread
	/// - Parameter managers: who can manage the thread
	/// - Parameter title: the title of the thread
	///
	/// - Returns:Id of the newly created Thread
	///
	/// - Throws: `PrivMXEndpointError.failedCreatingThread` if an exception was thrown in C++ code, or another error occurred.
	public func createThread(
		_ threadName: String,
		with users: [privmx.endpoint.core.UserWithPubKey],
		managedBy managers: [privmx.endpoint.core.UserWithPubKey],
		in contextId: String
	) throws -> String {
		
		var v = privmx.UserWithPubKeyVector()
		for u in users{
			v.push_back(u)
		}
		var m = privmx.UserWithPubKeyVector()
		for u in managers{
			m.push_back(u)
		}
		
		return try String(createThread(std.string(threadName),
								with: v,
								managedBy: m,
								in: std.string(contextId)))
	}
	
	/// Lists Messages from a particular Thread
	///
	/// - Parameter threadId:from which Thread should the Messages be listed
	/// - Parameter query: parameters of the query
	///
	/// - Returns: A list of messages in accordance to the query.
	///
	/// - Throws: `PrivMXEndpointError.failedListingMessages` if an exception was thrown in C++ code, or another error occurred.
	public func listMessages(
		from threadId: String,
		query: privmx.endpoint.core.ListQuery
	) throws -> privmx.endpoint.core.MessagesList {
		try listMessages(from: std.string(threadId),
						 query: query)
	}
	
	/// Retrieves the Message with specified Id
	///
	/// - Parameter messageId: Message to be Retrieved
	///
	/// - Returns: A Message
	///
	/// - Throws: `PrivMXEndpointError.failedDeletingMessage` if an exception was thrown in C++ code, or another error occurred.
	public func getMessage(
		_ messageId: String
	) throws -> privmx.endpoint.core.Message {
		try getMessage(std.string(messageId))
	}
	
	/// Sends a message in a thread
	///
	/// - Parameter threadId: Message to be deleted
	/// - Parameter publicMeta: Meta_data that will not be encrypted on the Platform
	/// - Parameter privateMeta: Meta_data that will be encrypted on the Platform
	/// - Parameter data: Actual message
	///
	/// - Returns:Id of the created message, wrappend in a `ResultWithError` structure for error handling.
	///
	/// - Throws: `PrivMXEndpointError.failedCreatingMessage` if an exception was thrown in C++ code, or another error occurred.
	public func sendMessage(
		in threadId: String,
		publicMeta: Data,
		privateMeta: Data,
		data: Data
	) throws -> String {
		try String(sendMessage(threadId: std.string(threadId),
							   publicMeta: publicMeta.asBuffer(),
							   privateMeta: privateMeta.asBuffer(),
							   data: data.asBuffer()))
	}
	
	/// Deletes a Message.
	///
	/// - Parameter messageId: which Message is to be deleted
	///
	/// - Throws: `PrivMXEndpointError.failedDeletingMessage` if an exception was thrown in C++ code, or another error occurred.
	public func deleteMessage(
		_ messageId: String
	) throws -> Void {
		try deleteMessage(std.string(messageId))
	}
	
	/// Updates an existing Thread.
	///
	/// The provided values override preexisting values.
	///
	/// - Parameter contextId: which Thread is to be updated
	/// - Parameter users: who can access the Thread
	/// - Parameter managers: who can manage the thread
	/// - Parameter title: the title of the thread
	/// - Parameter version: current version of the Thread
	/// - Parameter force: force the update by disregarding the version check
	/// - Parameter generateNewKeyId: force regeneration of new keyId for Thread
	/// - Parameter accessToOldDataForNewUsers: placeholder parameter (does nothing for now)
	///
	/// - Throws: `PrivMXEndpointError.failedUpdatingThread` if an exception was thrown in C++ code, or another error occurred.
	public func updateThread(
		_ threadId: String,
		users:[privmx.endpoint.core.UserWithPubKey],
		managers:[privmx.endpoint.core.UserWithPubKey],
		title: String,
		version: Int64,
		force: Bool,
		generateNewKeyId: Bool,
		accessToOldDataForNewUsers: Bool
	) throws -> Void {
		var v = privmx.UserWithPubKeyVector()
		for u in users{
			v.push_back(u)
		}
		
		var m = privmx.UserWithPubKeyVector()
		for u in managers{
			m.push_back(u)
		}
		
		try self.updateThread(
			std.string(threadId),
			users: v,
			managers: m,
			title: std.string(title),
			version: version,
			force: force,
			generateNewKeyId: generateNewKeyId,
			accessToOldDataForNewUsers: accessToOldDataForNewUsers)
	}
}
