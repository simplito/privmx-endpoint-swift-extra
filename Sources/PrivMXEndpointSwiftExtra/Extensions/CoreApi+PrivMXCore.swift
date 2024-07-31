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
import Cxx
import CxxStdlib
import PrivMXEndpointSwift
import PrivMXEndpointSwiftNative

extension CoreApi : PrivMXCore{
	
	/// Sets path to .pem file with certificates.
	///
	/// - Parameter path: Path to the .pem file
	///
	/// - Throws: `PrivMXEndpointError.failedSettingCerts` if an exception was thrown in C++ code, or another error occurred.
	public static func setCertsPath(
		_ path: String
	) throws -> Void {
		try Self.setCertsPath(std.string(path))
	}
	
	/// Subscribes to a data channel to listen for events
	///
	/// The available channels are:
	///
	/// "thread2" for events regarding threads;
	///
	/// "store" for events regarding stores;
	///
	/// "thread2/[threadId]/messages" for events regarding messages in a particular thread;
	///
	/// "store/[storeId]/files" for files in a particular store.
	///
	/// - Parameter channel: Which events should start arriving
	///
	/// - Throws: `PrivMXEndpointError.failedSubscribingToChannel` if an exception was thrown in C++ code, or another error occurred.
	public func subscribeToChannel(
		_ channel: String
	) throws -> Void {
		try subscribeToChannel(std.string(channel))
	}
	
	/// Ceases listening for events from the specified channel
	///
	/// The available channels are:
	///
	/// "thread2" for events regarding threads;
	///
	/// "store" for events regarding stores;
	///
	/// "thread2/[threadId]/messages" for events regarding messages in a particular thread;
	///
	/// "store/[storeId]/files" for files in a particular store.
	///
	/// - Parameter channel: Which events should start arriving
	///
	/// - Throws: `PrivMXEndpointError.failedUnsubscribingFromChannel` if an exception was thrown in C++ code, or another error occurred.
	public func unsubscribeFromChannel(
		_ channel: String
	) throws -> Void {
		try unsubscribeFromChannel(std.string(channel))
	}
}
