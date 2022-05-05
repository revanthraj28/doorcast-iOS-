//
//  LoginVC.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    static var newInstance: LoginVC? {
        let storyboard = UIStoryboard(name: Storyboard.authentication.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? LoginVC
        return vc
    }
    
    var viewModel : LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel(self)
        emailTF.text = "chaitranew@gmail.com"
        passwordTF.text = "exstream"
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        if emailTF.text != "" {
            if passwordTF.text != "" {
                var parms = [String: Any]()
                parms["email"] = emailTF.text ?? ""
                parms["password"] = passwordTF.text ?? ""
                parms["device_id"] = KDeviceID
                parms["device"] = KDeviceModelName
                parms["os_type"] = KOsType
                parms["latitude"] = 0.0
                parms["longitude"] = 0.0
                parms["device_token"] = "embLbUlYRDChPUTgGUV6Ob:APA91bGvpyfL_W7VC_m7dEaXD-Wr22lgRufMJavjcJg7rGHZfugdgisgbOYz2oz4aUlm8fMJOwu3s5w4sZY31h_py4S6C-TeA2n54tI2nClMtIddA_EuCi-O34CnZxi6aL82EKr4k4Sf"
                
                viewModel.loginApi(dictParam: parms)
            } else {
                print("Password empty")
            }
        } else {
            print("Email empty")
        }
    }
}

extension LoginVC : LoginViewModelProtocol {
    func loginSuccess(loginResponse: LoginModel) {
        // To save login response
        SessionManager.saveSessionInfo(loginResponse: loginResponse)
        self.gotoHomeScreen()
    }
}

extension LoginVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
