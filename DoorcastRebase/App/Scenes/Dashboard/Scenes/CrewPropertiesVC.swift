//
//  CrewPropertiesVC.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 05/05/22.
//

import UIKit

class CrewPropertiesVC: UIViewController {

   
    
    static var newInstance: OnBoardingVC? {
        let storyboard = UIStoryboard(name: Storyboard.home.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? OnBoardingVC
        return vc
    }
    
    @IBOutlet weak var propertiesTV: UITableView!
    @IBOutlet weak var lbl_chooseProperties: UILabel!
    @IBOutlet weak var allPropertiesBackground: UIView!
    @IBOutlet weak var organizationName: UILabel!
    @IBOutlet weak var allPropertiesBtn: UIButton!
    @IBOutlet weak var showSelectedBackground: UIView!
    @IBOutlet weak var selectedPropertiesBtn: UIButton!
    @IBOutlet weak var commonNavBar: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var menuImg: UIImageView!
    @IBOutlet weak var menuBtnI: UIButton!
    @IBOutlet weak var sideArrowImg: UIImageView!
    @IBOutlet weak var sideArrowBtn: UIButton!
    
    var getOrganizationsModelData : GetOrganizationsModelData?
    
    var crewproperties: CrewPropertyModel? // model for api
    var CrewPropertiesData  : CrewPropertiesData?
    var crewviewModel : CrewProperties?
    var type = String()
    var orgname = String()
    var crewPropertIds = [String]()
    var propertyName: Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        // written payload here.
        
        self.organizationName.text = self.orgname
        
        var parms = [String: Any]()
        parms["type"] = getOrganizationsModelData?.organization_id
        crewviewModel?.CrewPropertiesApi(dictParam: parms)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLabel.text = SessionManager.loginInfo?.data?.fullname?.uppercased() ?? ""
        
        crewviewModel = CrewProperties(self)
        
        dateLabel.text =  Date().MonthDateDayFormatter?.uppercased()
        
        propertiesTV.allowsSelection = true
        propertiesTV.delegate = self
        propertiesTV.dataSource = self
        propertiesTV.allowsMultipleSelection = true
        
        propertiesTV.register(CompanyTVCell.self, forCellReuseIdentifier: "CrewPropertiesTVCell")
        propertiesTV.register(UINib(nibName: "CrewPropertiesTVCell", bundle: nil), forCellReuseIdentifier: "CrewPropertiesTVCell")
        propertiesTV.register(UINib(nibName: "LabelTVCell", bundle: nil), forCellReuseIdentifier: "LabelTVCell")
        
        
        print("Home Login info = \(SessionManager.loginInfo?.data?.accesstoken)")
        
    }
    
    func updateFonts() {
        // to add fonts
    dateLabel.font = UIFont.oswaldRegular(size: 18)
    userNameLabel.font = UIFont.oswaldRegular(size: 18)
        
    }
    
    
    func updateColor() {
        // to add colors
    
        dateLabel.textColor = UIColor.white
        lbl_chooseProperties.textColor = UIColor.ThemeColor
        userNameLabel.textColor = UIColor.white
        propertiesTV.backgroundColor = .opaqueSeparator
        view.backgroundColor = .opaqueSeparator
        
    }
    
    @IBAction func didTapOnAllProperties(_ sender: Any) {
        
        let sb = UIStoryboard(name: "TaskDetails", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CommonTaskDetailVC")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
        
    }
    
    @IBAction func ShowSelectedProperties(_ sender: Any) {
        
        
    }
    @IBAction func menuBtn(_ sender: Any) {
    
      gotoNotificationScreen()

    }
    
    
    @IBAction func sidearrowBtnIsTapped(_ sender: Any) {
        // to move to previous screen
        let storyBoard: UIStoryboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "OnBoardingVC") as! OnBoardingVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}


extension CrewPropertiesVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return crewproperties?.data[section].propertyData.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = propertiesTV.dequeueReusableCell(withIdentifier: "CrewPropertiesTVCell", for: indexPath) as! CrewPropertiesTVCell
        
        let data = crewproperties?.data[indexPath.section].propertyData
        cell.lbl_PropertiesValue.text = data?[indexPath.row].propertyName
        cell.lbl_PropertiesValue.textAlignment = .left
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // to append data coming from get_proprty Id
        
        let cell = tableView.cellForRow(at: indexPath) as! CrewPropertiesTVCell
        cell.PropertiesHolderView.backgroundColor = .ThemeColor
        cell.btn_checked.isHidden = false
        cell.lbl_PropertiesValue.textColor = .white
        showSelectedBackground.backgroundColor = .ThemeColor
        
        propertyName = false
        self.crewPropertIds.append((crewproperties?.data[indexPath.section].propertyData[indexPath.row].propertyID)!)
        
        // to change the color when selected the view of showSelectedBackground
           if crewPropertIds.count > 0 {
            showSelectedBackground.backgroundColor = .ThemeColor
            
        }else{
            showSelectedBackground.backgroundColor = .gray
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CrewPropertiesTVCell
        cell.PropertiesHolderView.backgroundColor = .white
        cell.btn_checked.isHidden = true
        cell.lbl_PropertiesValue.textColor = .black
        propertyName = true
       
        
      
        
        let item = crewproperties?.data[indexPath.section].propertyData[indexPath.row].propertyID
        let itemToRemove = item
        if let index = crewPropertIds.firstIndex(of: itemToRemove!)
        {
            crewPropertIds.remove(at: index)
        }
        print(crewPropertIds.count)
        
        // to change the color when deselected the view of showSelectedBackground
        if crewPropertIds.count > 0 {
            showSelectedBackground.backgroundColor = .ThemeColor
            
        }else{
            showSelectedBackground.backgroundColor = .gray
            
        }
        
        
        
    }
    
}


extension CrewPropertiesVC : CrewPropertyModelProtocol{
    // api for get property details
    
    func CrewPropertyDetails(response: CrewPropertyModel) {
        print("Organization details = \(response)")
        crewproperties = response
        print("org name = \(response.data.first?.clientName ?? "")")
        
        
        DispatchQueue.main.async {
            self.propertiesTV.reloadData()
        }
        
    }
}
