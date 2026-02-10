//
// PrivMX Endpoint Swift Extra
// Copyright © 2026 Simplito sp. z o.o.
//
// This file is part of the PrivMX Platform (https://privmx.dev).
// This software is Licensed under the MIT License.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//

import PrivMXEndpointSwiftNative
import PrivMXEndpointSwift

public extension privmx.NativeStreamApiLowWrapper {
	static func createFromPrivMXEndpoint(
		_ endpoint: PrivMXEndpoint
	) throws -> privmx.NativeStreamApiLowWrapper {
		if var connection = (endpoint.connection as? Connection), var eventApi = endpoint.eventApi {
			let res = privmx.NativeStreamApiLowWrapper.create(connection.api, &eventApi.api)
			if let err = res.error.value{
				throw PrivMXEndpointError.otherFailure(err)
			}
			guard let result = res.result.value else {
				var err = privmx.InternalError()
				err.name = "Value error"
				err.description = "Unexpectedly received nil result"
				throw PrivMXEndpointError.failedCreatingStore(err)
			}
			return result
			
		} else {
			throw PrivMXEndpointError.otherFailure(privmx.InternalError(name: "Misconfigured PrivMXEndpoint", message: "StreamApiLow requires Connection and EventApi to be present", description: ""))
		}
	}
}
