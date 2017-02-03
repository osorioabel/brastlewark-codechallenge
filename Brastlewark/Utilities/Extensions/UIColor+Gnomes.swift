//
//  UIColor+Gnomes.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import UIKit

extension UIColor {
	convenience init(intRed: Int, intGreen: Int, intBlue: Int, alpha: Float = 1.0) {
		self.init(red: CGFloat(intRed) / 255.0, green: CGFloat(intGreen) / 255.0, blue: CGFloat(intBlue) / 255.0, alpha: CGFloat(alpha))
	}
	
	static func gnomesBlueColor() -> UIColor {
		return UIColor(intRed: 2, intGreen: 157, intBlue: 192)
	}
	
	/**
	User input copy, table/list headers
	*/
	static func gnomesPrimaryTextColor() -> UIColor {
		return .white
	}
	
	/**
	Body copy, placeholder text
	*/
	static func gnomesSecondaryTextColor() -> UIColor {
		return .white
	}
	
	// Navigation Bar
	static func gnomesNavigationBarColor() -> UIColor {
		return .black
	}
	
	static func gnomesNavigationBarTintColor() -> UIColor {
		return gnomesBlueColor()
	}
	
	static func gnomesStatusBarStyle() -> UIStatusBarStyle {
		return .default
	}
}
