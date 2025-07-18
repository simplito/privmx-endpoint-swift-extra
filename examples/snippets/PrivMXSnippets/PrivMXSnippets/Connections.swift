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
import PrivMXEndpointSwift
import PrivMXEndpointSwiftExtra
import PrivMXEndpointSwiftNative

class PrivMXSnippetClass {
    var endpointContainer: PrivMXEndpointContainer?
    var endpointSession: PrivMXEndpoint?
    var publicEndpointSession: PrivMXEndpoint?
    var endpointId: Int64 = 0
    
    /*
    All the values below like BRIDGE_URL, SOLUTION_ID, CONTEXT_ID
    should be replaced by the ones corresponding to your Bridge Server instance.
    
    The private keys here are for demonstration purposes only.
    Normally, they should be kept separately by each user and stored in a safe place,
    or generated from a password (see the derivePrivateKey2() method in the Crypto API)
    */

    let BRIDGE_URL = "YOUR_BRIDGE_URL";
    let SOLUTION_ID = "YOUR_SOLUTION_ID";
    let CONTEXT_ID = "YOUR_CONTEXT_ID";

    let USER1_ID = "user_1";
    let USER1_PUBLIC_KEY = "PUBLIC_KEY_1";
    let USER1_PRIVATE_KEY = "PRIVATE_KEY_1";

    let USER2_ID = "user_2";
    let USER2_PUBLIC_KEY = "PUBLIC_KEY_2";

    let USER3_ID = "user_3";
    let USER3_PUBLIC_KEY = "PUBLIC_KEY_3";


    func setup() async throws {
        // Initialize the `PrivMXEndpointContainer`
        let endpointContainer = PrivMXEndpointContainer()

        // Set the path to the certificate matching Your installation
        guard let pathToCerts = Bundle.main.path(forResource: "cacert", ofType: "pem") else { return }
        try endpointContainer.setCertsPath(to: pathToCerts)

        // Establish a new `PrivMXEndpoint` session
        var endpointSession = try await endpointContainer.newEndpoint(
			enabling: [.thread,.store,.inbox,.event],
            connectingAs: USER1_PRIVATE_KEY,
            to: SOLUTION_ID,
            on: BRIDGE_URL
        )
        
        self.endpointContainer  = endpointContainer
        self.endpointSession = endpointSession
        
    }
    
    func setupBasic() async throws{
        // Set the path to the certificate matching Your installation
        guard let pathToCerts = Bundle.main.path(forResource: "cacert", ofType: "pem") else {return}
        try? Connection.setCertsPath(pathToCerts)
        // Establish a new `PrivMXEndpoint` session
        var endpointSession = try? PrivMXEndpoint(
			modules: [.thread,.store,.inbox,.event, .kvdb],
            userPrivKey: USER1_PRIVATE_KEY,
            solutionId: SOLUTION_ID,
            bridgeUrl: BRIDGE_URL)
        
        self.endpointSession = endpointSession
    }

    func setupBasic2() async throws{
        // Set the path to the certificate matching Your installation
        guard let pathToCerts = Bundle.main.path(forResource: "cacert", ofType: "pem") else {return}
        try? Connection.setCertsPath(pathToCerts)
        // Establish connection
        guard var connection = try? Connection.connect(
            as: USER1_PRIVATE_KEY,
            to: BRIDGE_URL,
            on: CONTEXT_ID) as? Connection
        else {return}
        // Init required API's
        guard var storeApi = try? StoreApi.create(connection: &connection) else {return}
        guard var threadApi = try? ThreadApi.create(connection: &connection) else {return}
        guard let inboxApi = try? InboxApi.create(
            connection: &connection,
            threadApi: &threadApi,
            storeApi: &storeApi) else {return}
		guard let eventApi = try? EventApi.create(connection: &connection) else {return}
                                     
    }
    
    func gettingEndpointSessionFromContainer()
    {
        let endpointSessionId:Int64 = 0
        let endpointSession = endpointContainer?.getEndpoint(endpointSessionId)
        //by passing value indexed by connectionID
    }
    
	func settingUserVerifier(){
		
		endpointSession?.connection.setUserVerifier({
			requestHolder in
			var result = [Bool]()
			for req in requestHolder.requestVector{
				var reqResult:Bool = true // this is the default when no implementation is provided
				// Some verification code for the request
				result.append(reqResult)
			}
			return privmx.VerificationResult.init(resultVector: .init(from: result))
		})
	}
	
	func gettingContextUsers(){
		let contextUserInfo = endpointSession?.connection.getContextUsers(of: CONTEXT_ID)
	}
	
    func teardown() {
        // Disconnect and clean up
        try? endpointContainer?.disconnectAll()
        endpointSession = nil
        endpointContainer = nil
    }
}
