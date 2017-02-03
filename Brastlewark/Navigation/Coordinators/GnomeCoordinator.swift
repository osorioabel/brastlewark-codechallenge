//
//  GnomeCoordinator.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import Foundation
import UIKit

class GnomeCoordinator: Coordinator {
	// MARK: - Properties
	var rootViewController: UIViewController
	fileprivate var coordinators: [String: Coordinator]
	fileprivate var navigationController: UINavigationController {
		if let navigationController = rootViewController  as? UINavigationController {
			return navigationController
		}
		return UINavigationController()
	}
	
	// MARK: - Initializers
	init() {
		rootViewController = UINavigationController()
		coordinators = [:]
	}
	
	// MARK: - Coordinator
	func start() {
		showGnomesListScreen()
	}
	
	// MARK: - Helpers
	fileprivate func showGnomesListScreen() {
		let gnomesListVM = GnomeListViewModel()
		let gnomesListVC = GnomesListViewController(viewModel: gnomesListVM)
		gnomesListVM.coordinatorDelegate = self
		navigationController.setViewControllers([gnomesListVC], animated: true)
	}
	
	fileprivate func goToDetail(_ gnome: Gnome) {
		let gnomeDetailVM = GnomeDetailViewModel(with: gnome)
		let gnomeDetailVC = GnomeDetailViewController(viewModel: gnomeDetailVM)
		navigationController.pushViewController(gnomeDetailVC, animated: true)
	}
}

// MARK: - PoniesListViewModelCoordinatorDelegate
extension GnomeCoordinator : GnomeListViewModelCoordinatorDelegate {
	func gnomeListViewModel(_ viewModel: GnomeListViewModel, didTapGnome gnome: Gnome) {
		goToDetail(gnome)
	}
}
