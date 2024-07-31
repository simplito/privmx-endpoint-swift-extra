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

/// Protocol declaring methods of StoreApi, with Swift Types
public protocol PrivMXThread{
	
	/// Lists Threads the user has access to in provided Context.
	///
	/// - Parameter contextId: from which Context should the Threads be listed
	/// - Parameter query: parameters of the query
	///
	/// - Returns:`privmx::endpoint::thread::ThreadsList`instance.
	///
	/// - Throws: When the operation fails
	func listThreads(
		from contextId: String,
		query: privmx.endpoint.core.ListQuery
	) throws -> privmx.endpoint.thread.ThreadsList
	
	/// Retrieves information about a Thread.
	///
	/// - Parameter threadId : which Thread is to be retrieved.
	///
	/// - Returns:Information about a Thread
	///
	/// - Throws: When the operation fails
	func getThread(
		_ threadId: String
	) throws -> privmx.endpoint.thread.ThreadInfo
	
	/// Deletes a Thread.
	///
	/// - Parameter threadId: which Thread is to be deleted
	///
	/// - Throws: When the operation fails
	func deleteThread(
		_ threadId: String
	) throws -> Void
	
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
	/// - Throws: When the operation fails
	func createThread(
		_ threadName: String,
		with users: [privmx.endpoint.core.UserWithPubKey],
		managedBy managers: [privmx.endpoint.core.UserWithPubKey],
		in contextId: String)
	throws -> String
	
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
	/// - Throws: When the operation fails
	func updateThread(
		_ threadId: String,
		users:[privmx.endpoint.core.UserWithPubKey],
		managers:[privmx.endpoint.core.UserWithPubKey],
		title: String,
		version: Int64,
		force: Bool,
		generateNewKeyId: Bool,
		accessToOldDataForNewUsers: Bool
	) throws -> Void
	
	/// Lists Messages from a particular Thread
	///
	/// - Parameter threadId:from which Thread should the Messages be listed
	/// - Parameter query: parameters of the query
	///
	/// - Returns: A list of messages in accordance to the query.
	///
	/// - Throws: When the operation fails
	func listMessages(
		from threadId: String,
		query: privmx.endpoint.core.ListQuery
	) throws -> privmx.endpoint.core.MessagesList
	
	/// Retrieves the Message with specified Id
	///
	/// - Parameter messageId: Message to be Retrieved
	///
	/// - Returns: A Message
	///
	/// - Throws: When the operation fails
	func getMessage(
		_ messageId: String
	) throws -> privmx.endpoint.core.Message
	
	/// Sends a message in a thread
	///
	/// - Parameter threadId: Message to be deleted
	/// - Parameter publicMeta: Meta_data that will not be encrypted on the Platform
	/// - Parameter privateMeta: Meta_data that will be encrypted on the Platform
	/// - Parameter data: Actual message
	///
	/// - Returns:Id of the created message, wrappend in a `ResultWithError` structure for error handling.
	///
	/// - Throws: When the operation fails
	func sendMessage(
		in threadId: String,
		publicMeta: Data,
		privateMeta: Data,
		data: Data
	) throws -> String
	
	/// Deletes a Message.
	///
	/// - Parameter messageId: which Message is to be deleted
	///
	/// - Throws: When the operation fails
	func deleteMessage(
		_ messageId: String
	) throws -> Void
}
