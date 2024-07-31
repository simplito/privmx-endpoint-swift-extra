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

extension privmx.StringVector:Hashable{
	public static func == (lhs: privmx.StringVector, rhs: privmx.StringVector) -> Bool {
		privmx.compareVectors(lhs, rhs)
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.count)
	}
	
}

