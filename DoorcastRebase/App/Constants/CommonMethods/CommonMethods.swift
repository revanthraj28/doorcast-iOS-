//
//  CommonMethods.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 16/05/22.
//

import Foundation
import UIKit


var statusBar = UIView()

func changeStatusBarColor(with color: UIColor) {
    
    let statusBar = UIView(frame: UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
    
    statusBar.backgroundColor = color
    UIApplication.shared.windows.first?.addSubview(statusBar)
    
}
