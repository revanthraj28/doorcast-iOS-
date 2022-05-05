//
//  Loader.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 05/05/22.
//

import Foundation
import MBProgressHUD

class Loader {
    
    static func showAdded(to view: UIView, animated: Bool) {
        DispatchQueue.main.async {
            ProgressHUD.animationType = .lineSpinFade
            ProgressHUD.colorAnimation = UIColor(named: "ThemeColor") ?? .red
            ProgressHUD.show()
        }
//        MBProgressHUD.showAdded(to: view, animated: animated)
    }

    static func hide(for view: UIView, animated: Bool) {
        DispatchQueue.main.async {
            ProgressHUD.dismiss()
        }
//        MBProgressHUD.hide(for: view, animated: animated)
    }
}
