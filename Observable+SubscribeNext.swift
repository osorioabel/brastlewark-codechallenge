//
//  Observable+SubscribeNext.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Observable {
	func subscribeNext(_ onNext: ((Element) -> Void)?) -> Disposable {
		return subscribe(onNext: onNext)
	}
	
	func subscribeError(_ onError: ((Error) -> Void)?) -> Disposable {
		return subscribe(onError: onError)
	}
	
	func subscribeCompleted(_ onCompleted: (() -> Void)?) -> Disposable {
		return subscribe(onCompleted: onCompleted)
	}
	
	func doOnNext(_ onNext: ((Element) throws -> Void)?) -> Observable<Element> {
		return `do`(onNext: onNext)
	}
	
	func doOnError(_ onError: ((Error) throws -> Void)?) -> Observable<Element> {
		return `do`(onError: onError)
	}
}

extension ControlEvent {
	func subscribeNext(_ onNext: ((PropertyType) -> Void)?) -> Disposable {
		return subscribe(onNext: onNext)
	}
}
