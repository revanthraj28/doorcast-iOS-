//
//  UIViewControllerExtension.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import Foundation
import UIKit

extension UIViewController {
    func showLogin() {
        DispatchQueue.main.async {
            if let vc = LoginVC.newInstance {
                let nav = UINavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                self.view.window?.rootViewController = nav
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    func gotoHomeScreen() {
        DispatchQueue.main.async {
            // V2 Dashboard with 5 tabs
            let vc = OnBoardingVC.newInstance
            self.view.window?.rootViewController = vc
            self.view.window?.makeKeyAndVisible()
        }
    }
}
