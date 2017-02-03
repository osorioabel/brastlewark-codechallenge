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
	fileprivate let searchResults = Variable([Gnome]())
	
	// MARK: - Internal properties
	weak var coordinatorDelegate: GnomeListViewModelCoordinatorDelegate?
	let gnomes: Variable<[Gnome]>
	let query = Variable<String>("")
	
	init() {
		gnomes = Variable([Gnome]())
		
		setupRx()
	}

	func setupRx(){

		query.asObservable()
			.throttle(0.3, scheduler: MainScheduler.instance)
			.distinctUntilChanged()
			.map {
				let query = $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
				return self.filterGnomeByName(query: query)
			}
			.bindTo(searchResults)
			.addDisposableTo(disposeBag)

		query.asObservable()
			.filter { $0.characters.count < 3 }
			.map { (_) in return [] }
			.bindTo(gnomes)
			.addDisposableTo(disposeBag)

		searchResults.asObservable()
			.filter { (_) in self.query.value.characters.count >= 3 }
			.map { $0}
			.bindTo(gnomes)
			.addDisposableTo(disposeBag)
	}

	fileprivate func filterGnomeByName(query: String) -> [Gnome] {
		let results:[Gnome] = self.gnomes.value.filter({ ($0.name?.contains(query))!})
			if results.count > 0{
				return results
			}
		return []
	}
	func getGnomes() -> Observable<Void> {
		return GnomesAPI.listGnomes()
			.map { [unowned self] in
				self.gnomes.value = $0
				return ()
		}
	}
	
	func showDetail(gnome gnomeSelected: Gnome) {
		coordinatorDelegate?.gnomeListViewModel(self, didTapGnome: gnomeSelected)
	}
	
	func deleteAll(){
		gnomes.value = []
	}

	func search(query queryString: String) -> Observable<Void> {
		return gnomes.asObservable()
			.map{$0}
			.flatMapLatest{ (gnomes) -> Observable<[Gnome]> in
				let results = gnomes.filter({ ($0.name?.contains(queryString))!})
				if results.count > 0 {
					return Observable.just(results)
				}
				return Observable.just([])
			}
			.doOnNext{ [unowned self] in
				self.gnomes.value = $0
			}
			.map { (_) in return () }
	}
}
