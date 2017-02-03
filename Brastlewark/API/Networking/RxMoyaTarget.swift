//
//  RxMoyaTarget.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import Foundation
import UIKit
import Moya
import Alamofire

enum RxMoyaTarget {
	
	//Gnomes
	case getGnomes
}

extension RxMoyaTarget: TargetType {
	var baseURL: URL {
		return URL(string: "https://raw.githubusercontent.com/")!
	}
	var path: String {
		switch self {
		default:
			return "rrafols/mobile_test/master/data.json"
		}
	}
	var method: Moya.Method {
		switch self {
		default:
			return .get
		}
	}
	var parameters: [String: Any]? {
		switch self {
		default:
			return nil
		}
	}
	var sampleData: Data {
		return SampleDataHelper.sampleFor(target: self)
	}
	var task: Task {
		switch self {
		default:
			return .request
		}
	}
	var validate: Bool {
		return false
	}
	var parameterEncoding: ParameterEncoding {
		switch self {
		default:
			return URLEncoding.default
		}
	}
	
	// MARK: - Internal functions
	func endpoint() -> Endpoint<RxMoyaTarget> {
		var endpoint: Endpoint<RxMoyaTarget>
		endpoint = MoyaProvider.defaultEndpointMapping(for: self)
		return endpoint
	}
}
