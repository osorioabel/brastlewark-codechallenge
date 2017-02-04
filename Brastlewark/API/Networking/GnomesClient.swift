//
//  GnomesClient.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import Moya
import RxSwift
import Gloss
import SwiftyUserDefaults

enum InternalError: Swift.Error {
	case noCredentialsFound
	case unexpectedResponse
}

final class MoyaShakeClient {
	
	// MARK: - Private properties
	fileprivate let disposeBag = DisposeBag()
	static let sharedInstance = MoyaShakeClient()
	
	lazy var provider: RxMoyaProvider<RxMoyaTarget> = { [unowned self] in
		var networkActivityCount = 0
		let provider = RxMoyaProvider<RxMoyaTarget>(
			endpointClosure: { [unowned self] in
				$0.endpoint()
			},
			stubClosure: RxMoyaProvider.neverStub,
			plugins: [
				NetworkActivityPlugin {
					switch $0 {
					case .began:
						networkActivityCount += 1
					case .ended:
						networkActivityCount -= 1
					}
					if networkActivityCount == 0 {
						UIApplication.shared.isNetworkActivityIndicatorVisible = false
					} else if networkActivityCount == 1 {
						UIApplication.shared.isNetworkActivityIndicatorVisible = true
					}
				}
			])
		return provider
		}()
	
	
	
	// MARK: - Initialization functions
	private init() {
		print("MoyaShakeClient Initialized")
	}
	
	// MARK: - Gnomes Related functions
	func listPonies() -> Observable<[Gnome]> {
		return provider.request(.getGnomes)
			.filterApiErrors()
			.observeOn(SerialDispatchQueueScheduler(qos: .background))
			.mapJSON()
			.map {
				guard let json = $0 as? [String: AnyObject] else { throw InternalError.unexpectedResponse }
				
				var gnomes: [Gnome] = []
				if let gnomesJSON = json["Brastlewark"] as? [JSON] {
					gnomes = [Gnome].from(jsonArray: gnomesJSON) ?? []
				}
				return gnomes
			}
			.observeOn(MainScheduler.instance)
	}
}
extension ObservableType where E == Response {
	
	func filterApiErrors() -> Observable<Response> {
		return `do`(onNext: { (response) in
			do {
				_ = try response.filterSuccessfulStatusCodes()
			} catch {
				if let apiError: ApiError = try? response.mapObject() {
					throw apiError
				}
				throw error
			}
		})
	}
}
