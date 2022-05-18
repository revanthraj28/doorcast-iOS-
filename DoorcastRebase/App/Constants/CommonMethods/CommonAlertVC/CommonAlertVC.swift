//
//  CommonAlertVC.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 17/05/22.
//

import UIKit

class CommonAlertVC: UIViewController {
    
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    
    static var newInstance: CommonAlertVC? {
        let storyboard = UIStoryboard(name: Storyboard.CommonAlert.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? CommonAlertVC
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        setupUI()
    }
    
    
    func setupUI() {
        
        alertLabel.text = "If you go back day will be stopped"
        alertLabel.textAlignment = .center
        alertLabel.textColor = UIColor.LabelMainTitleColor
        alertLabel.font = UIFont.oswaldRegular(size: 18)
        
        okButton.setTitle("OK", for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.backgroundColor = .ThemeColor
    }
    
   
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

    @IBAction func okButtonAction(_ sender: Any) {
        guard let vc = OnBoardingVC.newInstance else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
}
