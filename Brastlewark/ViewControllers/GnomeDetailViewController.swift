//
//  GnomeDetailViewController.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/3/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift
import Localize_Swift
import TextAttributes

class GnomeDetailViewController: UIViewController {
	
	// MARK: - IBOutlet
	@IBOutlet weak var thumbnailImageView: RemoteImageView!
	@IBOutlet weak var gnomeNameLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!
	
	fileprivate let primaryAttributes = TextAttributes()
		.font(Font.sfUiTextRegular.uiFont(size: 30))
		.foregroundColor(.gnomesPrimaryTextColor())
		.lineSpacing(2.0)
	
	// MARK: - Private properties
	fileprivate let disposeBag = DisposeBag()
	
	// MARK: - Properties
	var viewModel: GnomeDetailViewModel
	
	// MARK: - Life Cycle
	init(viewModel: GnomeDetailViewModel) {
		self.viewModel = viewModel
		
		super.init(nibName: String(describing: GnomeDetailViewController.self), bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupRx()
	}
	// MARK: - internal methods
	func setupView() {
		view.backgroundColor = .black
		
	}
	
	// MARK: - Rx methods
	func setupRx() {
		viewModel.name
			.asObservable()
			.map{ [unowned self] (name) in
				return NSAttributedString(string: name, attributes: self.primaryAttributes)
			}
			.bindTo(gnomeNameLabel.rx.attributedText)
			.addDisposableTo(disposeBag)
		viewModel.detail
			.asObservable()
			.map{ return $0 }
			.bindTo(detailLabel.rx.attributedText)
			.addDisposableTo(disposeBag)
		viewModel.name.asObservable()
			.map{ return $0 }
			.bindTo(self.rx.title)
			.addDisposableTo(disposeBag)
		viewModel.gnomeImageURL
			.asObservable()
			.subscribeNext { [unowned self] (url) in
				guard let url = url else { return }
				self.thumbnailImageView.url = url
			}.addDisposableTo(disposeBag)
		
	}
	
	// MARK: - Private methods
	
}
