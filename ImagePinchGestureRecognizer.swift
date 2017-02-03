//
//  ImagePinchGestureRecognizer.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class ImagePinchGestureRecognizer: UIPinchGestureRecognizer {
	// MARK: - Private Properties
	private let backgroundView = UIView()
	private let imageView = UIImageView()
	private var initialPoint: CGPoint?
	
	// MARK: - Touch methods
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesBegan(touches, with: event)
		
		if touches.count == 2 {
			begin()
		} else {
			state = .possible
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesEnded(touches, with: event)
		state = .ended
		
		end()
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesMoved(touches, with: event)
		
		switch state {
		case .possible where touches.count == 2:
			begin()
			fallthrough
		case .began:
			state = .changed
			fallthrough
		case .changed where touches.count == 2:
			let window = view?.window
			
			let averagePosition = touches
				.map { $0.location(in: window) }
				.reduce(CGPoint.zero) {
					return CGPoint(x: $0.x + $1.x / CGFloat(touches.count), y: $0.y + $1.y / CGFloat(touches.count))
			}
			
			var transform: CGAffineTransform
			let distanceSquared: CGFloat
			
			if let initialPoint = initialPoint {
				transform = CGAffineTransform(translationX: averagePosition.x - initialPoint.x, y: averagePosition.y - initialPoint.y)
				distanceSquared = (averagePosition.x - initialPoint.x) * (averagePosition.x - initialPoint.x) + (averagePosition.y - initialPoint.y) * (averagePosition.y - initialPoint.y)
			} else {
				initialPoint = averagePosition
				transform = CGAffineTransform.identity
				distanceSquared = 0
			}
			let scale = max(self.scale, 1.0)
			transform = transform.concatenating(CGAffineTransform(scaleX: scale, y: scale))
			
			UIView.animate(
				withDuration: 0.1,
				delay: 0.0,
				options: .curveEaseOut,
				animations: { [unowned self] in
					self.backgroundView.backgroundColor = UIColor(white: 0.0, alpha: min(max(distanceSquared, 1.0) * scale * 10, 10000) / 10000 * 0.7)
					self.imageView.transform = transform
				},
				completion: nil
			)
		default:
			break
		}
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesCancelled(touches, with: event)
		state = .cancelled
		
		end()
	}
	
	override func reset() {
		super.reset()
		state = .possible
	}
	
	// MARK: - Private methods
	private func begin() {
		guard let view = view as? UIImageView, let window = view.window else {
			state = .failed
			return
		}
		
		initialPoint = nil
		
		view.isHidden = true
		
		imageView.image = view.image
		imageView.translatesAutoresizingMaskIntoConstraints = true
		imageView.frame = window.convert(view.frame, from: view.superview)
		
		backgroundView.frame = window.bounds
		backgroundView.backgroundColor = .clear
		backgroundView.addSubview(imageView)
		window.addSubview(backgroundView)
		
		state = .began
	}
	
	private func end() {
		guard let view = view else { return }
		
		UIView.animate(
			withDuration: 0.3,
			delay: 0.0,
			options: .curveEaseOut,
			animations: { [unowned self] in
				self.backgroundView.backgroundColor = .clear
				self.imageView.transform = CGAffineTransform.identity
			},
			completion: { [unowned self] (_) in
				view.isHidden = false
				self.backgroundView.removeFromSuperview()
			}
		)
	}
}
