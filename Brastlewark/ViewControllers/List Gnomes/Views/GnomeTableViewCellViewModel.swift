//
//  GnomeTableViewCellViewModel.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import Foundation
import RxSwift
import Localize_Swift

struct GnomeTableViewCellViewModel {
	fileprivate let disposeBag = DisposeBag()

	// MARK: - Internal properties
	let gnome = Variable<Gnome?>(nil)
	let name = Variable<String?>(nil)
	let imageURL = Variable<URL?>(nil)

	init() {
		setupRx()
	}

	// MARK: - Rx functions
	fileprivate func setupRx() {
		gnome.asObservable()
			.map { $0?.name ?? "" }
			.bindTo(name)
			.addDisposableTo(disposeBag)
		gnome.asObservable()
			.map { $0?.thumbnail ?? nil }
			.bindTo(imageURL)
			.addDisposableTo(disposeBag)
	}
}
