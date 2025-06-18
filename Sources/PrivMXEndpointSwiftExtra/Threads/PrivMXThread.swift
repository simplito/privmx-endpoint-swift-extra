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

/// Declaring thread and message management methods using Swift types.
///
/// Do not Conform to this protocol on your own.
public protocol PrivMXThread{
	
	/// Lists the Threads the user has access to in a specified context.
	///
	/// This method retrieves a list of Threads in the given context, with pagination and filtering options.
	///
	/// - Parameters:
	///   - contextId: The unique identifier of the context from which to list Threads.
	///   - query: A paging query object for filtering and paginating the results.
	///
	/// - Returns: A `privmx.endpoint.thread.ThreadsList` instance containing the list of Threads.
	///
	/// - Throws: `PrivMXEndpointError.failedListingThreads` if the operation fails.
	func listThreads(
		from contextId: String,
		basedOn query: privmx.endpoint.core.PagingQuery
	) throws -> privmx.ThreadList
	
	/// Retrieves detailed information about a specific Thread.
	///
	/// This method returns metadata and details of a Thread identified by its unique thread ID.
	///
	/// - Parameter threadId: The unique identifier of the Thread to retrieve.
	///
	/// - Returns: A `privmx.endpoint.thread.Thread` instance containing the Thread's details.
	///
	/// - Throws: `PrivMXEndpointError.failedGettingThread` if the operation fails.
	func getThread(
		_ threadId: String
	) throws -> privmx.endpoint.thread.Thread
	
	/// Deletes a specific Thread from the platform.
	///
	/// This method removes a Thread, identified by its thread ID, from the platform.
	///
	/// - Parameter threadId: The unique identifier of the Thread to delete.
	///
	/// - Throws: `PrivMXEndpointError.failedDeletingThread` if the operation fails.
	func deleteThread(
		_ threadId: String
	) throws -> Void
	
	/// Creates a new Thread in a specified context.
	///
	/// This method creates a new Thread with specified users, managers, and metadata in the given context.
	/// Note: Managers do not automatically have access to the thread unless explicitly added as users.
	/// Note: when no policies are supplied, the default ones inherited from the context will be used instead.
	///
	/// - Parameters:
	///   - contextId: The unique identifier of the context in which to create the Thread.
	///   - users: A list of `UserWithPubKey` objects representing users who will have access to the Thread.
	///   - managers: A list of `UserWithPubKey` objects representing managers responsible for the Thread.
	///   - publicMeta: The public metadata associated with the Thread, which will not be encrypted.
	///   - privateMeta: The private metadata associated with the Thread, which will be encrypted.
	///   - policies: The policies governing the Container, as well as the items within.
	///
	///
	/// - Returns: A `String` representing the ID of the newly created Thread.
	///
	/// - Throws: `PrivMXEndpointError.failedCreatingThread` if the operation fails.
	func createThread(
		in contextId: String,
		for users: [privmx.endpoint.core.UserWithPubKey],
		managedBy managers: [privmx.endpoint.core.UserWithPubKey],
		withPublicMeta pubMeta: Data,
		withPrivateMeta privMeta: Data,
		withPolicies policies: privmx.endpoint.core.ContainerPolicy?
	) throws -> String
	
	/// Updates an existing Thread with new users, managers, and metadata.
	///
	/// This method updates a Thread, replacing its existing users, managers, and metadata with new values.
	/// The update can be forced and a new key can be generated if necessary.
	///
	/// - Parameters:
	///   - threadId: The unique identifier of the Thread to update.
	///   - version: The current version of the Thread, used to ensure version consistency.
	///   - users: A new list of `UserWithPubKey` objects representing users who will have access to the Thread.
	///   - managers: A new list of `UserWithPubKey` objects representing managers responsible for the Thread.
	///   - publicMeta: The new public metadata of the Thread, which will not be encrypted.
	///   - privateMeta: The new private metadata of the Thread, which will be encrypted.
	///   - force: A boolean indicating whether to force the update, bypassing version control.
	///   - forceGenerateNewKey: A boolean indicating whether a new key should be generated for the Thread.
	///   - policies: The new policies for the Container.
	///
	/// - Throws: `PrivMXEndpointError.failedUpdatingThread` if the operation fails.
	func updateThread(
		_ threadId: String,
		atVersion version: Int64,
		replacingUsers users: [privmx.endpoint.core.UserWithPubKey],
		replacingManagers managers: [privmx.endpoint.core.UserWithPubKey],
		replacingPublicMeta pubMeta: Data,
		replacingPrivateMeta privMeta: Data,
		force: Bool,
		forceGenerateNewKey: Bool,
		replacingPolicies policies: privmx.endpoint.core.ContainerPolicy?
	) throws -> Void
	
