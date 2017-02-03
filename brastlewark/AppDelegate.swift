//
//  AppDelegate.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var appCoordinator: AppCoordinator!

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		customizeAppereance()
		let urlCache = URLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 200 * 1024 * 1024, diskPath: nil)
		URLCache.shared = urlCache
		let window: UIWindow = UIWindow()
		self.window = window
		
		appCoordinator = AppCoordinator(window: window)
		appCoordinator.start()
		
		window.frame = UIScreen.main.bounds
		window.makeKeyAndVisible()
		return true
	}
}
extension AppDelegate {
	
	func customizeAppereance(){
		UINavigationBar.appearance().tintColor = .white
		UINavigationBar.appearance().barTintColor = .black
		UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
		UIApplication.shared.statusBarStyle = .lightContent
	}

}

