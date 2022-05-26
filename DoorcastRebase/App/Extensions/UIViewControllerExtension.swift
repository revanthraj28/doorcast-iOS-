//
//  UIViewControllerExtension.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    func convertImageToBase64(image: UIImage) -> String {
          let imageData = image.pngData()!
          return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
      }
    
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
    
    
    func gotoNotificationCenterVC() {
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
       // presentDetail(vc)
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

extension UIViewController {
    func showToast(message : String, font: UIFont, color: UIColor) {
        
        
        let toastLabel = UILabel(frame: CGRect(x: 15, y: self.view.frame.size.height - 150, width: self.view.frame.size.width - 30, height: 50))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.2, options: .curveEaseIn, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

