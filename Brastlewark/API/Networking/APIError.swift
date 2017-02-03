//
//  APIError.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import Foundation
import Gloss

struct ApiError: Error {
	let code: Int
	let description: String?
}

enum ApiErrorCode: Int {
	// Internal error codes
	case unknown           = -100
	case missingJwtKey     = -101
	case couldNotSignToken = -102
	case castingError      = -103
	
	// General error codes
	case invalidApiKey = -1000
	
	// User error codes
}

extension ApiError: Decodable {
	fileprivate struct JsonKeys {
		static let code = "code"
		static let description = "message"
	}
	
	init?(json: JSON) {
		guard let code: Int = JsonKeys.code <~~ json
			else { return nil }
		self.code = code
		self.description = JsonKeys.description <~~ json
	}
}
