//
//  Foundation+Gnomes.swift
//  Brastlewark
//
//  Created by Abel Osorio on 2/4/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import Foundation
extension Array {
	var randomElement: Element {
		let index = Int(arc4random_uniform(UInt32(count)))
		return self[index]
	}
}
