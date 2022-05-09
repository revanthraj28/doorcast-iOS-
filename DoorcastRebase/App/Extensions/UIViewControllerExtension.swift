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
    
    
    func gotoProfileScreen() {
        DispatchQueue.main.async {
            // V2 Dashboard with 5 tabs
            let vc = ProfileVC.newInstance
            self.view.window?.rootViewController = vc
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    
    func gotoNotificationScreen() {
        DispatchQueue.main.async {
            // V2 Dashboard with 5 tabs
            let vc = NotificationCenterVC.newInstance
            self.view.window?.rootViewController = vc
            self.view.window?.makeKeyAndVisible()
        }
    }
  
    
    
    func gotoForgotPasswordScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated:true, completion:nil)
    }
}
