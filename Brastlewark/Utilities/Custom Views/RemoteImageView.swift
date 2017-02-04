//
//  RemoteImageView.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class RemoteImageView: UIImageView {
	// MARK: - Private properties
	fileprivate var disposeBag = DisposeBag()
	fileprivate var loading = false {
		didSet {
			DispatchQueue.main.async { [weak self] in
				if self?.loading ?? false {
					self?.activityIndicatorView.startAnimating()
				} else {
					self?.activityIndicatorView.stopAnimating()
				}
			}
		}
	}
	fileprivate let activityIndicatorView: UIActivityIndicatorView = { (_) in
		let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
		activityIndicatorView.color = .black
		return activityIndicatorView
	}()

	// MARK: - Internal properties
	var url: URL? {
		didSet {
			guard url != oldValue else { return }

			// Cancel any previous request
			disposeBag = DisposeBag()
			image = nil
			if let url = url {
				loadImageFrom(url: url)
			}
		}
	}
	// MARK: - Initialization methods
	init(url: URL) {
		self.url = url
		super.init(frame: .zero)
		addSubview(activityIndicatorView)

		activityIndicatorView.snp.makeConstraints { (make) in
			make.center.equalTo(self)
			make.height.width.equalTo(30)
		}
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	// MARK: - Private methods
	fileprivate func loadImageFrom(url: URL) {
		loading = true
		URLSession.shared
			.rx.data(request: URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5.0))
			.map {
				UIImage(data: $0)
			}
			.doOnError { [unowned self] (_) in
				self.loading = false
			}
			.observeOn(MainScheduler.instance)
			.bindTo(rx.image)
			.addDisposableTo(disposeBag)
	}
}
