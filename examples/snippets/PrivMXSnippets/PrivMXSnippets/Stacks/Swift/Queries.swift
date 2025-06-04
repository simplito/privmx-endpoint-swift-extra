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

extension PrivMXSnippetClass {
	
	struct AdditionalInfo:Codable{
		var category: String
		var label : String
	}
	
	struct ExampleCustomMeta:Codable{
		var status: String
		var role: String
		var score: Int
		var additionalInfo: AdditionalInfo
	}
	
	
	func querySimple(){
		let query = privmx.endpoint.core.PagingQuery(
			skip: 0,
			limit: 10,
			sortOrder: .asc,
			queryAsJson: """
				{
				"status": "active"
				}
				""")
	}
	
	func queryCompare(){
		let query = privmx.endpoint.core.PagingQuery(
			skip: 0,
			limit: 10,
			sortOrder: .asc,
			queryAsJson: """
				{
				"score":{
					"$gt": 20
					}
				}
				""")
	}
	
	func queryMultiCondition(){
		let query = privmx.endpoint.core.PagingQuery(
			skip: 0,
			limit: 10,
			sortOrder: .asc,
			queryAsJson: """
				{
				"score":{
					"$gt": 20,
					"$lt": 35
					}
				}
				""")
		
	}
	
	func queryOr(){
		let query = privmx.endpoint.core.PagingQuery(
			skip: 0,
			limit: 10,
			sortOrder: .asc,
			queryAsJson: """
				{
				"$or":[
					"score":{
						"$lt": 10
						},
					"label":{
						"$gt":30
						}
					]
				}
				""")
	}
	
	func queryAnd(){
		let queryExplicit = privmx.endpoint.core.PagingQuery(
			skip: 0,
			limit: 10,
			sortOrder: .asc,
			queryAsJson: """
				{
				"$and":[
					"score":{
						"$lt": 10
						},
					"role": "some role"
					]
				}
				""")
		let queryImplicit = privmx.endpoint.core.PagingQuery(
			skip: 0,
			limit: 10,
			sortOrder: .asc,
			queryAsJson: """
				{
				"score":{
					"$lt": 10
					},
				"role": "some role"
				}
				""")
	}
	
	func queryNested(){
		let queryExplicit = privmx.endpoint.core.PagingQuery(
			skip: 0,
			limit: 10,
			sortOrder: .asc,
			queryAsJson: """
				{
				"additionalInfo.label": "some label"
				}
				""")
	}
	
}
