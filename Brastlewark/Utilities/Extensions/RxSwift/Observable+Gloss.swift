//
//  Observable+Gloss.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Gloss

extension ObservableType where E == Response {
	func mapObject<T: Decodable>(_ type: T.Type) -> Observable<T> {
		return observeOn(SerialDispatchQueueScheduler(qos: .background))
			.flatMap { (response) -> Observable<T> in
				return Observable.just(try response.mapObject())
			}
			.observeOn(MainScheduler.instance)
	}
	func mapArray<T: Decodable>(_ type: T.Type) -> Observable<[T]> {
		return observeOn(SerialDispatchQueueScheduler(qos: .background))
			.flatMap { response -> Observable<[T]> in
				return Observable.just(try response.mapArray())
			}
			.observeOn(MainScheduler.instance)
	}
	func mapObjectOptional<T: Decodable>(_ type: T.Type) -> Observable<T?> {
		return observeOn(SerialDispatchQueueScheduler(qos: .background))
			.flatMap { response -> Observable<T?> in
				do {
					let object: T = try response.mapObject()
					return Observable.just(object)
				} catch {
					return Observable.just(nil)
				}
			}
			.observeOn(MainScheduler.instance)
	}
	func mapArrayOptional<T: Decodable>(_ type: T.Type) -> Observable<[T]?> {
		return observeOn(SerialDispatchQueueScheduler(qos: .background))
			.flatMap { response -> Observable<[T]?> in
				do {
					let object: [T] = try response.mapArray()
					return Observable.just(object)
				} catch {
					return Observable.just(nil)
				}
			}
			.observeOn(MainScheduler.instance)
	}
}
