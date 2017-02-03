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

protocol GnomeTableViewCellDelegate: class {
	func gnomeTableViewCellDelegate(_ cell: GnomeTableViewCell, didTapGnome gnome: Gnome)
}
class GnomeTableViewCell: UITableViewCell {

	// MARK: - IBOutlet properties
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!
	@IBOutlet weak var ponyimageView: RemoteImageView!
	
	// MARK: - Private properties
	fileprivate let disposeBag = DisposeBag()
	fileprivate let viewModel = GnomeTableViewCellViewModel()
	fileprivate let primaryAttributes = TextAttributes()
		.font(Font.sfUiTextRegular.uiFont(size: 30).monospaced())
		.foregroundColor(.gnomesPrimaryTextColor())
		.lineSpacing(2.0)
	fileprivate let secondaryAttributes = TextAttributes()
		.font(Font.sfUiTextRegular.uiFont(size: 13))
		.foregroundColor(.gnomesSecondaryTextColor())
		.lineSpacing(2.0)
	
	
	// MARK: - Internal Properties
	weak var delegate: GnomeTableViewCellDelegate?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		self.selectionStyle = .none
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
		// description
		viewModel.gnome
			.asObservable()
			.subscribeNext { [unowned self] in
				let attributes = TextAttributes()
					.font(Font.sfUiTextRegular.uiFont(size: 13))
					.foregroundColor(.gnomesSecondaryTextColor())
					.lineSpacing(2.0)
				
				let string = NSMutableAttributedString(string: "", attributes: attributes)
				if let age = $0?.age {
					string.append(NSAttributedString(string: "Age: %d years old".localizedFormat(age), attributes: attributes))
				}
				if let weight = $0?.weight{
					string.append(NSAttributedString(string: "\nWeight: %.2f lbs".localizedFormat(weight), attributes: attributes))
				}
				if let height = $0?.height{
					string.append(NSAttributedString(string: "\nHeight: %.2f cm".localizedFormat(height), attributes: attributes))
				}
				self.detailLabel.attributedText = string
			}
			.addDisposableTo(disposeBag)

		viewModel.imageURL
			.asObservable()
			.subscribeNext { [unowned self] (url) in
				guard let url = url else { return }
				self.ponyimageView.url = url
			}.addDisposableTo(disposeBag)
	}
	
	// MARK: - Internal methods
	func update(gnome:Gnome){
		viewModel.gnome.value = gnome
	}
	
	func selectGnome(){
		
	}
    
}
