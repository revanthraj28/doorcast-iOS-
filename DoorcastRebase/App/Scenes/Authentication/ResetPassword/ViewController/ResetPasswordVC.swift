//
//  ResetPasswordVC.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 05/05/2022.
//

import UIKit

class ResetPasswordVC: UIViewController {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var conformPasswordTF: UITextField!
    @IBOutlet weak var resetPasswordBtn: UIButton!
    @IBOutlet weak var newPasswordErrorLbl: UILabel!
    @IBOutlet weak var conformPAsswordErrorLbl: UILabel!
    @IBOutlet weak var changeColorView: UIView!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    //variables  used to get EmailID
    var EmailAddress : String?
    
    var viewmodel : ResetpasswordViewModel?
    var ResetPAsswordViewResponce : ResetPasswordModel?
    
    static var newInstance: ResetPasswordVC? {
        let storyboard = UIStoryboard(name: Storyboard.authentication.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? ResetPasswordVC
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newPasswordErrorLbl.isHidden = true
        conformPAsswordErrorLbl.isHidden = true
        
        conformPasswordTF.addTarget(self, action: #selector(ResetPasswordVC.textFieldDidChange(_:)), for: .editingChanged)
        newPasswordTF.addTarget(self, action: #selector(ResetPasswordVC.textFieldDidChangenew(_:)), for: .editingChanged)
        
        
        viewmodel = ResetpasswordViewModel(self)
        
        descriptionLbl.numberOfLines = 0
        newPasswordTF.isSecureTextEntry = true
        conformPasswordTF.isSecureTextEntry = true
        
        resetPasswordBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        resetPasswordBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        resetPasswordBtn.layer.shadowOpacity = 1.0
        resetPasswordBtn.layer.shadowRadius = 0.0
        resetPasswordBtn.layer.masksToBounds = false
        resetPasswordBtn.layer.cornerRadius = 4.0
        
        holderView.layer.cornerRadius = 14
        self.holderView.backgroundColor = UIColor.AppBackgroundColor
        
    }
    func resendOtp() {
        if newPasswordTF.text == ""{
            newPasswordErrorLbl.isHidden = false
            newPasswordErrorLbl.text = "Newpassword textField is Empty"
        } else
        
        if conformPasswordTF.text == "" {
            conformPAsswordErrorLbl.isHidden = false
            conformPAsswordErrorLbl.text = "Conform password textField is Empty"
        } else
        if newPasswordTF.text != conformPasswordTF.text  {
            conformPAsswordErrorLbl.isHidden = false
            conformPAsswordErrorLbl.text = "Password aren't same"
        } else {
            
            newPasswordErrorLbl.isHidden = true
            conformPAsswordErrorLbl.isHidden =  true
            
            var parms = [String: Any]()
            parms["email"] = self.EmailAddress
            parms["password"] = self.conformPasswordTF.text
            defaults.set(GlobelAccessToken, forKey: UserDefaultsKeys.globalAT)
            self.viewmodel?.ResetPasswordApi(dictParam: parms)
        }
        
    }
    
    func CheckInternetConnection() {
        if ServiceManager.isConnection() == true {
            print("Internet Connection Available!")
            self.resendOtp()
        }else{
            print("Internet Connection not Available!")
           
            self.showAlertOnWindow(title: "No Internet Connection!", message: "Please check your internet connection and try again", titles: ["retry"]) { (key) in
                self.CheckInternetConnection()
            }
        }
    }
    
    
    func isValidPassword(_ password: String) -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        let password = password.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)
        
    }
    // Newpassword textfield Editing did change
    @objc func textFieldDidChange(_ textField: UITextField) {
        if newPasswordTF.text != conformPasswordTF.text {
            conformPAsswordErrorLbl.isHidden = false
            conformPAsswordErrorLbl.text = "Password aren't same"
            changeColorView.backgroundColor = .red
        } else {
            conformPAsswordErrorLbl.isHidden = true
            changeColorView.backgroundColor = .green
        }
    }
    // checking email formate
    @objc func textFieldDidChangenew(_ textField: UITextField) {
        if isValidPassword(newPasswordTF.text!) == false {
            newPasswordErrorLbl.isHidden = false
            newPasswordErrorLbl.text = "Wrong Password"
        } else {
            newPasswordErrorLbl.isHidden = true
            
        }
    }
    
    @IBAction func backToOtpVCBtnAction(_ sender: Any) {
        guard let vc = OtpVC.newInstance else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
   
    }
    
   
    
 
    
    @IBAction func resetPasswordBTNAction(_ sender: Any) {
        CheckInternetConnection()
//        if newPasswordTF.text == ""{
//            newPasswordErrorLbl.isHidden = false
//            newPasswordErrorLbl.text = "Newpassword textField is Empty"
//        } else
//
//        if conformPasswordTF.text == "" {
//            conformPAsswordErrorLbl.isHidden = false
//            conformPAsswordErrorLbl.text = "Conform password textField is Empty"
//        } else
//        if newPasswordTF.text != conformPasswordTF.text  {
//            conformPAsswordErrorLbl.isHidden = false
//            conformPAsswordErrorLbl.text = "Password aren't same"
//        } else {
//
//            newPasswordErrorLbl.isHidden = true
//            conformPAsswordErrorLbl.isHidden =  true
//
//            var parms = [String: Any]()
//            parms["email"] = self.EmailAddress
//            parms["password"] = self.conformPasswordTF.text
//            defaults.set(GlobelAccessToken, forKey: UserDefaultsKeys.globalAT)
//            self.viewmodel?.ResetPasswordApi(dictParam: parms)
//        }
        
    }
}
// Extension for APi call
extension ResetPasswordVC : ResetpasswordViewModelProtocol {
    
    func ResetpasswordSuccess(ResetpasswordResponse: ResetPasswordModel) {
        self.ResetPAsswordViewResponce = ResetpasswordResponse
        print("reset password = \(ResetPAsswordViewResponce?.status)")
        
        if ResetPAsswordViewResponce?.status == true {
            defaults.set("", forKey: UserDefaultsKeys.globalAT)
            guard let vc = LoginVC.newInstance else {return}
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    
    
}
