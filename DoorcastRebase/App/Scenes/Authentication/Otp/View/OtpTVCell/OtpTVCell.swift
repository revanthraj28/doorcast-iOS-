//
//  otpTVCell.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 05/05/2022.
//

import UIKit

protocol ContniueButtonTVCellDelegate: class {
    func ContniueButtonIsTapped(cell: OtpTVCell)
    func resendOTPBtnisTapped(cell : OtpTVCell)
}

class OtpTVCell: UITableViewCell , UITextFieldDelegate{
    
    @IBOutlet weak var EnterOTPLBL: UILabel!
    @IBOutlet weak var declarationLBL: UILabel!
    
    @IBOutlet weak var OTPTF1: UITextField!
    @IBOutlet weak var OTPTF2: UITextField!
    @IBOutlet weak var OTPTF3: UITextField!
    @IBOutlet weak var OTPTF4: UITextField!
    
    @IBOutlet weak var OtpCountLBL: UILabel!
    
    @IBOutlet weak var resendOTPBTn: UIButton!
    @IBOutlet weak var continueBTN: UIButton!
    
    @IBOutlet weak var errorLBL: UILabel!
    
    weak var delegate : ContniueButtonTVCellDelegate?
    weak var delegate1 : ContniueButtonTVCellDelegate?
    
    var timeInterval: Int = 0 {
            didSet {
                self.OtpCountLBL.text = "00:\(timeInterval)"
            }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        uistyles()
        
        OtpCountLBL.isHidden = true
        
        OtpCountLBL.textColor = UIColor.ThemeColor
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("CustomCellUpdate"), object: nil)
        
        continueBTN.addTarget(self, action: #selector(didTapOnContinue), for: .touchUpInside)
        resendOTPBTn.addTarget(self, action: #selector(didTapOnResend), for: .touchUpInside)
        
        errorLBL.textColor = UIColor.ThemeColor
        
        continueBTN.layer.cornerRadius = 16
        
        OTPTF1.textAlignment = .center
        OTPTF2.textAlignment = .center
        OTPTF3.textAlignment = .center
        OTPTF4.textAlignment = .center
        
        OTPTF1.delegate = self
        OTPTF2.delegate = self
        OTPTF3.delegate = self
        OTPTF4.delegate = self
        
        OTPTF1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        OTPTF2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        OTPTF3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        OTPTF4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        // Initialization code
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
       }
    @objc func updateUI() {
        
       
            if(timeInterval > 0) {
                timeInterval = timeInterval - 1
                OtpCountLBL.isHidden = false
                
                resendOTPBTn.alpha = 0.5
                resendOTPBTn.isUserInteractionEnabled = false
                
            }else {
                resendOTPBTn.alpha = 1
                resendOTPBTn.isUserInteractionEnabled = true
                OtpCountLBL.isHidden = true
            }
        
            
        
            }
        
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case OTPTF1:
                OTPTF2.becomeFirstResponder()
            case OTPTF2:
                OTPTF3.becomeFirstResponder()
            case OTPTF3:
                OTPTF4.becomeFirstResponder()
            case OTPTF4:
                OTPTF4.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case OTPTF1:
                OTPTF1.becomeFirstResponder()
            case OTPTF2:
                OTPTF4.becomeFirstResponder()
            case OTPTF3:
                OTPTF2.becomeFirstResponder()
            case OTPTF4:
                OTPTF3.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        return true
    }
    func uistyles() {
        EnterOTPLBL.textColor = .black
        EnterOTPLBL.font = UIFont.poppinsSemiBold(size: 24)
        EnterOTPLBL.numberOfLines = 0
        EnterOTPLBL.textAlignment = .center
        EnterOTPLBL.text = "Enter OTP"
        
        errorLBL.isHidden = true
        
        declarationLBL.textColor = .black
        declarationLBL.font = UIFont.poppinsRegular(size: 13)
        declarationLBL.numberOfLines = 0
        declarationLBL.textAlignment = .center
        declarationLBL.text = "Enter OTP sent on your registered email address."
        
        OTPTF1.addBottomBorder()
        OTPTF2.addBottomBorder()
        OTPTF3.addBottomBorder()
        OTPTF4.addBottomBorder()
        
        continueBTN.backgroundColor = UIColor.ThemeColor
        continueBTN.titleLabel?.font = UIFont.oswaldMedium(size: 18)
        
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
        delegate?.ContniueButtonIsTapped(cell: self)
    }
    @IBAction func resendOTP(_ sender: Any) {
        delegate1?.resendOTPBtnisTapped(cell: self)
    }
    
}
