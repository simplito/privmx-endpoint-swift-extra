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
import PrivMXEndpointSwift

/// Protocol for Events
///
/// Used for unified event handling in PrivMXEndpointWrapper
public protocol PMXEvent{
	/// Executes the callback for processing the event
	///
	/// The `data` corresponds to the same-named field in Events, though some of the m do not have it, hence `Any?`.
	///
	/// - Parameter cb: callback to be used
	func handleWith(cb:@escaping ((_ data:Any?)->Void))
	
	/// Returns string representing type of the Event
	static func typeStr() -> String
}
