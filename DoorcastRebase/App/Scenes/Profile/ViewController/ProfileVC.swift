//
//  ProfileVC.swift
//  DoorcastRebase
//
//  Created by Codebele 06 on 05/05/22.
//

import UIKit

class ProfileVC: UIViewController,ProfileViewModelProtocol {
    
    
    @IBOutlet weak var saveBtn: UIButton!
    
    // @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var resetpasswordButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editButtonImage: UIImageView!
    @IBOutlet weak var editButtonView: UIView!
    @IBOutlet weak var phonenumtxtfld: UITextField!
    @IBOutlet weak var emailtxtfld: UITextField!
    @IBOutlet weak var Nametxtfld: UITextField!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var yourProfile: UILabel!
    @IBOutlet weak var phonenumErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    
    var email = String()
    var fullName =  String()
    var mobile = String()
    var selected: Bool = true
    var employee_id: String? = ""
    var ProfileResponseModel : ProfileModelData?
    var vmodel : ProfileViewModel?
    
    static var newInstance: ProfileVC? {
        let storyboard = UIStoryboard(name: Storyboard.profile.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? ProfileVC
        return vc
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        Nametxtfld.text = UserDefaults.standard.string(forKey: "fullname")
        emailtxtfld.text = UserDefaults.standard.string(forKey: "email")
        phonenumtxtfld.text = UserDefaults.standard.string(forKey: "mobile")
        
        NameLabel.text = UserDefaults.standard.string(forKey: "fullname")
        emailLabel.text = UserDefaults.standard.string(forKey: "email")
        numberLabel.text = UserDefaults.standard.string(forKey: "mobile")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        vmodel = ProfileViewModel(self)
        
    }
    
    func setupUI(){
        
        resetpasswordButton.isEnabled = true
        nameErrorLabel.isHidden = true
        rightView.isHidden = true
        leftView.isHidden = false
        phonenumErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        editButtonView.layer.cornerRadius = editButtonView.frame.height/2
        Nametxtfld.addBottomBorder()
        emailtxtfld.addBottomBorder()
        phonenumtxtfld.addBottomBorder()
        editButtonImage.image = UIImage(named: "MicrosoftTeams-image")
        resetpasswordButton.layer.cornerRadius = 5
        saveBtn.layer.cornerRadius = 5
        
        phonenumtxtfld.delegate = self
        emailtxtfld.delegate = self
        Nametxtfld.delegate = self
        
        
        Nametxtfld.font = UIFont.oswaldMedium(size: 16)
        phonenumtxtfld.font = UIFont.oswaldMedium(size: 16)
        emailtxtfld.font = UIFont.oswaldMedium(size: 16)
        
        nameErrorLabel.isHidden = true
        emailtxtfld.isUserInteractionEnabled = true
        
        
        
        dateLbl.text = Date().MonthDateDayFormatter?.uppercased()
        
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
        
    }
    
    
    @IBAction func phoneNumberEditingChangedAction(_ sender: Any) {
        
        if phonenumtxtfld.text?.validateAsPhoneNumber() == false && phonenumtxtfld.text == "" {
            validateLabel(lblName: phonenumErrorLabel, hide: false, lblText: "Enter Valid Phone Number")
        }
        else {
            validateLabel(lblName: phonenumErrorLabel, hide: true, lblText: "")
        }
        
    }
    
    @IBAction func didNameEditingBegin(_ sender: Any) {
        
        if Nametxtfld.text != "" {
            validateLabel(lblName: nameErrorLabel, hide: true, lblText: "")
        }
        
    }
    
    
    @IBAction func didEmailEditingBegin(_ sender: Any) {
        
        if emailtxtfld.text != "" {
            validateLabel(lblName: emailErrorLabel, hide: true, lblText: "")
        }
        
    }
    
    
    @IBAction func didTaponEditButton(_ sender: Any) {
        
        leftView.isHidden = true
        rightView.isHidden = false
        editButtonImage.isHidden = true
        selected = false
    }
    
    
    func validateLabel(lblName: UILabel, hide: Bool, lblText: String){
        lblName.isHidden = hide
        lblName.text = lblText
    }
    
    
    @IBAction func didTaponResetPasswordButton(_ sender: Any) {
        
    }
    
    @IBAction func didTapOnSaveBtn(_ sender: Any) {
        
        
        if Nametxtfld.text?.isEmpty == true || Nametxtfld.text == "" {
            validateLabel(lblName: nameErrorLabel, hide: false, lblText: "Enter Name")
        }else if emailtxtfld.text?.isEmpty == true || emailtxtfld.text == "" {
            validateLabel(lblName: emailErrorLabel, hide: false, lblText: "Enter Eamil")
        }else if emailtxtfld.text?.isValidEmail() == false {
            validateLabel(lblName: emailErrorLabel, hide: false, lblText: "Enter Valid Email")
        }else if phonenumtxtfld.text?.isEmpty == true || phonenumtxtfld.text == "" {
            validateLabel(lblName: phonenumErrorLabel, hide: false, lblText: "Enter Mobile Number")
        }else if phonenumtxtfld.text?.validateAsPhoneNumber() == false {
            validateLabel(lblName: phonenumErrorLabel, hide: false, lblText: "Enter Valid  Mobile Number")
        }else {
            var parms = [String: Any]()
            parms["email"] = self.emailtxtfld.text
            parms["full_name"] = self.Nametxtfld.text
            parms["mobile"] = self.phonenumtxtfld.text
            parms["employee_id"] = SessionManager.loginInfo?.data?.login_id
            
            self.vmodel?.ProfileApi(dictParam: parms)
        }
        
    }
    
    
    
    func ProfileSuccess(ProfileResponse: ProfileModel) {
        print("ProfileResponse....\(ProfileResponse)")
        
        rightView.isHidden = true
        leftView.isHidden =  false
        editButtonView.isHidden = false
        editButtonImage.isHidden = false
        
        
        DispatchQueue.main.async {[self] in
            
            
            UserDefaults.standard.set(ProfileResponse.data?.full_name, forKey: "fullname")
            UserDefaults.standard.set(ProfileResponse.data?.mobile, forKey: "mobile")
            UserDefaults.standard.set(ProfileResponse.data?.email, forKey: "email")
            
            NameLabel.text = UserDefaults.standard.string(forKey: "fullname")
            emailLabel.text = UserDefaults.standard.string(forKey: "email")
            numberLabel.text = UserDefaults.standard.string(forKey: "mobile")
            
            
        }
        
    }
    
}

extension ProfileVC: UITextFieldDelegate {
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if Nametxtfld.text == ""{
            nameErrorLabel.text = "Enter Name"
            nameErrorLabel.isHidden = false
        }else {
            nameErrorLabel.text = ""
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == self.phonenumtxtfld) {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne {
                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 3 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", areaCode)
                index += 3
            }
            if length - index > 3 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
        } else if textField == emailtxtfld {
            let allowedCharacterSet = CharacterSet.init(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz@-_.1234567890")
            let textCharacterSet = CharacterSet.init(charactersIn: self.emailtxtfld.text! + string)
            
            if !allowedCharacterSet.isSuperset(of: textCharacterSet) {
                return false
            }
        } else {
            return true
        }
        return true
    }
}
