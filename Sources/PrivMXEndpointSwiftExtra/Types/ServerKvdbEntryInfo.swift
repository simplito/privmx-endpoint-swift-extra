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
import Cxx
import CxxStdlib
import PrivMXEndpointSwiftNative

/// An extension for `ServerKvdbEntryInfo` to conform to the `Identifiable` and `Hashable` protocols.
/// This extension allows for comparing two `ServerKvdbEntryInfo` instances, generating unique hash values, and providing an identifier for each file.
extension privmx.endpoint.kvdb.ServerKvdbEntryInfo: Identifiable, Hashable, @unchecked Sendable {

	/// Compares two `ServerKvdbEntryInfo` instances for equality.
	///
	/// This function compares key properties of the two `ServerKvdbEntryInfo` instances, including `fileId`, `kvdbId`,
	/// `author`, and `createDate`.
	/// - Parameters:
	///   - lhs: The left-hand side `ServerKvdbEntryInfo` instance.
	///   - rhs: The right-hand side `ServerKvdbEntryInfo` instance.
	/// - Returns: `true` if all relevant fields of both file info instances are equal, otherwise `false`.
	public static func == (
		lhs: privmx.endpoint.kvdb.ServerKvdbEntryInfo,
		rhs: privmx.endpoint.kvdb.ServerKvdbEntryInfo
	) -> Bool {
		return lhs.key == rhs.key &&
			   lhs.kvdbId == rhs.kvdbId &&
			   lhs.author == rhs.author &&
			   lhs.createDate == rhs.createDate
	}

	/// The unique identifier for the file.
	///
	/// This property returns the `fileId` as a `String`, which serves as the unique identifier for the file.
	public var id: String {
		"\(String(self.kvdbId))/\(String(self.key))"
	}

	/// Generates a hash value for the `ServerKvdbEntryInfo` instance.
	///
	/// This function combines the `fileId` and `createDate` properties to generate a unique hash value for the file info.
	/// - Parameter hasher: The `Hasher` instance used to compute the hash value.
	public func hash(into hasher: inout Hasher) -> Void {
		hasher.combine(key)
		hasher.combine(kvdbId)
		hasher.combine(author)
		hasher.combine(createDate)
	}
}
