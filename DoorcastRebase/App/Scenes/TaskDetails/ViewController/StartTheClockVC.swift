//
//  StartTheClockVC.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 10/05/22.
//

import UIKit

class StartTheClockVC: UIViewController {
    
    static var newInstance: StartTheClockVC? {
        let storyboard = UIStoryboard(name: Storyboard.taskDetails.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? StartTheClockVC
        return vc
    }
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var startTheClockView: UIView!
    @IBOutlet weak var startTheClockLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var cancelImage: UIImageView!
    @IBOutlet weak var startTimerImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        CheckInternetConnection()
    }
    
    
    @IBAction func startButtonAction(_ sender: Any) {
    }
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func updateUI() {
        cancelImage.layer.cornerRadius = 24
        startView.layer.cornerRadius = 26
        
        startView.layer.shadowColor = UIColor.gray.cgColor
        startView.layer.shadowOpacity = 0.5
        startView.layer.shadowRadius = 10
    
        
    }
    
    func CheckInternetConnection() {
        if ServiceManager.isConnection() == true {
            print("Internet Connection Available!")
        }else{
            print("Internet Connection not Available!")
            self.showAlertOnWindow(title: "No Internet Connection!", message: "Please check your internet connection and try again", titles: ["retry"]) { (key) in
                self.CheckInternetConnection()
            }
        }
    }
    
    
    
    

}
