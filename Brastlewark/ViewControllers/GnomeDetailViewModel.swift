//
//  GnomeDetailViewModel.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/3/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import Foundation
import RxSwift
import TextAttributes

struct GnomeDetailViewModel {
	// MARK: - Private properties
	fileprivate let disposeBag = DisposeBag()
	fileprivate let primaryAttributes = TextAttributes()
		.font(Font.sfUiTextRegular.uiFont(size: 16).monospaced())
		.foregroundColor(.gnomesPrimaryTextColor())
		.lineSpacing(2.0)
	
	// MARK: - Internal properties
	weak var coordinatorDelegate: GnomeListViewModelCoordinatorDelegate?
	var gnome = Variable<Gnome?>(nil)
	let name = Variable<String>("")
	let detail = Variable<NSAttributedString>(NSAttributedString())
	let gnomeImageURL = Variable<URL?>(nil)
	
	init(with gnomes: Gnome) {
		gnome = Variable(gnomes)
		setupRx()
	}
	
	// MARK: - Rx methods
	func setupRx() {
		gnome.asObservable()
			.map{ $0?.name ?? "" }
			.bindTo(name)
			.addDisposableTo(disposeBag)
		gnome.asObservable()
			.map{ $0?.thumbnail ?? nil }
			.bindTo(gnomeImageURL)
			.addDisposableTo(disposeBag)
		gnome.asObservable()
			.map {
				let detailText = NSMutableAttributedString(string: "", attributes: self.primaryAttributes)
				if let age = $0?.age {
					detailText.append(NSAttributedString(string: "Age: %d years old".localizedFormat(age), attributes: self.primaryAttributes))
				}
				if let weight = $0?.weight{
					detailText.append(NSAttributedString(string: "\nWeight: %.2f lbs".localizedFormat(weight), attributes: self.primaryAttributes))
				}
				if let height = $0?.height{
					detailText.append(NSAttributedString(string: "\nHeight: %.2f cm".localizedFormat(height), attributes: self.primaryAttributes))
				}
				return detailText
			}
			.bindTo(detail)
			.addDisposableTo(disposeBag)
	}
}
