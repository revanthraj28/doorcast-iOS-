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
    @IBOutlet weak var backButton: UIButton!
    
    
    var otpNumber : String?
    var EmailAddress : String?
    
    var timer: Timer!
    
    var viewmodel : ResendOTPViewModel?
    var ResendOTPViewResponce : ResendOTPModel?
    
    static var newInstance: OtpVC? {
        let storyboard = UIStoryboard(name: Storyboard.authentication.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? OtpVC
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        viewmodel = ResendOTPViewModel(self)
        print("otpnumber=\(otpNumber)")
        print("EmailAddress=\(EmailAddress)")
        
    }
    func style(){
        holderView.layer.cornerRadius = 10
        tabelView.register(UINib(nibName: "OtpTVCell", bundle: nil), forCellReuseIdentifier: "cell")
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.backgroundColor = .clear
        tabelView.showsHorizontalScrollIndicator = false
        self.tabelView.layer.cornerRadius = 10
        backButton.setTitle("", for: .normal)
        
        self.holderView.backgroundColor = UIColor.AppBackgroundColor
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        guard let vc = ForgotPasswordVC.newInstance else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
       
    }
    
}
extension OtpVC :  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OtpTVCell
        cell.timeInterval = 60
        cell.ContniueButtonDelegate = self
        cell.ResendOtpDelegate = self
        cell.selectionStyle = .none
        
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
    func resendOtpBtnisTapped(cell: OtpTVCell) {
        CheckInternetConnection()
//        var parms = [String: Any]()
//        parms["email"] = self.EmailAddress
//        parms["otp"] = self.otpNumber
//
//        self.timer = Timer(timeInterval: 1.0, target: self, selector: #selector(fireCellsUpdate), userInfo: nil, repeats: true)
//        RunLoop.current.add(self.timer, forMode: RunLoop.Mode.common)
//
//        self.viewmodel?.ResendOTPApi(dictParam: parms)
    }
    
    func resendOtpBtn() {
    func resendOtpBtnisTapped(cell: OtpTVCell) {
        
        var parms = [String: Any]()
        parms["email"] = self.EmailAddress
        parms["otp"] = self.otpNumber
        
        self.timer = Timer(timeInterval: 1.0, target: self, selector: #selector(fireCellsUpdate), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer, forMode: RunLoop.Mode.common)
        
        self.viewmodel?.ResendOTPApi(dictParam: parms)
    }
    
    }
    
    
    func CheckInternetConnection() {
        if ServiceManager.isConnection() == true {
            print("Internet Connection Available!")
            self.resendOtpBtn()
        }else{
            print("Internet Connection not Available!")
           
            self.showAlertOnWindow(title: "No Internet Connection!", message: "Please check your internet connection and try again", titles: ["retry"]) { (key) in
                self.CheckInternetConnection()
            }
        }
    }
    
    
    
    func ContniueButtonIsTapped(cell: OtpTVCell) {
       
        
        let data = "\(cell.OtpTF1.text ?? "")\(cell.OtpTF2.text ?? "")\(cell.OtpTF3.text ?? "")\(cell.OtpTF4.text ?? "")"
        
        if cell.OtpTF1.text == "" && cell.OtpTF2.text == "" && cell.OtpTF3.text == "" && cell.OtpTF4.text == "" {
            
            cell.errorLbl.isHidden = false
            cell.errorLbl.text = "Field is Empty"
            
        } else if otpNumber != data {
            
            cell.errorLbl.isHidden = false
            cell.errorLbl.text = "Invalid OTP"
            print("failed")
            
        } else {
            
            cell.errorLbl.isHidden = true
            print("success")
            guard let vc = ResetPasswordVC.newInstance else {return}
            vc.EmailAddress = EmailAddress
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
       
        }
        cell.ContniueButtonDelegate = self
        
    }
    
    
}
