//
//  HomeVC.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import UIKit

class HomeVC: UIViewController {
    
    static var newInstance: HomeVC? {
        let storyboard = UIStoryboard(name: Storyboard.home.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? HomeVC
        return vc
    }
    @IBOutlet weak var logoutButton: UIButton!
    
    var viewModel : HomeViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Home Login info = \(SessionManager.loginInfo?.data?.accesstoken)")
        logoutButton.setMainButton()
        viewModel = HomeViewModel(self)
        viewModel.getApi()
        
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        SessionManager.logoutUser()
        self.showLogin()
    }
    
    @IBAction func goToTaskDetailsButtonAction(_ sender: Any) {
        print("ert")
        guard let vc = CommonTaskDetailVC.newInstance else {return}
        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true, completion: nil)
    }
}
extension HomeVC : HomeViewModelProtocol {
    func organizationDetails(response: HomeModel) {
        print("Organization details = \(response)")
    }
    
    
}
