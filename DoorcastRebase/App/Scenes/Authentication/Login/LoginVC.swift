//
//  LoginVC.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import UIKit
import DropDown

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var versionLabl: UILabel!
    @IBOutlet weak var forgetPassBtn: UIButton!
    @IBOutlet weak var dropDownImage: UIImageView!
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var dropDownTitleLbl: UILabel!
    @IBOutlet weak var dropdownView: UIView!
    @IBOutlet weak var serverLbl: UILabel!
    @IBOutlet weak var renovationTrackerLbl: UILabel!
    @IBOutlet weak var contactlbl: UILabel!
    @IBOutlet weak var docarcastImageLogo: UIImageView!
    @IBOutlet weak var logintoLbl: UILabel!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passErorrLabel: UILabel!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var emailAdresslbl: UILabel!
    
    
    let rightBarDropDown = DropDown()
    
    var loginResponseModel : LoginModelData?
    
    static var newInstance: LoginVC? {
        let storyboard = UIStoryboard(name: Storyboard.authentication.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? LoginVC
        return vc
    }
    
    var viewModel : LoginViewModel!
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        changeStatusBarColor(with: .ThemeColor)
        defaults.set("", forKey: UserDefaultsKeys.globalAT)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel(self)
        emailTF.text = "keerthinew@gmail.com"
        passwordTF.text = "exstream"
        setupUI()
        
    }

    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        defaults.set("", forKey: UserDefaultsKeys.globalAT)
//    }
    
    func setupUI()
    {
//        BASE_URL = "https://doorcast.tech/api/"
        emailTF.textAlignment = .center
        passwordTF.textAlignment = .center
        holderView.backgroundColor = UIColor(named: "ThemeColor")
        docarcastImageLogo.image = UIImage(named: "doorcast_white")
        logintoLbl.text = "Login To"
        logintoLbl.font = UIFont.oswaldMedium(size: 16)
        logintoLbl.textColor = .white
        renovationTrackerLbl.text = "Renovation Tracker"
        renovationTrackerLbl.font = UIFont.oswaldMedium(size: 20)
        serverLbl.text = "Server:"
        serverLbl.font = UIFont.oswaldMedium(size: 18)
        dropdownView.backgroundColor = .clear
        dropDownImage.image = UIImage(named: "chevron-down-solid")
        dropDownImage.tintColor = UIColor.white
        dropDownTitleLbl.text = "Production"
        dropDownTitleLbl.font = UIFont.oswaldMedium(size: 20)
        dropDownTitleLbl.textColor = .white
        passwordLbl.text = "Password"
        passwordLbl.textColor = .white
        
        emailAdresslbl.text = "Email Address"
        emailAdresslbl.textColor = .white
        
        emailTF.font = UIFont.oswaldMedium(size: 14)
        passwordTF.font = UIFont.oswaldMedium(size: 14)
        
        emailAdresslbl.font = UIFont.oswaldMedium(size: 16)
        passwordLbl.font = UIFont.oswaldMedium(size: 16)
        
        emailTF.placeholder =  "name@example.com"
        passwordTF.placeholder = "Password"
        
        loginButton.setTitle("LOGIN", for: .normal)
        loginButton.titleLabel?.font = UIFont.oswaldMedium(size: 16)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.backgroundColor = .white
        loginButton.layer.cornerRadius = 2
        loginButton.clipsToBounds = true
        
        contactlbl.text = "Contact your supervisor to create your Doorcast account."
        contactlbl.font = UIFont.oswaldMedium(size: 16)
        contactlbl.numberOfLines = 0
        contactlbl.textColor = .white
        forgetPassBtn.setTitle("Forgot Password?", for: .normal)
        forgetPassBtn.setTitleColor(.black, for: .normal)
        forgetPassBtn.titleLabel?.font = UIFont.oswaldMedium(size: 18)
        
        versionLabl.text = "Version:...."
        versionLabl.textColor = .white
        versionLabl.font = UIFont.oswaldMedium(size: 12)
        forgetPassBtn.titleLabel?.tintColor = .black
        
        emailErrorLabel.textColor = .black
        passErorrLabel.textColor = .black
        
        emailErrorLabel.isHidden = true
        passErorrLabel.isHidden = true
        
        emailErrorLabel.font = UIFont.oswaldRegular(size: 12)
        passErorrLabel.font = UIFont.oswaldRegular(size: 12)
        
        print("loginResponseModel...\(loginResponseModel?.fullname ?? "")")
    }
    @IBAction func didTapOnDropBtn(_ sender: Any) {
        
        print("server dropdown btn clicked..")
        
        passwordTF.isSecureTextEntry = true
        rightBarDropDown.clipsToBounds = true
        rightBarDropDown.layer.cornerRadius = 10
        rightBarDropDown.layer.shadowColor = UIColor.darkGray.cgColor
        rightBarDropDown.layer.shadowOpacity = 1
        rightBarDropDown.layer.shadowOffset = CGSize.zero
        rightBarDropDown.layer.shadowRadius = 5
        rightBarDropDown.cellHeight = 35.0
        rightBarDropDown.textColor = UIColor.white
        rightBarDropDown.textFont = UIFont.poppinsMedium(size: 15)
        rightBarDropDown.backgroundColor = UIColor(named: "ThemeColor")
        rightBarDropDown.selectedTextColor = UIColor(named: "ThemeColor") ?? .black
        rightBarDropDown.anchorView = dropDownTitleLbl
        rightBarDropDown.dataSource = ["Production","Staging","Dev"]
        rightBarDropDown.cellConfiguration = { (index, item) in return "\(item)" }
        
        rightBarDropDown.selectionAction = { (index: Int, item: String) in
            self.dropDownTitleLbl.text = "\(item)"
            
        }
        
        rightBarDropDown.bottomOffset = CGPoint(x: 0, y:(rightBarDropDown.anchorView?.plainView.bounds.height)! + 10)
        rightBarDropDown.show()
        
    }
    
    @IBAction func passwordEditingChanged(_ sender: Any) {
        
        if passwordTF.text != ""
        {
            passErorrLabel.text = ""
        }
    }
    
    
    @IBAction func didEmailEditChanged(_ sender: Any) {
        
        if emailTF.text?.validateAsEmail() == false {
            validateLabel(lblName: emailErrorLabel, hide: false, lblText: "Enter Valid Email")
        } else {
            validateLabel(lblName: emailErrorLabel, hide: true, lblText: "")
        }
    }
    
    @IBAction func didTapOnForgetPasswordButton(_ sender: Any) {

        guard let vc = ForgotPasswordVC.newInstance else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func validateLabel(lblName: UILabel, hide: Bool, lblText: String){
        lblName.isHidden = hide
        lblName.text = lblText
    }
    

    func logincallApi() {
      
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
                parms["device_token"] = "\(UserDefaults.standard.string(forKey: "FCMToken") ?? "")"
                switch self.dropDownTitleLbl.text {
                case "Production":
                    BASE_URL = "https://doorcast.tech/api/"
                    break
                case "Staging":
                    BASE_URL = "https://staging.doorcast.tech/api/"
                    break
                case "Dev":
                    BASE_URL = "https://dev.doorcast.tech/api/"
                    break
                default:
                    BASE_URL = "https://doorcast.tech/api/"
                    break
                }
                print("Baseurl = \(BASE_URL)")
                
                defaults.set(BASE_URL ?? "https://doorcast.tech/api/", forKey: UserDefaultsKeys.Base_url)
                
                print("Defaults url = \(defaults.string(forKey: UserDefaultsKeys.Base_url))")
                
                
                viewModel.loginApi(dictParam: parms)
            } else {
                validateLabel(lblName: passErorrLabel, hide: false, lblText: "Enter Password")
            }
        } else {
            validateLabel(lblName: emailErrorLabel, hide: false, lblText: "Enter Email")
        }
    }
    
    
    
    
