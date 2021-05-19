//
//  AppDelegate.swift
//  Climcity
//
//  Created by Mervin Flores on 5/17/21.
//

import UIKit
import RealmSwift
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
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
        DispatchQueue.main.async {
            let loginViewController = UIStoryboard.Main().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window!.rootViewController = loginViewController
            self.window!.makeKeyAndVisible()
        }
    }

    func setHomeScreen(){
        DispatchQueue.main.async {
            let homeViewController = UIStoryboard.Main().instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window!.rootViewController = homeViewController
            self.window!.makeKeyAndVisible()
        }
    }

}

