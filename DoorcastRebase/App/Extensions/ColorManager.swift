//
//  ColorManager.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 04/05/2022.
//

import Foundation
import UIKit

extension UIColor {

    public static var ThemeColor : UIColor {

        get {
            return UIColor(named: "ThemeColor")!
        }
    }
    public static var LabelMainTitleColor : UIColor {

        get {
            return UIColor(named: "LabelMainTitleColor")!
        }
    }
    public static var InactiveStateColor : UIColor {

        get {
            return UIColor(named: "InactiveStateColor") ?? UIColor.clear
        }
    }
    public static var ErrorLabelColor : UIColor {
        
        get {
            return UIColor(named: "ErrorLabelColor")!
        }
    }
    public static var designColor : UIColor {

        get {
            return UIColor(named: "designColor")!
        }
    }
    public static var AppBackgroundColor : UIColor {

        get {
            return UIColor(named: "AppBackgroundColor")!
        }
    }
    public static var ActionsColor : UIColor {

        get {
            return UIColor(named: "actionsColor") ?? .clear
        }
    }
}
