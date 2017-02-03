//
//  GnomeListViewModel.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import Foundation
import RxSwift

protocol GnomeListViewModelCoordinatorDelegate: class {
	func gnomeListViewModel(_ viewModel: GnomeListViewModel, didTapGnome gnome: Gnome)
}

class GnomeListViewModel {
	// MARK: - Private properties
	fileprivate let disposeBag = DisposeBag()
	
	// MARK: - Internal properties
	weak var coordinatorDelegate: GnomeListViewModelCoordinatorDelegate?
	let gnomes: Variable<[Gnome]>
	
	init() {
		gnomes = Variable([Gnome]())
		setupRx()
	}
	
	fileprivate func setupRx(){
		
	}
	
	func getGnomes() -> Observable<Void> {
		return GnomesAPI.listGnomes()
			.map { [unowned self] in
				self.gnomes.value = $0
				return ()
		}
	}
	func showDetail(_ gnome: Gnome) {
		coordinatorDelegate?.gnomeListViewModel(self, didTapGnome: gnome)
	}
}
