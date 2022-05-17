//
//  FontManager.swift
//  DoorcastRebase
//
//  Created by Codebele 06 on 04/05/22.
//

import Foundation
import UIKit

extension UIFont {
     public static func poppinsSemiBold(size: CGFloat) -> UIFont {
      return UIFont(name: "Poppins-SemiBold", size: size)!
    }
      public static func poppinsItalic(size: CGFloat) -> UIFont {
          return UIFont(name: "Poppins-Italic", size: size)!
      }
    public static func poppinsLight(size: CGFloat) -> UIFont {
      return UIFont(name: "Poppins-Light", size: size)!
    }
    public static func poppinsMedium(size: CGFloat) -> UIFont {
      return UIFont(name: "Poppins-Medium", size: size)!
    }
    public static func poppinsRegular(size: CGFloat) -> UIFont {
      return UIFont(name: "Poppins-Regular", size: size)!
    }
    
    public static func poppinsBoldItalic(size: CGFloat) -> UIFont {
      return UIFont(name: "Poppins-BoldItalic", size: size)!
    }
    
    public static func oswaldMedium(size: CGFloat) -> UIFont {
         return UIFont(name: "Oswald-Medium", size: size)!
       }
    
    public static func oswaldMediumItalic(size: CGFloat) -> UIFont {
      return UIFont(name: "Oswald-MediumItalic", size: size)!
    }
    
    public static func oswaldLightItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "Oswald-LightItalic", size: size) ?? UIFont.systemFont(ofSize: 12)
    }
    
    public static func oswaldRegular(size: CGFloat) -> UIFont {
      return UIFont(name: "Oswald-Regular", size: size)!
    }
    
    
    
}
