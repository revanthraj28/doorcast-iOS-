//
//  SelectUserVC.swift
//  ExStream
//
//  Created by Vijay Kumar on 25/11/20.
//  Copyright © 2020 Codebele-01. All rights reserved.
//

import UIKit
import DropDown
//import SVProgressHUD

class SelectUserVC: UIViewController {
    
    
    @IBOutlet var emptyMessageLabel: UILabel!
    @IBOutlet var holderView: UIView!
    @IBOutlet var titleBackground: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var userTV: UITableView!
    @IBOutlet var bottomBackground: UIView!
    @IBOutlet var addUserView: UIView!
    @IBOutlet var addUserImage: UIImageView!
    @IBOutlet var addUserBtn: UIButton!
    @IBOutlet var cancelView: UIView!
    @IBOutlet var cancelImage: UIImageView!
    @IBOutlet var cancelBtn: UIButton!
    
    
    var isSelected = String()
    
    var ReassignCrewResponseModel : reassignCrewModel?
    var vmodel : ReassignCrewViewModel?
    
    var getCrewResponseModel : CrewModel?
    var ViewModel : CrewViewModel?
    
    var ForceFinishResponseModel : ForceFinishModel?
    var ViewModel1 : ForceFinishViewModel?
    
    var ForceStopResponseModel : ForceModel?
    var ForceStopViewModel1 : ForceStopViewModel?
    
    var parms = [String: Any]()
    
    var propertiename = [String]()
    
    static var newInstance: SelectUserVC? {
        let storyboard = UIStoryboard(name: Storyboard.taskDetails.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? SelectUserVC
        return vc
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isSelected == "Reassign Crew"{
            
            cancelView.isHidden = true
            addUserView.alpha = 1.0
            addUserBtn.isUserInteractionEnabled = true
            addUserView.backgroundColor = UIColor.ThemeColor
            addUserView.addCornerRadiusWithShadow(color: .lightGray, borderColor: .clear, cornerRadius: addUserView.layer.frame.size.width / 2)
            addUserImage.image = UIImage(named: "cancel")
            //            userTV.allowsMultipleSelection = false
            userTV.reloadData()
            
            ReassignCrewCallAPI()
            
        }  else if  isSelected == "Add Crew"{
            
            cancelView.isHidden = false
            addUserView.alpha = 1.0
            addUserBtn.isUserInteractionEnabled = true
            addUserView.addCornerRadiusWithShadow(color: .lightGray, borderColor: .clear, cornerRadius: addUserView.layer.frame.size.width / 2)
            //            userTV.allowsMultipleSelection = false
            
            AddCrewCallApi()
            
            
        } else if isSelected == "Force Finish"{
            cancelView.isHidden = false
            addUserView.alpha = 1.0
            addUserBtn.isUserInteractionEnabled = true
            addUserView.addCornerRadiusWithShadow(color: .lightGray, borderColor: .clear, cornerRadius: addUserView.layer.frame.size.width / 2)
            //            userTV.allowsMultipleSelection = true
            
            ForceFinishCallAPI()
        }
        else {
            self.addUserView.alpha = 0.6
            self.addUserBtn.isUserInteractionEnabled = false
        }
    }
    
    func ReassignCrewCallAPI() {
        parms["task_id"] = defaults.string(forKey: UserDefaultsKeys.task_id)
        parms["property_id"] = defaults.string(forKey: UserDefaultsKeys.property_id)
        parms["type"] = defaults.string(forKey: UserDefaultsKeys.task_type)
        self.vmodel?.ReassignCrewApi(dictParam: parms)
    }
    
    func AddCrewCallApi() {
        parms["task_id"] = defaults.string(forKey: UserDefaultsKeys.task_id)
        parms["property_id"] = defaults.string(forKey: UserDefaultsKeys.property_id)
        self.ViewModel?.CrewApi(dictParam: parms)
    }
    
    func ForceFinishCallAPI() {
        parms["task_id"] = defaults.string(forKey: UserDefaultsKeys.task_id)
        parms["property_id"] = defaults.string(forKey: UserDefaultsKeys.property_id)
        parms["type"] = defaults.string(forKey: UserDefaultsKeys.task_type)
        self.ViewModel1?.ForceFinishApi(dictParam: parms)
    }
    func ForceStopCallApi(){
        //        parms["crew_list"] = defaults.string(forKey: UserDefaultsKeys.crew_list)
        //        parms["task_list"] = defaults.string(forKey: UserDefaultsKeys.task_list)
        //        parms["main_task_id"] = defaults.string(forKey: UserDefaultsKeys.task_type)
        //        parms["org_id"] = defaults.string(forKey: UserDefaultsKeys.task_type)
        //        self.ForceStopViewModel1?.ForceStopApi(dictParam: parms)
        
        var parms = [String: Any]()
        parms["crew_list"] =
        parms["task_list"] =
        parms["main_task_id"] = defaults.string(forKey: UserDefaultsKeys.task_id)
        parms["org_id"] = defaults.string(forKey: UserDefaultsKeys.org_id)
    }
    //    {"crew_list":"749","task_list":"3049","main_task_id":"3049","org_id":"24"}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vmodel = ReassignCrewViewModel(self)
        ViewModel = CrewViewModel(self)
        ViewModel1 = ForceFinishViewModel(self)
        ForceStopViewModel1 = ForceStopViewModel(self)
        
        emptyMessageLabel.isHidden = true
        updateUI()
        
        userTV.delegate = self
        userTV.dataSource = self
        userTV.register(UINib(nibName: "LabelTVCell", bundle: nil), forCellReuseIdentifier: "LabelTVCell")
        userTV.reloadData()
        userTV.allowsMultipleSelection = true
        holderView.clipsToBounds = true
        holderView.layer.cornerRadius = 3
        holderView.backgroundColor = .white
        
    }
    
