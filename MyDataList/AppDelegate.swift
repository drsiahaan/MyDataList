//
//  AppDelegate.swift
//  MyDataList
//
//  Created by Dicka Reynaldi on 15/04/25.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
         _ application: UIApplication,
         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
     ) -> Bool {
         
         window = UIWindow(frame: UIScreen.main.bounds)
         let claimListVC = ClaimListRouter.createModule()
         let navigationController = UINavigationController(rootViewController: claimListVC)
         window?.rootViewController = navigationController
         window?.makeKeyAndVisible()
         
         return true
     }

}
