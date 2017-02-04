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
	var gender: String?
	var weight: Float?
	var height: Float?
	var hairColor: String?
	var professions: String?
	var friends: String?

	// MARK: - Enums and Structs
	fileprivate struct JSONKey {
		static let id = "id"
		static let name = "name"
		static let thumbnail = "thumbnail"
		static let age = "age"
		static let gender = "gender"
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
		professions = Decoder.decodeStringArray(key: JSONKey.professions, json: json)
		friends = Decoder.decodeStringArray(key: JSONKey.friends, json: json)
		gender = ["Female", "Male"].randomElement
	}

	// MARK: - Encodable protocol conformance
	func toJSON() -> JSON? {
		return jsonify([JSONKey.id ~~> id,
		                JSONKey.name ~~> name,
		                JSONKey.age ~~> age,
		                JSONKey.gender ~~> gender,
		                JSONKey.weight ~~> weight,
		                JSONKey.height ~~> height,
		                JSONKey.thumbnail ~~> thumbnail,
		                JSONKey.hairColor ~~> hairColor,
		                Encoder.encodeStringArray(key: JSONKey.professions, value:professions),
		                Encoder.encodeStringArray(key: JSONKey.friends, value:friends)
			])
	}
}
