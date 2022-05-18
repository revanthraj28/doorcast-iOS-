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
    
    func gotoForgotPasswordScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        vc.modalPresentationStyle = .fullScreen
       // self.present(vc, animated:true, completion:nil)
        presentDetail(vc)
    }
    
    
    
    
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.50
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false)
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.50
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false)
    }
    
   
        func showAlertOnWindow(title: String? = nil, message: String? = nil, titles: [String] = ["OK"], completionHanlder: ((_ title: String) -> Void)? = nil) {
            
            let alert = UIAlertController(title: title ?? "", message: message, preferredStyle: UIAlertController.Style.alert)
            for title in titles {
                alert.addAction(UIAlertAction(title: title, style: UIAlertAction.Style.default, handler: { (action) in
                    completionHanlder?(title)
                }))
            }
            present(alert, animated: true, completion: nil)
        }
}
