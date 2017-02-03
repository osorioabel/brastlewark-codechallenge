//
//  Gnome.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import Foundation
import Gloss

class Gnome: Decodable, Encodable {
	
	// MARK: - Properties
	var id: Int
	var name: String?
	var thumbnail: URL?
	var age: Int?
	var weight: Float?
	var height: Float?
	var hairColor: String?
	var professions: [String]
	var friends: [String]
	
	// MARK: - Enums and Structs
	fileprivate struct JSONKey {
		static let id = "id"
		static let name = "name"
		static let thumbnail = "thumbnail"
		static let age = "age"
		static let weight = "weight"
		static let height = "height"
		static let hairColor = "hair_color"
		static let professions = "professions"
		static let friends = "friends"
	}
	
	// MARK: - Initialization
	required init?(json: JSON) {
		guard let id: Int = JSONKey.id <~~ json
			else { return nil }
		self.id = id
		name = JSONKey.name <~~ json
		if let thumbnail: String = JSONKey.thumbnail <~~ json {
			self.thumbnail = URL(string: thumbnail)
		} else {
			self.thumbnail = nil
		}
		age = JSONKey.age <~~ json
		weight = JSONKey.weight <~~ json
		height = JSONKey.height <~~ json
		hairColor = JSONKey.hairColor <~~ json
		professions = (JSONKey.professions <~~ json)!
		friends = (JSONKey.friends <~~ json)!
	}
	
	// MARK: - Encodable protocol conformance
	func toJSON() -> JSON? {
		return jsonify([JSONKey.id ~~> id,
		                JSONKey.name ~~> name,
			])
	}
}
