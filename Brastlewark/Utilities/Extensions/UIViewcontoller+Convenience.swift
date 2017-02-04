//
//  UIViewcontoller+Convenience.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import Foundation
import Moya

extension UIAlertController {
	class func showFromViewController(_ viewController: UIViewController,
	                                  title: String = "Brastlewark".localized(),
	                                  message: String,
	                                  firstButtonTitle: String = "Close".localized(), firstButtonStyle: UIAlertActionStyle = .default, firstButtonHandler: (() -> Void)? = nil,
	                                  secondButtonTitle: String? = nil, secondButtonStyle: UIAlertActionStyle = .default, secondButtonHandler: (() -> Void)? = nil) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: firstButtonTitle, style: firstButtonStyle, handler: firstButtonHandler.map { (closure) in return { (_) in closure() }}))
		if let secondButtonTitle = secondButtonTitle {
			alertController.addAction(UIAlertAction(title: secondButtonTitle, style: secondButtonStyle, handler: secondButtonHandler.map { (closure) in return { (_) in closure() }}))
		}
		viewController.present(alertController, animated: true, completion: nil)
	}

	class func messageFor(error: Swift.Error) -> String {
		var errorDescription: String
		switch error {
		case let error as ApiError:
			errorDescription = "Error \(error.code):"
			if let description = error.description {
				errorDescription += " \(description)"
			}
		case let error as CustomStringConvertible:
			errorDescription = error.description
		case let error as MoyaError:
			if case .underlying(let underlyingError as NSError) = error {
				errorDescription = underlyingError.localizedDescription
				if let failureReason = underlyingError.localizedFailureReason {
					errorDescription += " (\(failureReason))"
				}
			} else {
				let error = error as NSError
				errorDescription = error.localizedDescription
				if let failureReason = error.localizedFailureReason {
					errorDescription += " (\(failureReason))"
				}
			}
		case let error as NSError:
			errorDescription = error.localizedDescription
			if let failureReason = error.localizedFailureReason {
				errorDescription += " (\(failureReason))"
			}
		default:
			errorDescription = "An unknown error occurred".localized()
		}
		return errorDescription
	}

	class func showFromViewController(_ viewController: UIViewController, forError error: Swift.Error, closeButtonHandler: (() -> Void)? = nil) {
		showFromViewController(viewController, message: messageFor(error: error), firstButtonHandler: closeButtonHandler)
	}
}
