//
//  DayTaskPopviewVC.swift
//  DoorcastRebase
//
//  Created by CODEBELE-01 on 25/05/22.
//

import UIKit

class DayTaskPopviewVC: UIViewController {
    
    
    
    @IBOutlet weak var startLabel: UILabel!
    
    @IBAction func dayStartAction(_ sender: Any) {
        print("dayStartAction")
    }
    static var newInstance: DayTaskPopviewVC? {
        let storyboard = UIStoryboard(name: Storyboard.taskDetails.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? DayTaskPopviewVC
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .ThemeColor
        startLabel.textColor = .white
    }

}
