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
        let storyboard = UIStoryboard(name: Storyboard.commonAlert.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? CommonAlertVC
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
   
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

    @IBAction func okButtonAction(_ sender: Any) {
        
    }
    
}
