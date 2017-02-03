//
//  UIFont+Gnomes.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import UIKit

enum Font {
	case ubuntu
	case ubuntuMedium
	case ubuntuLight
	case ubuntuBold
	case sfUiTextRegular
	case sfUiTextLight
	case sfUiTextBold
	case sfUiTextMedium
	case sfUiDisplayLight
	
	func uiFont(size: CGFloat) -> UIFont {
		let name: String
		switch self {
		case .ubuntu:
			name = "Ubuntu"
		case .ubuntuMedium:
			name = "Ubuntu-Medium"
		case .ubuntuLight:
			name = "Ubuntu-Light"
		case .ubuntuBold:
			name = "Ubuntu-Bold"
		case .sfUiTextRegular:
			name = "SFUIText-Regular"
		case .sfUiTextLight:
			name = "SFUIText-Light"
		case .sfUiTextBold:
			name = "SFUIText-Bold"
		case .sfUiTextMedium:
			name = "SFUIText-Medium"
		case .sfUiDisplayLight:
			name = "SFUIDisplay-Light"
		}
		return UIFont(name: name, size: size)!
	}
}

extension UIFont {
	static func listFonts() {
		let fontFamilyNames = UIFont.familyNames
		for familyName in fontFamilyNames {
			print("------------------------------")
			print("Font Family Name = [\(familyName)]")
			let names = UIFont.fontNames(forFamilyName: familyName)
			print("Font Names = [\(names)]")
		}
	}
	
	func monospaced() -> UIFont {
		let fontFeatures = [
			[UIFontFeatureTypeIdentifierKey: kNumberSpacingType,
				UIFontFeatureSelectorIdentifierKey: kMonospacedNumbersSelector]
		]
		let descriptorWithFeatures = fontDescriptor.addingAttributes([UIFontDescriptorFeatureSettingsAttribute: fontFeatures])
		return UIFont(descriptor: descriptorWithFeatures, size: 0)
	}
}
