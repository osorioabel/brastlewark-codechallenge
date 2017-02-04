//
//  Decoder+StringArray.swift
//  Brastlewark
//
//  Created by Abel Osorio on 2/4/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import Foundation
import Gloss

extension Decoder {

	static func decodeStringArray(key: String, json: JSON) -> String? {

		if let stringArray = json.valueForKeyPath(keyPath:key) as? [String] {
			return stringArray.joined(separator:", ")
		}

		return nil
	}

}
