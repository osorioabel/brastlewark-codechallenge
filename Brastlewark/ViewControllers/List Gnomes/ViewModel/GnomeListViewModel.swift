//
//  GnomeListViewModel.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyUserDefaults

protocol GnomeListViewModelCoordinatorDelegate: class {
	func gnomeListViewModel(_ viewModel: GnomeListViewModel, didTapGnome gnome: Gnome)
}

class GnomeListViewModel {
	// MARK: - Private properties
	fileprivate let disposeBag = DisposeBag()
	fileprivate let searchResults = Variable<[Gnome]>([])
	
	// MARK: - Internal properties
	weak var coordinatorDelegate: GnomeListViewModelCoordinatorDelegate?
	let gnomes = Variable<[Gnome]>([])
	var cachedGnomes:[Gnome]
	let query = Variable<String>("")
	
	init() {
		cachedGnomes = Defaults[.recentlyDonwloadedGnomes]
		setupRx()
	}

	func setupRx(){
		let observedQuery = query.asObservable()
			.throttle(0.3, scheduler: MainScheduler.instance)
			.distinctUntilChanged()
			.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
		
		observedQuery
			.filter{ $0.characters.count >= 3}
			.map { [unowned self] (query) in
				self.filterGnomeByName(query: query)
			}
			.map { $0 }
			.bindTo(searchResults)
			.addDisposableTo(disposeBag)
		observedQuery
			.filter { $0.characters.count < 3 }
			.map { [unowned self] (_) in return self.cachedGnomes }
			.bindTo(gnomes)
			.addDisposableTo(disposeBag)

		searchResults.asObservable()
			.filter { (_) in self.query.value.characters.count >= 3 }
			.map { $0 }
			.bindTo(gnomes)
			.addDisposableTo(disposeBag)
	}

	fileprivate func filterGnomeByName(query: String) -> [Gnome] {
		let searchArray = self.gnomes.value
		let results:[Gnome] = searchArray.filter({ ($0.name?.contains(query))!})
			if results.count > 0{
				return results
			}
		return []
	}
	func getGnomes() -> Observable<Void> {
		return GnomesAPI.listGnomes()
			.map { [unowned self] in
				self.gnomes.value = $0
				DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
					Defaults[.recentlyDonwloadedGnomes] = self.gnomes.value
					self.cachedGnomes = Defaults[.recentlyDonwloadedGnomes]
				}
				return ()
		}
	}
	
	func showDetail(gnome gnomeSelected: Gnome) {
		coordinatorDelegate?.gnomeListViewModel(self, didTapGnome: gnomeSelected)
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
