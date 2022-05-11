//
//  otpTVCell.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 05/05/2022.
//

import UIKit

class OtpTVCell: UITableViewCell , UITextFieldDelegate{
    
    @IBOutlet weak var enterOtpLbl: UILabel!
    @IBOutlet weak var declarationLbl: UILabel!
    @IBOutlet weak var OtpTF1: UITextField!
    @IBOutlet weak var OtpTF2: UITextField!
    @IBOutlet weak var OtpTF3: UITextField!
    @IBOutlet weak var OtpTF4: UITextField!
    @IBOutlet weak var OtpCountLbl: UILabel!
    @IBOutlet weak var resendOtpBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var errorLbl: UILabel!
    
    weak var ContniueButtonDelegate : ContniueButtonTVCellDelegate?
    weak var ResendOtpDelegate : ContniueButtonTVCellDelegate?
    
    var timeInterval: Int = 0 {
        didSet {
            self.OtpCountLbl.text = "00:\(timeInterval)"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        UIStyles()
        
        OtpCountLbl.isHidden = true
        
        OtpCountLbl.textColor = UIColor.ThemeColor
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("CustomCellUpdate"), object: nil)
        
        continueBtn.addTarget(self, action: #selector(didTapOnContinue), for: .touchUpInside)
        resendOtpBtn.addTarget(self, action: #selector(didTapOnResend), for: .touchUpInside)
        
        errorLbl.textColor = UIColor.ThemeColor
        
        continueBtn.layer.cornerRadius = 16
        
        OtpTF1.textAlignment = .center
        OtpTF2.textAlignment = .center
        OtpTF3.textAlignment = .center
        OtpTF4.textAlignment = .center
        
        OtpTF1.delegate = self
        OtpTF2.delegate = self
        OtpTF3.delegate = self
        OtpTF4.delegate = self
        
        OtpTF1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        OtpTF2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        OtpTF3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        OtpTF4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        // Initialization code
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func updateUI() {
        
        
        if(timeInterval > 0) {
            timeInterval = timeInterval - 1
            OtpCountLbl.isHidden = false
            
            resendOtpBtn.alpha = 0.5
            resendOtpBtn.isUserInteractionEnabled = false
            
        }else {
            resendOtpBtn.alpha = 1
            resendOtpBtn.isUserInteractionEnabled = true
            OtpCountLbl.isHidden = true
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case OtpTF1:
                OtpTF2.becomeFirstResponder()
            case OtpTF2:
                OtpTF3.becomeFirstResponder()
            case OtpTF3:
                OtpTF4.becomeFirstResponder()
            case OtpTF4:
                OtpTF4.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case OtpTF1:
                OtpTF1.becomeFirstResponder()
            case OtpTF2:
                OtpTF4.becomeFirstResponder()
            case OtpTF3:
                OtpTF2.becomeFirstResponder()
            case OtpTF4:
                OtpTF3.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    // how many characters used in TextField
    func textField1(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let data = ("\(OtpTF1.text ?? "")\(OtpTF2.text ?? "")\(OtpTF3.text ?? "")\(OtpTF4.text ?? "")" )
        
        let maxLength = 4
        let currentString: NSString = data as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
    // characters allowed in textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        guard CharacterSet(charactersIn: "1234567890").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        return true
    }
    
    func UIStyles() {
        enterOtpLbl.textColor = .black
        enterOtpLbl.font = UIFont.poppinsSemiBold(size: 24)
        enterOtpLbl.numberOfLines = 0
        enterOtpLbl.textAlignment = .center
        enterOtpLbl.text = "Enter OTP"
        
        errorLbl.isHidden = true
        
        declarationLbl.textColor = .black
        declarationLbl.font = UIFont.poppinsRegular(size: 11)
        declarationLbl.numberOfLines = 0
        declarationLbl.textAlignment = .center
        declarationLbl.text = "Enter OTP sent on your registered email address."
        
        OtpTF1.addBottomBorder()
        OtpTF2.addBottomBorder()
        OtpTF3.addBottomBorder()
        OtpTF4.addBottomBorder()
        
        resendOtpBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        resendOtpBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        resendOtpBtn.layer.shadowOpacity = 1.0
        resendOtpBtn.layer.shadowRadius = 0.0
        resendOtpBtn.layer.masksToBounds = false
        resendOtpBtn.layer.cornerRadius = 4.0
        
        continueBtn.backgroundColor = UIColor.ThemeColor
        continueBtn.titleLabel?.font = UIFont.oswaldMedium(size: 18)
        
    }
    @objc  func  didTapOnContinue() {
        
    }
    @objc func didTapOnResend(){
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func contniueBTNAction(_ sender: Any) {
        ContniueButtonDelegate?.ContniueButtonIsTapped(cell: self)
    }
    @IBAction func resendOTP(_ sender: Any) {
        ResendOtpDelegate?.resendOtpBtnisTapped(cell: self)
    }
    
}

protocol ContniueButtonTVCellDelegate: class {
    func ContniueButtonIsTapped(cell: OtpTVCell)
    func resendOtpBtnisTapped(cell : OtpTVCell)
}
