//
//  SampleDataHelper.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import Foundation

struct SampleDataHelper {
	static func sampleFor(target: RxMoyaTarget) -> Data {
		return "".data(using: String.Encoding.utf8)!
	}
}
