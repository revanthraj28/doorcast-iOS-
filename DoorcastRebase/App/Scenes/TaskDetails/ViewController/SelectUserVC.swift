//
//  SelectUserVC.swift
//  ExStream
//
//  Created by Vijay Kumar on 25/11/20.
//  Copyright © 2020 Codebele-01. All rights reserved.
//

import UIKit
import DropDown

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
    
    //var used to select perticular data
    var isSelected = String()
    var ReassignCrewResponseModel : reassignCrewModel?
    var vmodel : ReassignCrewViewModel?
    var ReassignResponseModel : ReassignModel?
    var ReassignViewModel1 : ReassignViewModel?
    var getCrewResponseModel : CrewModel?
    var ViewModel : CrewViewModel?
    var ForceFinishResponseModel : ForceFinishModel?
    var ViewModel1 : ForceFinishViewModel?
    var ForceStopResponseModel : ForceModel?
    var ForceStopViewModel1 : ForceStopViewModel?
    var AddCrewResponseModel : AddCrewModel?
    var addViewMOdel : AddCrewViewModel?
    var parms = [String: Any]()
    
    //var used to append data in a array
    var propertiename = [String]()
    var propertyUserList = [String]()
    var employeeList = [String]()
    var taskList = [String]()
    var user_type = [String]()
    var selectedListCount = Int()
    
    var deselectedIndex: Int?
    var count = 0
    
    static var newInstance: SelectUserVC? {
        let storyboard = UIStoryboard(name: Storyboard.taskDetails.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? SelectUserVC
        return vc
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        propertyUserList.removeAll()
        employeeList.removeAll()
        propertiename.removeAll()
        taskList.removeAll()
        user_type.removeAll()
        
        if isSelected == "Reassign Crew"{
            
            cancelView.isHidden = true
            addUserView.alpha = 1.0
            addUserBtn.isUserInteractionEnabled = true
            addUserView.backgroundColor = UIColor.ThemeColor
            addUserView.addCornerRadiusWithShadow(color: .lightGray, borderColor: .clear, cornerRadius: addUserView.layer.frame.size.width / 2)
            addUserImage.image = UIImage(named: "cancel")
            userTV.reloadData()
            ReassignCrewCallAPI()
            
        }  else if  isSelected == "Add Crew"{
            
            cancelView.isHidden = false
            addUserView.addCornerRadiusWithShadow(color: .lightGray, borderColor: .clear, cornerRadius: addUserView.layer.frame.size.width / 2)
            AddCrewCallApi()
            
            
        } else if isSelected == "Force Finish"{
            cancelView.isHidden = false
            addUserView.alpha = 1.0
            addUserBtn.isUserInteractionEnabled = true
            addUserView.addCornerRadiusWithShadow(color: .lightGray, borderColor: .clear, cornerRadius: addUserView.layer.frame.size.width / 2)
            
            ForceFinishCallAPI()
            
        }
        else {
            self.addUserView.alpha = 0.6
            self.addUserBtn.isUserInteractionEnabled = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vmodel = ReassignCrewViewModel(self)
        ViewModel = CrewViewModel(self)
        ViewModel1 = ForceFinishViewModel(self)
        ForceStopViewModel1 = ForceStopViewModel(self)
        addViewMOdel = AddCrewViewModel(self)
        ReassignViewModel1 = ReassignViewModel(self)
        
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
        
        parms["crew_list"] = self.employeeList.joined(separator: ",")
        parms["task_list"] = self.taskList.joined(separator: ",")
        parms["main_task_id"] = defaults.string(forKey: UserDefaultsKeys.task_id)
        parms["org_id"] = defaults.string(forKey: UserDefaultsKeys.org_id)
        
        self.ForceStopViewModel1?.ForceStopApi(dictParam: parms)
    }
    
    func AddcrewApiCall(){
        
        parms["propertyUser_list"] = self.propertyUserList.joined(separator: ",")
        parms["employee_list"] = self.employeeList.joined(separator: ",")
        parms["taskId"] = defaults.string(forKey: UserDefaultsKeys.task_id)
        parms["main_task_id"] = defaults.string(forKey: UserDefaultsKeys.task_id)
        parms["type"] = defaults.string(forKey: UserDefaultsKeys.task_type)
        parms["org_id"] = defaults.string(forKey: UserDefaultsKeys.org_id)
        
        self.addViewMOdel?.AddCrewApi(dictParam: parms)
    }
    
    func ReassignApiCall(){
        parms["crew_list"] = self.employeeList.joined(separator: ",")
        parms["task_list"] = self.taskList.joined(separator: ",")
        parms["user_type"] = self.user_type.joined(separator: ",")
        parms["main_task_id"] = defaults.string(forKey: UserDefaultsKeys.task_id)
        parms["org_id"] = defaults.string(forKey: UserDefaultsKeys.org_id)
        
        self.ReassignViewModel1?.reassignApi(dictParam: parms)
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
    
    
    
    @IBAction func AddUserButtonAction(_ sender: Any) {
        
        if isSelected == "Add Crew" {
            AddcrewApiCall()
        } else if isSelected == "Force Finish" {
            ForceStopCallApi()
        } else if isSelected == "Reassign Crew" {
            
        }
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func CancelButtonAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    
}

extension SelectUserVC :  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSelected == "Force Finish" {
            return self.ForceFinishResponseModel?.data!.count ?? 1
        } else if isSelected == "Add Crew" {
            return self.getCrewResponseModel?.data!.count ?? 1
        } else  {
            return self.ReassignCrewResponseModel?.data!.count ?? 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTVCell", for: indexPath) as! LabelTVCell
        
        let data = ReassignCrewResponseModel?.data?[indexPath.row]
        let data1 = getCrewResponseModel?.data?[indexPath.row]
        let data2 = ForceFinishResponseModel?.data?[indexPath.row]
        
        if isSelected == "Reassign Crew" {
            
            if data?.user_type == "inprogress"{
                
                cell.commomLabel.textColor = .black
                cell.commomLabel.text = data?.crew_name
                cell.checkImage.isHidden = false
                cell.checkImage.image = UIImage(named: "taskChecked")
                
            }else{
                cell.checkImage.isHidden = false
                cell.checkImage.image = UIImage(named: "taskUnCheck")
                cell.commomLabel.textColor = .black
                cell.commomLabel.text = data?.crew_name
                cell.backgroundColor = .white
                
            }
            return cell
            
        } else if isSelected == "Add Crew" {
            
            cell.commomLabel.textColor = .black
            cell.commomLabel.text = data1?.propertyUser_name
            cell.checkImage.isHidden = true
            return cell
        }else if isSelected == "Force Finish" {
            
            cell.commomLabel.text = data2?.crew_name
            cell.commomLabel.textColor = .black
            return cell
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = userTV.cellForRow(at: indexPath) as! LabelTVCell
        if isSelected == "Add Crew" {
            
            self.propertyUserList.append(getCrewResponseModel?.data?[indexPath.row].propertyUser_id ?? "")
            self.employeeList.append(getCrewResponseModel?.data?[indexPath.row].employee_id ?? "")
            cell.holderView.backgroundColor = UIColor(named: "InactiveStateColor")?.withAlphaComponent(0.3)
            
            if propertyUserList.count > 0 {
                
                self.addUserView.alpha = 1.0
                self.addUserBtn.isUserInteractionEnabled = true
                
            } else {
                
                self.addUserView.alpha = 0.6
                self.addUserBtn.isUserInteractionEnabled = false
                
            }
        }
        
        
        else if isSelected == "Reassign Crew" {
            
            self.taskList.removeAll()
            self.employeeList.removeAll()
            self.user_type.removeAll()
            
            cell.holderView.backgroundColor = UIColor(named: "InactiveStateColor")?.withAlphaComponent(0.3)
            
            self.taskList.append(ReassignCrewResponseModel?.data?[indexPath.row].task_id ?? "")
            self.employeeList.append(ReassignCrewResponseModel?.data?[indexPath.row].crew_id ?? "")
            self.user_type.append(ReassignCrewResponseModel?.data?[indexPath.row].user_type ?? "")
            
            UserDefaults.standard.set(taskList, forKey: "taskList")
            
            print("taskList\(taskList)")
            if employeeList.count > 0 {
                
                self.addUserView.alpha = 1.0
                self.addUserBtn.isUserInteractionEnabled = true
            } else {
                self.addUserView.alpha = 0.6
                self.addUserBtn.isUserInteractionEnabled = false
            }
            
            if count == 1 && self.ReassignCrewResponseModel?.data?[indexPath.row].user_type == "inprogress" {
                showAlertOnWindow(title: "", message: "At least one person needs to be assigned to the task to proceed.", titles: ["OK"], completionHanlder: { _ in })
                
                print("only one is left .......")
            }else {
                if self.ReassignCrewResponseModel?.data?[indexPath.row].user_type == "inprogress" {
                    ForceStopCallApi()
                } else if self.ReassignCrewResponseModel?.data?[indexPath.row].user_type == "new" {
                    AddcrewApiCall()
                } else if self.ReassignCrewResponseModel?.data?[indexPath.row].user_type == "existing"{
                    ReassignApiCall()
                }
            }
        }
        
        else if isSelected == "Force Finish" {
            
            cell.holderView.backgroundColor = UIColor(named: "InactiveStateColor")?.withAlphaComponent(0.3)
            
            self.taskList.append(ForceFinishResponseModel?.data?[indexPath.row].task_id ?? "")
            self.employeeList.append(ForceFinishResponseModel?.data?[indexPath.row].crew_id ?? "")
            if employeeList.count > 0{
                self.addUserView.alpha = 1.0
                self.addUserBtn.isUserInteractionEnabled = true
            }else{
                self.addUserView.alpha = 0.6
                self.addUserBtn.isUserInteractionEnabled = false
            }
            
            print("name of properties in array \(employeeList)")
        }
        
        //        if ForceStopResponseModel?.data?[indexPath.section].sub_task_assined_to_this_crew == false {
        //            NotificationCenter.default.post(name: NSNotification.Name("hidetimerView"), object: nil)
        //
        //        } else {
        //            print("NotificationCenter")
        //        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = userTV.cellForRow(at: indexPath) as! LabelTVCell
        
        if isSelected == "Add Crew" {
            
            cell.holderView.backgroundColor = UIColor.white
            let element  = getCrewResponseModel?.data?[indexPath.row].propertyUser_id
            
            // used this for deselect propertyUserList
            for(index,value) in propertyUserList.enumerated() {
                if value == element {
                    deselectedIndex = index
                }
            }
            propertyUserList.remove(at: deselectedIndex ?? 0)
            
            if propertyUserList.count >= 1 {
                self.addUserView.alpha = 1.0
                self.addUserBtn.isUserInteractionEnabled = true
            } else {
                self.addUserView.alpha = 0.6
                self.addUserBtn.isUserInteractionEnabled = false
            }
            print("removed propertieuserlist\(propertyUserList)")
            
            //used this for deselect employeeList
            for(index,value) in employeeList.enumerated() {
                if value == element {
                    deselectedIndex = index
                }
            }
            employeeList.remove(at: deselectedIndex ?? 0)
            
        }
        
        if isSelected == "Reassign Crew" {
            
            cell.holderView.backgroundColor = UIColor.white
            
            if let index = self.employeeList.firstIndex(of: ReassignCrewResponseModel?.data?[indexPath.row].crew_id ?? "") {
                self.employeeList.remove(at: index)
                print("\(employeeList)")
            }
            
            if let index = self.taskList.firstIndex(of: ReassignCrewResponseModel?.data?[indexPath.row].task_id ?? "") {
                self.taskList.remove(at: index)
                print("\(taskList)")
            }
            
            if let index = self.user_type.firstIndex(of: ReassignCrewResponseModel?.data?[indexPath.row].user_type ?? "") {
                self.user_type.remove(at: index)
                print("\(user_type)")
            }
            //            if selectedListCount == 1 {
            //
            //            }else{
            //                ReassignApiCall()
            //            }
            
            
        }
        
        if isSelected == "Force Finish" {
            
            
            cell.holderView.backgroundColor = UIColor.white
            let item =  ForceFinishResponseModel?.data?[indexPath.row].crew_name
            //deselect employeeList
            for (index,value) in employeeList.enumerated() {
                if value == item {
                    deselectedIndex = index
                }
            }
            employeeList.remove(at: deselectedIndex ?? 0)
            
            //deselect taskList
            for (index,value) in taskList.enumerated() {
                if value == item {
                    deselectedIndex = index
                }
            }
            
            taskList.remove(at: deselectedIndex ?? 0)
            
        }
    }
    
    
    
}
extension SelectUserVC: ReassignCrewModelProtocol , CrewViewModelProtocol , ForceFinishViewModelProtocol , ForceStopViewModelProtocol , AddCrewViewModelProtocol , ReassignViewModelProtocol
{
    func ReassignSuccess(ReassignResponse: ReassignModel) {
        self.ReassignResponseModel = ReassignResponse
        showAlertOnWindow(title: "", message: "Added successfully", titles: ["OK"], completionHanlder: {_ in})
        DispatchQueue.main.async {
            
            self.ReassignCrewCallAPI()
            
        }
        print("ReassignResponseModel\(ReassignResponseModel?.data)")
    }
    
    func AddCrewSuccess(AddCrewResponse: AddCrewModel) {
        self.AddCrewResponseModel = AddCrewResponse
        
        
        DispatchQueue.main.async {
            
            self.ReassignCrewCallAPI()
        }
        print("AddCrewResponseModel\(AddCrewResponseModel?.data)")
    }
    
    func ForceStopSuccess(ForceStopResponse: ForceModel) {
        self.ForceStopResponseModel = ForceStopResponse
        
        print("ForceStopResponse\(ForceStopResponse)")
        showAlertOnWindow(title: "", message: "Updated successfully", titles: ["OK"], completionHanlder: {_ in})
        DispatchQueue.main.async {
            
            self.ReassignCrewCallAPI()
            
        }
        
        
        
    }
    
    func ForceFinishSuccess(ForceFinishResponse: ForceFinishModel) {
        self.ForceFinishResponseModel = ForceFinishResponse
        print("j,ashvd\(ForceFinishResponseModel)")
        DispatchQueue.main.async {
            
            
            if self.ForceFinishResponseModel?.data?.count == 0
            {
                self.emptyMessageLabel.isHidden = false
                self.emptyMessageLabel.text = "No data found"
                self.userTV.isHidden = true
            }
        }
        
        DispatchQueue.main.async {
            self.userTV.reloadData()
        }
    }
    
    func CrewSuccess(CrewResponse: CrewModel) {
        self.getCrewResponseModel = CrewResponse
        showAlertOnWindow(title: "", message: "Crew added to the task Successfully", titles: ["OK"], completionHanlder: {_ in})
        
        if getCrewResponseModel?.data?.count == 0
        {
            self.emptyMessageLabel.isHidden = false
            self.emptyMessageLabel.text = "No data found"
            self.userTV.isHidden = true
        }
        
        DispatchQueue.main.async {
            self.userTV.reloadData()
        }
    }
    
    
    func ReassignCrewSuccess(ReassignCrewResponse: reassignCrewModel) {
        self.ReassignCrewResponseModel = ReassignCrewResponse
        
        print("ReassignCrewResponseModel\(ReassignCrewResponseModel?.data)")
        count = 0
        ReassignCrewResponseModel?.data?.forEach({ i in
            if i.user_type == "inprogress" {
                count = count + 1
                print("ReassignCrewResponseModel_inprogress_count : \(count)")
            }
        })
        DispatchQueue.main.async {
            self.userTV.reloadData()
        }
    }
    
    
    
}


