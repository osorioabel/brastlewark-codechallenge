//
//  GnomesNetworkingService.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import Foundation
import RxSwift

struct GnomesNetworkingService {
	// MARK: - Private Properties
	fileprivate static let client: MoyaShakeClient = MoyaShakeClient.sharedInstance
	
	
	// MARK: - Moya Networking Methods
	static func listPonies() -> Observable<[Gnome]> {
		return self.client.listPonies()
	}
}
