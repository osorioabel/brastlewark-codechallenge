//
//  AppCoordinator.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import Foundation
import UIKit
class AppCoordinator: Coordinator {

	// MARK: - Properties
	var rootViewController: UIViewController {
		let coordinator = coordinators.popFirst()!.1
		return coordinator.rootViewController
	}
	fileprivate var window: UIWindow
	fileprivate var coordinators: CoordinatorsDictionary

	// MARK: - Initializers
	init(window: UIWindow) {
		self.window = window
		coordinators = [:]
	}

	// MARK: - Coordinator
	func start() {
		showGnomesList()
	}

	// MARK: Helpers
	fileprivate func showGnomesList() {
		let gnomeCoordinator = GnomeCoordinator()
		coordinators[String(describing: gnomeCoordinator)] = gnomeCoordinator
		window.rootViewController = gnomeCoordinator.rootViewController
		gnomeCoordinator.start()
	}
}
