//
//  ForgotPasswordVC.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 04/05/2022.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var changePasswordLbl: UILabel!
    @IBOutlet weak var declarationLbl: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var loginLbl: UILabel!
    @IBOutlet weak var emaileErorLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    var ForgotPasswordViewResponce : ForgotPasswordModel?
    var viewModel : ForgotPasswordViewModel!
    
    static var newInstance: ForgotPasswordVC? {
        let storyboard = UIStoryboard(name: Storyboard.authentication.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? ForgotPasswordVC
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIStyle()
        emaileErorLbl.isHidden = true
        viewModel = ForgotPasswordViewModel(self)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func UIStyle(){
        
        self.loginLbl.font = UIFont.oswaldMedium(size: 20)
        self.navBarView.backgroundColor = UIColor.ThemeColor
        
        self.submitBtn.backgroundColor = UIColor.ThemeColor
        self.submitBtn.setTitle("SUBMIT", for: .normal)
        self.submitBtn.titleLabel?.font = UIFont.oswaldMedium(size: 18)
        self.submitBtn.titleLabel?.tintColor = UIColor.white
        self.submitBtn.layer.cornerRadius = 14
        
        self.changePasswordLbl.font = UIFont.oswaldMedium(size: 24)
        
        submitBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        submitBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        submitBtn.layer.shadowOpacity = 1.0
        submitBtn.layer.shadowRadius = 0.0
        submitBtn.layer.masksToBounds = false
        submitBtn.layer.cornerRadius = 4.0
        
        self.declarationLbl.font = UIFont.oswaldMedium(size: 16)
        self.declarationLbl.numberOfLines = 2
        self.declarationLbl.text = "Enter the EmailID address associated with your account"
        self.declarationLbl.textColor = UIColor.ThemeColor
        
        self.emailTF.font = UIFont.oswaldMedium(size: 16)
        self.emailTF.addBottomBorder()
        
        self.emaileErorLbl.textColor = UIColor.ThemeColor
        self.emaileErorLbl.font = UIFont.oswaldMedium(size: 14)
        
        backBtn.titleLabel?.text = ""
    }
    @IBAction func submitBtnAction(_ sender: Any) {
        if isValidEmail(emailTF.text ?? "email") == true {
            print("valid")
            if emailTF.text != ""   {
                print("next step")
                
                var parms = [String: Any]()
                parms["email"] = self.emailTF.text
                
                defaults.set(GlobelAccessToken, forKey: UserDefaultsKeys.globalAT)
                self.viewModel?.ForgotPasswordApi(dictParam: parms)
            }
        }
        if isValidEmail(emailTF.text ?? ""){
            emaileErorLbl.isHidden = true
        } else {
            emaileErorLbl.isHidden = false
            emaileErorLbl.text = "Invalid email"
        }
        
    }
    @IBAction func emailTfAction(_ sender: Any) {
        if isValidEmail(emailTF.text ?? "email") == true {
            emaileErorLbl.text = ""
            emaileErorLbl.isHidden = true
        } else {
            emaileErorLbl.text = " "
            emaileErorLbl.isHidden = false
        }
    }

    @IBAction func didTapOnBackButtonAction(_ sender: Any) {
        print("didTapOnBackButtonAction")
        guard let vc =  LoginVC.newInstance else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
}

extension ForgotPasswordVC : ForgotPasswordViewModelProtocol {
    func ForgotPasswordSuccess(ForgotPasswordResponse: ForgotPasswordModel) {
        self.ForgotPasswordViewResponce = ForgotPasswordResponse
        print("forgotpassword responce=\(ForgotPasswordViewResponce)")
                defaults.set("", forKey: UserDefaultsKeys.globalAT)
        if (ForgotPasswordViewResponce?.status) == true {
            guard let vc = OtpVC.newInstance  else {return}
            vc.otpNumber = ForgotPasswordViewResponce?.data
            vc.EmailAddress = emailTF.text
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
           
        } else {
            emaileErorLbl.isHidden = false
            emaileErorLbl.text = "Invalid email"
        }
    }
}
