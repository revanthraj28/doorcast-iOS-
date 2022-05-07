//
//  OtpVC.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 05/05/2022.
//

import UIKit

class OtpVC: UIViewController  {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var tabelView: UITableView!
    
    var otpNumber : String?
    var EmailAddress : String?
    
    var timer: Timer!
//    var count = 60  // 60sec if you want
//    var resendTimer = Timer()
    
    var viewmodel : ResendOTPViewModel?
    var ResendOTPViewResponce : ResendOTPModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        viewmodel = ResendOTPViewModel(self)
        print("otpnumber=\(otpNumber)")
        print("EmailAddress=\(EmailAddress)")
        
    }
    func style(){
        holderView.layer.cornerRadius = 16
        tabelView.register(UINib(nibName: "OtpTVCell", bundle: nil), forCellReuseIdentifier: "cell")
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.backgroundColor = .clear
        tabelView.showsHorizontalScrollIndicator = false
        
        self.holderView.backgroundColor = UIColor.AppBackgroundColor
    }
    
    @IBAction func backBTNAction(_ sender: Any) {
        gotoForgotPasswordScreen()
    }
    
}
extension OtpVC :  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OtpTVCell
        cell.timeInterval = 60
        cell.delegate = self
        cell.delegate1 = self
        
        return cell
    }
    @objc func fireCellsUpdate() {
        let notification = NSNotification(name: NSNotification.Name(rawValue: "CustomCellUpdate") , object: nil)
        NotificationCenter.default.post(notification as Notification)
       }
}
extension OtpVC : ResendOTPViewModelProtocol {
    func ResendOTPSuccess(ResendOTPResponse: ResendOTPModel) {
        self.ResendOTPViewResponce = ResendOTPResponse
        print("resendOTP = \(ResendOTPViewResponce)")
    }
    
}
extension OtpVC : ContniueButtonTVCellDelegate  {
    func resendOTPBtnisTapped(cell: OtpTVCell) {
        var parms = [String: Any]()
        parms["email"] = self.EmailAddress
        parms["otp"] = self.otpNumber
        
        self.timer = Timer(timeInterval: 1.0, target: self, selector: #selector(fireCellsUpdate), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer, forMode: RunLoop.Mode.common)
        
        self.viewmodel?.ResendOTPApi(dictParam: parms)
    }
    
    func ContniueButtonIsTapped(cell: OtpTVCell) {
        
        let data = "\(cell.OTPTF1.text ?? "")\(cell.OTPTF2.text ?? "")\(cell.OTPTF3.text ?? "")\(cell.OTPTF4.text ?? "")"
        
        if cell.OTPTF1.text == "" && cell.OTPTF2.text == "" && cell.OTPTF3.text == "" && cell.OTPTF4.text == "" {
            
            cell.errorLBL.isHidden = false
            cell.errorLBL.text = "Field is Empty"
            
        } else if otpNumber != data {
            
            cell.errorLBL.isHidden = false
            cell.errorLBL.text = "Invalid OTP"
            print("failed")
            
        } else {
            
            cell.errorLBL.isHidden = true
            print("success")
            let storyBoard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
            vc.EmailAddress = EmailAddress
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated:true, completion:nil)
            
        }
        
        cell.delegate = self
        
    }
    
    
}
