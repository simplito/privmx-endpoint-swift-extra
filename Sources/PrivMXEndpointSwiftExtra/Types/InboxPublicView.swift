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

extension privmx.endpoint.inbox.InboxPublicView: Identifiable, Hashable, @unchecked Sendable {
	public static func == (
		lhs: privmx.endpoint.inbox.InboxPublicView,
		rhs: privmx.endpoint.inbox.InboxPublicView
	) -> Bool {
		lhs.inboxId == rhs.inboxId &&
		lhs.version == rhs.version &&
		lhs.publicMeta == rhs.publicMeta
	}
	
	public func hash(
		into hasher: inout Hasher
	) -> Void {
		hasher.combine(inboxId)
		hasher.combine(version)
	}
	
	/// The unique identifier for the inbox.
	///
	/// This property returns the `inboxId` as a `String`, which serves as the unique identifier for the inbox.
	public var id: String {
		String(self.inboxId)
	}
}