//    @IBAction func loginButtonAction(_ sender: Any) {
//        if emailTF.text != "" {
//            if passwordTF.text != "" {
//                
//                var parms = [String: Any]()
//                parms["email"] = emailTF.text ?? ""
//                parms["password"] = passwordTF.text ?? ""
//                parms["device_id"] = KDeviceID
//                parms["device"] = KDeviceModelName
//                parms["os_type"] = KOsType
//                parms["latitude"] = 0.0
//                parms["longitude"] = 0.0
//                parms["device_token"] = "\(UserDefaults.standard.string(forKey: "FCMToken") ?? "")"
//                switch self.dropDownTitleLbl.text {
//                case "Production":
//                    BASE_URL = "https://doorcast.tech/api/"
//                    break
//                case "Staging":
//                    BASE_URL = "https://staging.doorcast.tech/api/"
//                    break
//                case "Dev":
//                    BASE_URL = "https://dev.doorcast.tech/api/"
//                    break
//                default:
//                    BASE_URL = "https://doorcast.tech/api/"
//                    break
//                }
//                print("Baseurl = \(BASE_URL)")
//                
//                defaults.set(BASE_URL ?? "https://doorcast.tech/api/", forKey: UserDefaultsKeys.Base_url)
//                
//                print("Defaults url = \(defaults.string(forKey: UserDefaultsKeys.Base_url))")
//                
//                
//                viewModel.loginApi(dictParam: parms)
//            } else {
//                validateLabel(lblName: passErorrLabel, hide: false, lblText: "Enter Password")
//            }
//        } else {
//            validateLabel(lblName: emailErrorLabel, hide: false, lblText: "Enter Email")
//        }
//    }
    
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
                parms["device_token"] = "\(UserDefaults.standard.string(forKey: "FCMToken") ?? "")"
                switch self.dropDownTitleLbl.text {
                case "Production":
                    BASE_URL = "https://doorcast.tech/api/"
                    break
                case "Staging":
                    BASE_URL = "https://staging.doorcast.tech/api/"
                    break
                case "Dev":
                    BASE_URL = "https://dev.doorcast.tech/api/"
                    break
                default:
                    BASE_URL = "https://doorcast.tech/api/"
                    break
                }
                print("Baseurl = \(BASE_URL)")
                
                defaults.set(BASE_URL ?? "https://doorcast.tech/api/", forKey: UserDefaultsKeys.Base_url)
                
                print("Defaults url = \(defaults.string(forKey: UserDefaultsKeys.Base_url))")
                
                
                viewModel.loginApi(dictParam: parms)
            } else {
                validateLabel(lblName: passErorrLabel, hide: false, lblText: "Enter Password")
            }
        } else {
            validateLabel(lblName: emailErrorLabel, hide: false, lblText: "Enter Email")
        }
    }
    
    
    
    
}

extension LoginVC : LoginViewModelProtocol {
    func loginSuccess(loginResponse: LoginModel) {
        
        print("loginResponse \(loginResponse)")
        UserDefaults.standard.set(loginResponse.data?.fullname, forKey: "fullname")
        UserDefaults.standard.set(loginResponse.data?.mobile, forKey: "mobile")
        UserDefaults.standard.set(loginResponse.data?.email, forKey: "email")
        UserDefaults.standard.set(loginResponse.data?.login_id, forKey: "loginid")
        
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

