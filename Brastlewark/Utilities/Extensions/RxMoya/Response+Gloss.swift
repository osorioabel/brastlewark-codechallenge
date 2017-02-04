//
//  Response+Gloss.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import Foundation
import Moya
import Gloss

extension Response {
	func mapObject<T: Decodable>() throws -> T {
		guard let json = try mapJSON() as? JSON, let object = T(json: json) else {
			throw Moya.MoyaError.jsonMapping(self)
		}
		return object
	}

	func mapArray<T: Decodable>() throws -> [T] {
		guard let jsonArray = try mapJSON() as? [JSON] else {
			throw Moya.MoyaError.jsonMapping(self)
		}

		return [T].from(jsonArray: jsonArray) ?? []
	}
}
