//
//  StringExtension.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import Foundation
import UIKit

extension String {
    
    func secondsFromString (string: String) -> Int {
        let components: Array = string.components(separatedBy: ":")
        let hours = Int(components[0]) ?? 0 * 60 * 60
        let minutes = Int(components[1]) ?? 0
        let seconds = Int(components[2]) ?? 0
        return Int(hours + (minutes * 60) + seconds)
    }
    
    
    func maxLength(length: Int) -> String {
        var str = self
        let nsString = str as NSString
        if nsString.length >= length {
            str = nsString.substring(with:
                                        NSRange(
                                            location: 0,
                                            length: nsString.length > length ? length : nsString.length)
            )
        }
        return  str
    }
    
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    
    
    func validateAsEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}




class ShadowEffect: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // corner radius
        self.layer.cornerRadius = 10
        
        // border
        //self.layer.borderWidth = 1.0
        //  self.layer.borderColor = UIColor.black.cgColor
        
        // shadow
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 7
    }
    
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

extension String{
    
    func appendAttributedStringWithDifferentFonts(string:String,style1:UIFont,Style2:UIFont,color1:UIColor,color2:UIColor,alignment:NSTextAlignment? = NSTextAlignment.left) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = alignment!
        
        let myMutableString = NSMutableAttributedString(
            string: self,
            attributes: [NSAttributedString.Key.foregroundColor:color1,NSAttributedString.Key.paragraphStyle:paragraphStyle, NSAttributedString.Key.font:style1])
        
        myMutableString.append(NSAttributedString(string : string, attributes : [NSAttributedString.Key.foregroundColor:color2,NSAttributedString.Key.paragraphStyle:paragraphStyle,NSAttributedString.Key.font:Style2]))
        
        return myMutableString as NSAttributedString
    }
    
    func validateAsPhone() -> Bool {
        let phoneRegEx = "^[0-9'@s]{10}$"
        
        let phoneTest = NSPredicate(format:"SELF MATCHES[c] %@", phoneRegEx)
        return phoneTest.evaluate(with: self)
    }
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    public func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
        
    }
    
    
    
    
    func validateAsPhoneNumber() -> Bool {
        
        let phoneRegEx = "^[0-9]{3}-[0-9]{3}-[0-9]{4}$"
        let phoneTest = NSPredicate(format:"SELF MATCHES[c] %@", phoneRegEx)
        return phoneTest.evaluate(with: self)
        
    }
    
    
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    
}
extension NSMutableAttributedString {
    
    func setFontForText(textForAttribute: String, withFont font: UIFont) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        
        // Swift 4.2 and above
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        
        // Swift 4.1 and below
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }
    
    func setFontForTextWithColor(textForAttribute: String, withFont font: UIFont,textColor: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        
        // Swift 4.2 and above
        //        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        self.addAttributes([NSAttributedString.Key.font: font,
                            NSAttributedString.Key.foregroundColor: textColor], range: range)
        
        // Swift 4.1 and below
        //        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }
    
    func setButtonAttributedTittle(string1: String,string2: String,color1: UIColor,color2 :UIColor,font1: UIFont,font2 :UIFont) -> NSMutableAttributedString {
        let finalString: NSMutableAttributedString = NSMutableAttributedString()
        let attributes1 = [NSAttributedString.Key.font : font1, NSAttributedString.Key.foregroundColor : color1]
        let attributes2 = [NSAttributedString.Key.font : font2, NSAttributedString.Key.foregroundColor : color2]
        
        let attributedString1 : NSAttributedString = NSAttributedString(string: string1, attributes: attributes1)
        let attributedString2 : NSAttributedString = NSAttributedString(string: string2, attributes: attributes2)
        
        finalString.append(attributedString1)
        finalString.append(attributedString2)
        return finalString
    }
    
    
    
}

extension UIView
{
    
    func addCornerRadiusWithShadow(color: UIColor, borderColor: UIColor, cornerRadius: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 2.0
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = false
    }
    
    
    
    func fadeIn(duration: TimeInterval = 1.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        self.alpha = 0.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.transitionCurlDown, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 3.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        self.alpha = 1.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.transitionCurlDown, animations: {
            self.alpha = 0.0
        }) { (completed) in
            self.isHidden = true
            completion(true)
        }
    }
    
}


extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
