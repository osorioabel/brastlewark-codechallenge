//
//  Encoder+StringArray.swift
//  Brastlewark
//
//  Created by Abel Osorio on 2/4/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import Foundation
import Gloss

extension Encoder {

	static func encodeStringArray(key: String, value: String?) -> JSON? {

		if let value = value {
			return [key: value.components(separatedBy: [","])]
		}
		return nil
	}

}
