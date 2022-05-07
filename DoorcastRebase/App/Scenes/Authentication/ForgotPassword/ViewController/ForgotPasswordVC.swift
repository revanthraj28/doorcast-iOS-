//
//  ForgotPasswordVC.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 04/05/2022.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var NavBarView: UIView!
    @IBOutlet weak var changePasswordLBL: UILabel!
    @IBOutlet weak var declarationLBl: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var submitBTN: UIButton!
    @IBOutlet weak var loginLBL: UILabel!
    @IBOutlet weak var emaileErorLBL: UILabel!
    @IBOutlet weak var backBTn: UIButton!
    
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
        uiStyle()
        emaileErorLBL.isHidden = true
        viewModel = ForgotPasswordViewModel(self)
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func uiStyle(){
        
        self.loginLBL.font = UIFont.oswaldMedium(size: 20)
        self.NavBarView.backgroundColor = UIColor.ThemeColor
        
        self.submitBTN.backgroundColor = UIColor.ThemeColor
        self.submitBTN.setTitle("SUBMIT", for: .normal)
        self.submitBTN.titleLabel?.font = UIFont.oswaldMedium(size: 18)
        self.submitBTN.titleLabel?.tintColor = UIColor.white
        self.submitBTN.layer.cornerRadius = 14
        
        self.changePasswordLBL.font = UIFont.oswaldMedium(size: 24)
        
        self.declarationLBl.font = UIFont.oswaldMedium(size: 16)
        self.declarationLBl.numberOfLines = 2
        self.declarationLBl.text = "Enter the EmailID address associated with your account"
        self.declarationLBl.textColor = UIColor.ThemeColor
        
        self.emailTF.font = UIFont.oswaldMedium(size: 16)
        self.emailTF.addBottomBorder()
        
        self.emaileErorLBL.textColor = UIColor.ThemeColor
        self.emaileErorLBL.font = UIFont.oswaldMedium(size: 14)
        
        backBTn.titleLabel?.text = ""
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
            emaileErorLBL.isHidden = true
        } else {
            emaileErorLBL.isHidden = false
            emaileErorLBL.text = "Invalid email"
        }
        
    }
    @IBAction func emailTfAction(_ sender: Any) {
        if isValidEmail(emailTF.text ?? "email") == true {
            emaileErorLBL.text = ""
            emaileErorLBL.isHidden = true
        } else {
            emaileErorLBL.text = " "
            emaileErorLBL.isHidden = false
        }
    }
    
    
    
    
    @IBAction func didTapOnBackButtonAction(_ sender: Any) {
        print("didTapOnBackButtonAction")
        self.dismiss(animated: true)
    }
    
    
}





extension ForgotPasswordVC : ForgotPasswordViewModelProtocol {
    func ForgotPasswordSuccess(ForgotPasswordResponse: ForgotPasswordModel) {
        self.ForgotPasswordViewResponce = ForgotPasswordResponse
        print("forgotpassword responce=\(ForgotPasswordViewResponce)")
        //        defaults.set("", forKey: UserDefaultsKeys.globalAT)
        if (ForgotPasswordViewResponce?.status) == true {
            //            print("success")
            let storyBoard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "OtpVC") as! OtpVC
            vc.otpNumber = ForgotPasswordViewResponce?.data
            vc.EmailAddress = emailTF.text
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated:true, completion:nil)
        } else {
            emaileErorLBL.isHidden = false
            emaileErorLBL.text = "Invalid email"
        }
    }
}
