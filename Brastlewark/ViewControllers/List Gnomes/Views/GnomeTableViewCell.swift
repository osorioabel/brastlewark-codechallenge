//
//  GnomeTableViewCell.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift
import TextAttributes

class GnomeTableViewCell: UITableViewCell {

	// MARK: - IBOutlet properties
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var thumbnailImageView: RemoteImageView!
	
	// MARK: - Private properties
	fileprivate let disposeBag = DisposeBag()
	fileprivate let viewModel = GnomeTableViewCellViewModel()
	fileprivate let primaryAttributes = TextAttributes()
		.font(Font.sfUiTextRegular.uiFont(size: 30).monospaced())
		.foregroundColor(.gnomesPrimaryTextColor())
		.lineSpacing(2.0)
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		self.selectionStyle = .none
		let imagePinchGesture = ImagePinchGestureRecognizer()
		imagePinchGesture.delegate = self
		self.thumbnailImageView.isUserInteractionEnabled = true
		self.thumbnailImageView.addGestureRecognizer(imagePinchGesture)
		setupRx()
    }
	
	// MARK: - Rx methods
	fileprivate func setupRx() {
		viewModel.name
			.asObservable()
			.map { [unowned self] (name) in
				if let name = name {
					let string = NSMutableAttributedString(string: "", attributes: self.primaryAttributes)
					string.append(NSAttributedString(string: "%@".localizedFormat(name), attributes: self.primaryAttributes))
					return string
				}
				return NSAttributedString()
			}
			.bindTo(nameLabel.rx.attributedText)
			.addDisposableTo(disposeBag)
		viewModel.imageURL
			.asObservable()
			.subscribeNext { [unowned self] (url) in
				guard let url = url else { return }
				self.thumbnailImageView.url = url
			}.addDisposableTo(disposeBag)
	}
	
	// MARK: - Internal methods
	func update(gnome:Gnome){
		viewModel.gnome.value = gnome
	}
}
