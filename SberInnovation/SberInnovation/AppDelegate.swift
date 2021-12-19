//
//  AppDelegate.swift
//  SberInnovation
//
//  Created by Maxim Savchenko on 17.12.2021.
//

import UIKit
import GoogleMaps

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let key: String = "AIzaSyC0hqRVJSIqmUx9hB7PSEAGJT0i9yFMYxQ"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(key)
        return true
    }


}

