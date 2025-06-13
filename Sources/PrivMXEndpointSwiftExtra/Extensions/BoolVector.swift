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
import Foundation

public extension privmx.BoolVector {
	init(
		from array:[Bool]
	) {
		self.init()
		self.reserve(array.count)
		for b in array{
			self.push_back(b)
		}
	}
}
