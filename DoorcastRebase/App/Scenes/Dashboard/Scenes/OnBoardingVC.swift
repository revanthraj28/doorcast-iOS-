//
//  OnBoardingVC.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 04/05/22.
//

import UIKit

class OnBoardingVC: UIViewController {
    
    static var newInstance: OnBoardingVC? {
        let storyboard = UIStoryboard(name: Storyboard.dashboard.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? OnBoardingVC
        return vc
    }
    @IBOutlet weak var logoutHolderView: UIView!
    
    @IBOutlet weak var CommonNavBarView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
//    @IBOutlet weak var logoutImg: UIImageView!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var allTasksView: UIView!
    @IBOutlet weak var allTasksLabel: UILabel!
    @IBOutlet weak var allTasksBtn: UIButton!
    @IBOutlet weak var CompanyTV: UITableView!
    
    // To get organization from model
    var crewOrganisations: GetOrganizationsModel?
    var viewModel : GetOrganizationsViewModel!
    
    // for logout api
    var logoutdata : LogoutModel!
    var logoutModel : LogoutViewModel!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        defaults.set("", forKey: UserDefaultsKeys.screenlanding)
        incompleteScreen = ""
        usernameLabel.text = UserDefaults.standard.string(forKey: "fullname")?.uppercased()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutHolderView.layer.cornerRadius = logoutHolderView.frame.size.height / 2
        
      //  usernameLabel.text = SessionManager.loginInfo?.data?.fullname?.uppercased() ?? ""
     //   usernameLabel.text = UserDefaults.standard.string(forKey: "fullname")
        
        
        CompanyTV.backgroundColor = .white
        view.backgroundColor = .white
        updateColor()
        updateFonts()
        allTasksLabel.text = "TASK SUMMARY"
        allTasksLabel.textAlignment = .center
        
        dateLabel.text =  Date().MonthDateDayFormatter?.uppercased()

        CompanyTV.allowsSelection = true
        CompanyTV.delegate = self
        CompanyTV.dataSource = self
        
//        CompanyTV.register(CompanyTVCell.self, forCellReuseIdentifier: "CompanyTVCell")
        CompanyTV.register(UINib(nibName: "CompanyTVCell", bundle: nil), forCellReuseIdentifier: "CompanyTVCell")
        
        print("Home Login info = \(SessionManager.loginInfo?.data?.accesstoken)")
        viewModel = GetOrganizationsViewModel(self)
        viewModel.getOrganizationApi()
        CheckInternetConnection()
    }
     
    func updateFonts() {
        // to add fonts
        allTasksLabel.font = UIFont.oswaldMedium(size: 22)
        dateLabel.font = UIFont.oswaldMedium(size: 18)
        usernameLabel.font = UIFont.oswaldMedium(size: 18)
    }

    func updateColor() {
        // to add colors
        allTasksLabel.textColor = UIColor.AppBackgroundColor
        allTasksView.backgroundColor = UIColor.ThemeColor
        dateLabel.textColor = UIColor.white
        usernameLabel.textColor = UIColor.white
    }

    @IBAction func logoutBtnIsTapped(_ sender: Any) {
        // func to be executed when logged out
        
        CheckInternetConnection()
        print("logoutttt.....")
        logoutModel = LogoutViewModel(self)
        logoutModel.logoutApi()
    }
    
//    func logoutBtnApi() {
//    logoutModel = LogoutViewModel(self)
//    logoutModel.logoutApi()
//  }
    
    func CheckInternetConnection() {
        if ServiceManager.isConnection() == true {
            print("Internet Connection Available!")
//            self.logoutBtnApi()
        }else{
            print("Internet Connection not Available!")
            self.showAlertOnWindow(title: "No Internet Connection!", message: "Please check your internet connection and try again", titles: ["retry"]) { (key) in
                self.CheckInternetConnection()
            }
        }
    }
    
    @IBAction func allTasksBtnIsTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "TaskDetails", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier :"CommonTaskDetailVC") as? CommonTaskDetailVC {
            showproperty = "all"
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true)
        }
               
    }
    
}

extension OnBoardingVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return crewOrganisations?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CompanyTV.dequeueReusableCell(withIdentifier: "CompanyTVCell", for: indexPath) as! CompanyTVCell
        cell.titleLabel.text = crewOrganisations?.data?[indexPath.row].organization_name
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        // to move to next screen and move id's to next screen
        
        guard let vc = CrewPropertiesVC.newInstance else {return}
        
        UserDefaults.standard.set(crewOrganisations?.data?[indexPath.row].organization_id ?? "", forKey: "type")
        vc.getOrganizationsModelData = crewOrganisations?.data?[indexPath.row]
        vc.type =  crewOrganisations?.data?[indexPath.row].organization_id ?? ""
        vc.orgname = crewOrganisations?.data?[indexPath.row].organization_name ?? ""
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        print(crewOrganisations?.data?[indexPath.row].organization_id ?? "")
        
   }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
extension OnBoardingVC : GetOrganizationsModelProtocol, LogoutViewModelProtocol {
    func logoutSuccess(logoutResponse: LogoutModel) {
        
      // api of logout
        DispatchQueue.main.async {
            self.showLogin()
            SessionManager.logoutUser()
        }
    }
    func organizationDetails(response: GetOrganizationsModel) {
        // api for organization
        print("Organization details = \(response)")
        crewOrganisations = response
        print("org name = \(response.data?.first?.organization_name ?? "")")
        DispatchQueue.main.async {
            self.CompanyTV.reloadData()
        }
        
        
    }
    
}