    func updateUI(){
        bottomBackground.backgroundColor = .white
        addUserView.layer.cornerRadius = addUserView.frame.size.width / 2
        cancelView.layer.cornerRadius = cancelView.frame.size.width / 2
        addUserView.clipsToBounds = true
        cancelView.clipsToBounds = true
        addUserView.addCornerRadiusWithShadow(color: .lightGray, borderColor: .clear, cornerRadius: addUserView.layer.frame.size.width / 2)
        cancelView.addCornerRadiusWithShadow(color: .lightGray, borderColor: .clear, cornerRadius: cancelView.layer.frame.size.width / 2)
        self.addUserView.alpha = 0.6
        self.addUserBtn.isUserInteractionEnabled = false
    }
    
    
    func updateFontsAndColors(){
        
        emptyMessageLabel.font = UIFont.oswaldRegular(size: 16)
        emptyMessageLabel.textColor = .darkGray
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSelected == "Force Finish" {
            print("ForceFinish.....")
            return self.ForceFinishResponseModel?.data!.count ?? 1
        } else if isSelected == "Add Crew" {
            print("getCrewResponseModel")
            return self.getCrewResponseModel?.data!.count ?? 1
        } else  {
            print("ReassignCrewResponseModel")
            return self.ReassignCrewResponseModel?.data!.count ?? 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTVCell", for: indexPath) as! LabelTVCell
        
        let data = ReassignCrewResponseModel?.data?[indexPath.row]
        let data1 = getCrewResponseModel?.data?[indexPath.row]
        let data2 = ForceFinishResponseModel?.data?[indexPath.row]
        
        if isSelected == "Reassign Crew" {
            print("Reassign Crew")
            cell.commomLabel.textColor = .black
            cell.commomLabel.text = data?.crew_name
            cell.checkImage.isHidden = false
            return cell
        } else if isSelected == "Add Crew" {
            print("Add Crew")
            cell.commomLabel.textColor = .black
            cell.commomLabel.text = data1?.propertyUser_name
            cell.checkImage.isHidden = false
            return cell
        }else if isSelected == "Force Finish" {
            print("ForceFinish Crew")
            cell.commomLabel.text = data2?.crew_name
            cell.commomLabel.textColor = .black
            //            defaults.set(data2?.task_id , forKey: UserDefaultsKeys.task_id)
            return cell
        }
        
        return cell
        
    }
    
    @IBAction func AddUserButtonAction(_ sender: Any) {
        
        dismiss(animated: false, completion: nil)
    }
    @IBAction func CancelButtonAction(_ sender: Any) {
        
        dismiss(animated: false, completion: nil)
        
    }
    
    
}

extension SelectUserVC: ReassignCrewModelProtocol , CrewViewModelProtocol , ForceFinishViewModelProtocol , ForceStopViewModelProtocol
{
    func ForceStopSuccess(ForceStopResponse: ForceModel) {
        self.ForceStopResponseModel = ForceStopResponse
        print("ForceStopResponse\(ForceStopResponse)")
        
    }
    
    func ForceFinishSuccess(ForceFinishResponse: ForceFinishModel) {
        self.ForceFinishResponseModel = ForceFinishResponse
        print("j,ashvd\(ForceFinishResponseModel)")
        DispatchQueue.main.async {
            self.userTV.reloadData()
        }
    }
    
    func CrewSuccess(CrewResponse: CrewModel) {
        self.getCrewResponseModel = CrewResponse
        DispatchQueue.main.async {
            self.userTV.reloadData()
        }
        
        if getCrewResponseModel?.data?.count == 0
        {
            self.emptyMessageLabel.isHidden = false
            self.emptyMessageLabel.text = "No data found"
            self.userTV.isHidden = true
        }
    }
    
    
    func ReassignCrewSuccess(ReassignCrewResponse: reassignCrewModel) {
        self.ReassignCrewResponseModel = ReassignCrewResponse
        
        
        DispatchQueue.main.async {
            self.userTV.reloadData()
        }
    }
}

extension SelectUserVC :  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
        if isSelected == "Reassign Crew" {
            let cell = userTV.cellForRow(at: indexPath) as! LabelTVCell
            cell.holderView.backgroundColor = UIColor.InactiveStateColor.withAlphaComponent(0.3)
            
            
        }
        
        if isSelected == "Force Finish" {
            
            let cell = userTV.cellForRow(at: indexPath) as! LabelTVCell
            cell.holderView.backgroundColor = UIColor(named: "InactiveStateColor")?.withAlphaComponent(0.3)
            
            self.propertiename.append(ForceFinishResponseModel?.data?[indexPath.row].crew_name ?? "")
            print("name of properties in array \(propertiename)")
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if isSelected == "Force Finish" {
            
            let cell = userTV.cellForRow(at: indexPath) as! LabelTVCell
            cell.holderView.backgroundColor = UIColor.white
            
            let item =  ForceFinishResponseModel?.data?[indexPath.row].crew_name
            var deselectedIndex: Int?
            for (index,value) in propertiename.enumerated() {
                if value == item {
                    deselectedIndex = index
                }
            }
            
            propertiename.remove(at: deselectedIndex ?? 0)
            print("removed propertie name\(propertiename)")
            
        }
    }
    
    
    
}
