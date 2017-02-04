//
//  GnomesAPI.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import Foundation
import RxSwift

struct GnomesAPI {

	static func listGnomes()-> Observable<[Gnome]> {
		return GnomesNetworkingService.listPonies()
	}
}
