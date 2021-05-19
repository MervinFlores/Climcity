//
//  AppDelegate.swift
//  Climcity
//
//  Created by Mervin Flores on 5/17/21.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("Realm File located at : ",Realm.Configuration.defaultConfiguration.fileURL as Any)
        self.checkLogin()
        return true
    }

    private func checkLogin(){
        let container = try! Container()

        let user = container.values(UserInfo.self, matching: .all).values()
        if user.isEmpty{
            self.setLoginScreen()
        } else {
            self.setHomeScreen()
        }
    }

    func setLoginScreen(){
//        DispatchQueue.main.async {
            let loginViewController = UIStoryboard.Main().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window!.rootViewController = loginViewController
            self.window!.makeKeyAndVisible()
//        }
    }

    private func setHomeScreen(){
        DispatchQueue.main.async {
            let homeViewController = UIStoryboard.Main().instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window!.rootViewController = homeViewController
            self.window!.makeKeyAndVisible()
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

