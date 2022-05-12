//
//  SelectUserVC.swift
//  ExStream
//
//  Created by Vijay Kumar on 25/11/20.
//  Copyright © 2020 Codebele-01. All rights reserved.
//

import UIKit
//import SVProgressHUD

class SelectUserVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
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
            userTV.allowsMultipleSelection = false
            userTV.reloadData()
            
            
            var parms = [String: Any]()
            
            parms["task_id"] = defaults.string(forKey: UserDefaultsKeys.task_id)
            parms["property_id"] = defaults.string(forKey: UserDefaultsKeys.property_id)
            parms["type"] = defaults.string(forKey: UserDefaultsKeys.task_type)
            
            self.vmodel?.ReassignCrewApi(dictParam: parms)
            
            
            
        }  else if  isSelected == "Add Crew"{
            
            cancelView.isHidden = false
            addUserView.alpha = 1.0
            addUserBtn.isUserInteractionEnabled = true
            addUserView.addCornerRadiusWithShadow(color: .lightGray, borderColor: .clear, cornerRadius: addUserView.layer.frame.size.width / 2)
            //            addUserImage.image = UIImage(named: "cancel")
            userTV.allowsMultipleSelection = false
            
            
            var parms = [String: Any]()
            
            parms["task_id"] = defaults.string(forKey: UserDefaultsKeys.task_id)
            parms["property_id"] = defaults.string(forKey: UserDefaultsKeys.property_id)
            
            
            self.ViewModel?.CrewApi(dictParam: parms)
            
        } else if isSelected == "Force Finish"{
            cancelView.isHidden = false
            addUserView.alpha = 1.0
            addUserBtn.isUserInteractionEnabled = true
            addUserView.addCornerRadiusWithShadow(color: .lightGray, borderColor: .clear, cornerRadius: addUserView.layer.frame.size.width / 2)
            
            userTV.allowsMultipleSelection = false
            
            
            var parms = [String: Any]()
            
            parms["task_id"] = defaults.string(forKey: UserDefaultsKeys.task_id)
            parms["property_id"] = defaults.string(forKey: UserDefaultsKeys.property_id)
            parms["type"] = defaults.string(forKey: UserDefaultsKeys.task_type)
            
            self.ViewModel1?.ForceFinishApi(dictParam: parms)
            
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
        
        emptyMessageLabel.isHidden = true
        updateUI()
        
        print("isSelected.....\(isSelected)")
        
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
        }else if isSelected == "Add Crew" {
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



extension SelectUserVC: ReassignCrewModelProtocol , CrewViewModelProtocol , ForceFinishViewModelProtocol
{
    func ForceFinishSuccess(ForceFinishResponse: ForceFinishModel) {
        self.ForceFinishResponseModel = ForceFinishResponse
        print("ForceFinishResponseModel----\(ForceFinishResponseModel?.data?.first?.crew_name)")
        userTV.reloadData()
    }
    
    func CrewSuccess(CrewResponse: CrewModel) {
        
        
        self.getCrewResponseModel = CrewResponse
        print("response....... \(getCrewResponseModel?.data?.first?.propertyUser_name )")
        userTV.reloadData()
        
        
    }
    
    
    func ReassignCrewSuccess(ReassignCrewResponse: reassignCrewModel) {
        self.ReassignCrewResponseModel = ReassignCrewResponse
        print("ReassignCrewResponseModel.....\(ReassignCrewResponseModel?.data?.first?.crew_name )")
        
        
        
        userTV.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isSelected == "Force Finish" {
            print("ForceFinish.....")
            
            let cell = userTV.cellForRow(at: indexPath) as! LabelTVCell
            cell.holderView.backgroundColor = UIColor(named: "inactiveStateColor")?.withAlphaComponent(0.5)
            
        }
        
    }
    
}
