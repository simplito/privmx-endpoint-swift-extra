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

/// An extension for `StringVector` to conform to the `Hashable` protocol.
/// This extension allows comparing two `StringVector` instances and generating
/// a hash value for usage in hash-based collections, such as dictionaries or sets.
extension privmx.StringVector: Hashable {

	/// Compares two `StringVector` instances for equality.
	///
	/// This function compares the contents of two `StringVector` instances by calling the
	/// `privmx.compareVectors` function.
	/// - Parameters:
	///   - lhs: The left-hand side `StringVector` instance.
	///   - rhs: The right-hand side `StringVector` instance.
	/// - Returns: `true` if both vectors are equal, otherwise `false`.
	public static func == (lhs: privmx.StringVector, rhs: privmx.StringVector) -> Bool {
		privmx.compareVectors(lhs, rhs)
	}

	/// Generates a hash value for the `StringVector`.
	///
	/// This function generates the hash based on the `count` of the vector.
	/// - Parameter hasher: The `Hasher` instance used to compute the hash value.
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.count)
		for i in self{
			hasher.combine(i)
		}
	}
}
