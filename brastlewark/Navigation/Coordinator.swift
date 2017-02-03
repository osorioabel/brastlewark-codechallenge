//
//  Coordinator.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import UIKit
typealias CoordinatorsDictionary = [String: Coordinator]

protocol Coordinator {
	var rootViewController: UIViewController { get }
	
	func start()
}

extension Coordinator {
	static var name: String {
		return String(describing: self)
	}
}