	/// Lists Messages from a specific Thread.
	///
	/// This method retrieves a list of Messages from the specified Thread, filtered and paginated based on the query.
	///
	/// - Parameters:
	///   - threadId: The unique identifier of the Thread from which to list Messages.
	///   - query: A paging query object for filtering and paginating the results.
	///
	/// - Returns: A `privmx.endpoint.core.MessageList` instance containing the list of Messages.
	///
	/// - Throws: `PrivMXEndpointError.failedListingMessages` if the operation fails.
	func listMessages(
		from threadId: String,
		basedOn query: privmx.endpoint.core.PagingQuery
	) throws -> privmx.MessageList
	
	/// Retrieves a specific Message by its ID.
	///
	/// This method returns the details of a Message identified by its message ID.
	///
	/// - Parameter messageId: The unique identifier of the Message to retrieve.
	///
	/// - Returns: A `privmx.endpoint.thread.Message` instance containing the Message's details.
	///
	/// - Throws: `PrivMXEndpointError.failedGettingMessage` if the operation fails.
	func getMessage(
		_ messageId: String
	) throws -> privmx.endpoint.thread.Message
	
	/// Sends a Message in a Thread.
	///
	/// This method sends a Message to the specified Thread, with the option to include both public and private metadata.
	///
	/// - Parameters:
	///   - threadId: The unique identifier of the Thread to send the Message to.
	///   - publicMeta: The public metadata associated with the Message, which will not be encrypted.
	///   - privateMeta: The private metadata associated with the Message, which will be encrypted.
	///   - data: The actual content of the Message as `Data`, which will be encrypted.
	///
	/// - Returns: A `String` representing the ID of the created Message.
	///
	/// - Throws: `PrivMXEndpointError.failedCreatingMessage` if the operation fails.
	func sendMessage(
		in threadId: String,
		withPublicMeta publicMeta: Data,
		withPrivateMeta privateMeta: Data,
		containing data: Data
	) throws -> String
	
	/// Updates an existing Message.
	///
	/// This method updates a Message by replacing its data and metadata with new values.
	///
	/// - Parameters:
	///   - messageId: The unique identifier of the Message to update.
	///   - data: The new content of the Message as `Data`, which will be encrypted.
	///   - publicMeta: The new public metadata of the Message, which will not be encrypted.
	///   - privateMeta: The new private metadata of the Message, which will be encrypted.
	///
	/// - Throws: `PrivMXEndpointError.failedUpdatingMessage` if the operation fails.
	func updateMessage(
		_ messageId: String,
		replacingData data: Data,
		replacingPublicMeta publicMeta: Data,
		replacingPrivateMeta privMeta: Data
	) throws -> Void
	
	/// Deletes a specific Message.
	///
	/// This method deletes a Message identified by its unique message ID from the platform.
	///
	/// - Parameter messageId: The unique identifier of the Message to delete.
	///
	/// - Throws: `PrivMXEndpointError.failedDeletingMessage` if the operation fails.
	func deleteMessage(
		_ messageId: String
	) throws -> Void
	
	func subscribeForThreadEvents(
	) throws -> Void
	
	func unsubscribeFromThreadEvents(
	) throws -> Void
	
	/// Subscribes to receive events related to Messages in a specific Thread.
	///
	/// This method subscribes to message-related events, allowing the client to receive notifications about changes
	/// in the Messages of the specified Thread.
	///
	/// - Parameter threadId: The unique identifier of the Thread for which to subscribe to message events.
	///
	/// - Throws: `PrivMXEndpointError.failedSubscribing` if the subscription process fails.
	func subscribeForMessageEvents(
		in threadId: String
	) throws -> Void
	
	/// Unsubscribes from receiving events related to Messages in a specific Thread.
	///
	/// This method unsubscribes from message-related events for the specified Thread, stopping further notifications.
	///
	/// - Parameter threadId: The unique identifier of the Thread for which to unsubscribe from message events.
	///
	/// - Throws: `PrivMXEndpointError.failedUnsubscribing` if the unsubscribing process fails.
	func unsubscribeFromMessageEvents(
		in threadId: String
	) throws -> Void
}
