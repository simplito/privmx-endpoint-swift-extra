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

/// Modules that can be initialized by `PrivMXEndpoint`.
public enum PrivMXModule{
	case thread
	case store
	case inbox
}
