//
//  ResetPasswordVC.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 05/05/2022.
//

import UIKit

class ResetPasswordVC: UIViewController {
    
    @IBOutlet weak var HolderView: UIView!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var conformPasswordTF: UITextField!
    @IBOutlet weak var resetPassword: UIButton!
    @IBOutlet weak var newPasswordErrorLBL: UILabel!
    @IBOutlet weak var conformPAsswordErrorLBL: UILabel!
    @IBOutlet weak var changeColorView: UIView!
    
    
    
    var EmailAddress : String?
    var viewmodel : ResetpasswordViewModel?
    var ResetPAsswordViewResponce : ResetPasswordModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newPasswordErrorLBL.isHidden = true
        conformPAsswordErrorLBL.isHidden = true
        
        conformPasswordTF.addTarget(self, action: #selector(ResetPasswordVC.textFieldDidChange(_:)), for: .editingChanged)
        newPasswordTF.addTarget(self, action: #selector(ResetPasswordVC.textFieldDidChangenew(_:)), for: .editingChanged)
        
        
        viewmodel = ResetpasswordViewModel(self)
        
        newPasswordTF.isSecureTextEntry = true
        conformPasswordTF.isSecureTextEntry = true
        resetPassword.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        resetPassword.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        resetPassword.layer.shadowOpacity = 1.0
        resetPassword.layer.shadowRadius = 0.0
        resetPassword.layer.masksToBounds = false
        resetPassword.layer.cornerRadius = 4.0
        self.HolderView.backgroundColor = UIColor.AppBackgroundColor
        
    }
    func isValidPassword(_ password: String) -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        let password = password.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)
        
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if newPasswordTF.text != conformPasswordTF.text {
            changeColorView.backgroundColor = .red
        } else {
            changeColorView.backgroundColor = .green
        }
    }
    @objc func textFieldDidChangenew(_ textField: UITextField) {
        if isValidPassword(newPasswordTF.text!) == false {
            newPasswordErrorLBL.isHidden = false
            newPasswordErrorLBL.text = "Wrong Password"
        } else {
            newPasswordErrorLBL.isHidden = true
            
        }
    }
    
    
    @IBAction func resetPasswordBTNAction(_ sender: Any) {
        
        if newPasswordTF.text == ""{
            newPasswordErrorLBL.isHidden = false
            newPasswordErrorLBL.text = "New password Field is Empty"
        } else
        
        if conformPasswordTF.text == "" {
            conformPAsswordErrorLBL.isHidden = false
            conformPAsswordErrorLBL.text = "Conform password Field is Empty"
        } else
        if newPasswordTF.text != conformPasswordTF.text  {
            conformPAsswordErrorLBL.isHidden = false
            conformPAsswordErrorLBL.text = "Password aren't same"
        } else {
            
            newPasswordErrorLBL.isHidden = true
            conformPAsswordErrorLBL.isHidden =  true
            
            var parms = [String: Any]()
            parms["email"] = self.EmailAddress
            parms["password"] = self.conformPasswordTF.text
            
            self.viewmodel?.ResetPasswordApi(dictParam: parms)
        }
        
    }
}
extension ResetPasswordVC : ResetpasswordViewModelProtocol {
    func ResetpasswordSuccess(ResetpasswordResponse: ResetPasswordModel) {
        self.ResetPAsswordViewResponce = ResetpasswordResponse
        print("reset password=\(ResetPAsswordViewResponce)")
        if ResetPAsswordViewResponce?.status == true {
            defaults.set("", forKey: UserDefaultsKeys.globalAT)
        }
        
    }
    
    
    
}
