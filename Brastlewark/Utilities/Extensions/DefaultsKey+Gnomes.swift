//
//  DefaultsKey+Gnomes.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/3/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import Gloss

extension DefaultsKeys {
	static let recentlyDonwloadedGnomes = DefaultsKey<[Gnome]>("recentlyDonwloadedGnomes")
}

extension UserDefaults {
	func archive<T: Encodable>(_ key: SwiftyUserDefaults.DefaultsKey<[T]>, _ value: [T]) {
		if let json = value.toJSONArray() {
			set(NSKeyedArchiver.archivedData(withRootObject: json), forKey: key._key)
		}
	}

	func unarchive<T: Decodable>(_ key: SwiftyUserDefaults.DefaultsKey<[T]>) -> [T]? {
		return data(forKey: key._key)
			.flatMap { NSKeyedUnarchiver.unarchiveObject(with: $0) as? [JSON] }
			.flatMap { [T].from(jsonArray: $0) }
	}

	subscript(key: DefaultsKey<[Gnome]>) -> [Gnome] {
		get { return unarchive(key) ?? [] }
		set { archive(key, newValue) }
	}
}
