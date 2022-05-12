//
//  TaskDetailsVC.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 09/05/22.
//

import UIKit

class TaskDetailsVC: UIViewController {
    
    @IBOutlet weak var taskDetailsTableView: UITableView!
    @IBOutlet weak var commonNavBar: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var propertyAddresLabel: UILabel!
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var moreImage: UIImageView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var sidearrowView: UIView!
    @IBOutlet weak var sidearrowImage: UIImageView!
    @IBOutlet weak var sidearrowButton: UIButton!
    
    @IBOutlet weak var ForceFinishBtn: UIButton!
    @IBOutlet weak var ForceFinishLabel: UILabel!
    @IBOutlet weak var ForceFinishImage: UIImageView!
    @IBOutlet weak var ForceFinishBgView: UIView!
    @IBOutlet weak var AddCrewBtn: UIButton!
    @IBOutlet weak var AddCrewLabel: UILabel!
    @IBOutlet weak var AddCrewImage: UIImageView!
    @IBOutlet weak var ReassignLabel: UILabel!
    @IBOutlet weak var ReassignImage: UIImageView!
    @IBOutlet weak var reasignBgView: UIView!
    @IBOutlet weak var editBackgroundView: UIView!
    
    @IBOutlet weak var addcrewBgView: UIView!
    @IBOutlet weak var ReassignBtn: UIButton!
    
    
    var subTaskList: TaskDataModel?
    var subTaskListViewModel : SubTaskListViewModel?
    var subtaskDetail : SubtaskDetailModel?
    var taskname:String?
    var address:String?
    var propertyname:String?
    
    var isVisible = false
    
    static var newInstance: TaskDetailsVC? {
        let storyboard = UIStoryboard(name: Storyboard.taskDetails.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? TaskDetailsVC
        return vc
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        taskName.text =  self.taskname
        companyLabel.text = self.propertyname
        propertyAddresLabel.text = self.address
        
        editBackgroundView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subTaskListViewModel = SubTaskListViewModel(self)
        setupui()
        
    }
    
    func setupui(){
        dateLabel.text =  Date().MonthDateDayFormatter?.uppercased()
        distanceLabel.text = "1111"
        
        moreView.layer.cornerRadius = 18
        sidearrowView.layer.cornerRadius = 18
        
        
        taskDetailsTableView.delegate = self
        taskDetailsTableView.dataSource = self
        
        taskDetailsTableView.register(CheckboxInTaskDetailsTVCell.self, forCellReuseIdentifier: "CheckboxInTaskDetailsTVCell")
        taskDetailsTableView.register(UINib(nibName: "CheckboxInTaskDetailsTVCell", bundle: nil), forCellReuseIdentifier: "CheckboxInTaskDetailsTVCell")
        
        
        let taskId = defaults.string(forKey: UserDefaultsKeys.task_id)
        let task_id_check = defaults.string(forKey: UserDefaultsKeys.task_id_cipher)
        let group_id = defaults.string(forKey: UserDefaultsKeys.group_id)
        let task_type = defaults.string(forKey: UserDefaultsKeys.task_type)
        let property_id = defaults.string(forKey: UserDefaultsKeys.property_id)
        print("taskId = \(taskId), task_id_check = \(task_id_check), group_id = \(group_id), task_type = \(task_type)")
        //        let taskId = defaults.string(forKey: UserDefaultsKeys.task_id)
        subTaskListViewModel?.SubTaskListApi(task_id: taskId ?? "", task_id_check: task_id_check ?? "" , group_id: group_id ?? "" , type: task_type ?? "" )
        
        
    }
    
    
    @IBAction func menuButtonAction(_ sender: Any) {
    }
    
    
    @IBAction func moreButtonAction(_ sender: Any) {
        
        
        if isVisible == false
        {
            editBackgroundView.isHidden = false
            isVisible = true
        }else{
            
            editBackgroundView.isHidden = true
            isVisible = false
        }
        
        
    }
    
    
    @IBAction func reassignBtnAction(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "TaskDetails", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SelectUserVC") as! SelectUserVC
        vc.isSelected = "Reassign Crew"
        vc.modalPresentationStyle = .popover
        self.present(vc, animated:true, completion:nil)
        
        
    }
    
    
    
    @IBAction func addCrewBtnAction(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "TaskDetails", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SelectUserVC") as! SelectUserVC
        vc.isSelected = "Add Crew"
        vc.modalPresentationStyle = .popover
        self.present(vc, animated:true, completion:nil)
        
        
        
    }
    
    @IBAction func forceFinishBtnAction(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "TaskDetails", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SelectUserVC") as! SelectUserVC
        vc.isSelected = "Force Finish"
        vc.modalPresentationStyle = .popover
        self.present(vc, animated:true, completion:nil)
        
    }
    
    
    @IBAction func sidearrowButtonAction(_ sender: Any) {
        
    }
    
}


extension TaskDetailsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subtaskDetail?.data?.subtask?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var commonCell = UITableViewCell()
        if let cell = taskDetailsTableView.dequeueReusableCell(withIdentifier: "CheckboxInTaskDetailsTVCell", for: indexPath) as? CheckboxInTaskDetailsTVCell {
            
            let data = subtaskDetail?.data?.subtask?[indexPath.row]
            cell.numbersLabel.text = data?.sub_task_name
            
            commonCell = cell
        }
        return commonCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = taskDetailsTableView.dequeueReusableCell(withIdentifier: "CheckboxInTaskDetailsTVCell", for: indexPath) as? CheckboxInTaskDetailsTVCell {
            
            if cell.selectDeselectImage.isUserInteractionEnabled == true && cell.selectDeselectImage.image == UIImage(named: "taskChecked") {
                cell.selectDeselectImage.image = UIImage(named: "taskUnCheck")
            } else if  cell.selectDeselectImage.isUserInteractionEnabled == true && cell.selectDeselectImage.image == UIImage(named: "taskUnCheck") {
                cell.selectDeselectImage.image = UIImage(named: "taskChecked")
            }
            gotoNextScreen()
        }
    }
    
    
    func gotoNextScreen() {
        guard let vc = StartTheClockVC.newInstance else {return}
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
}




extension TaskDetailsVC : SubTaskListProtocol {
    func subTaskList(response: SubtaskDetailModel?) {
        
        self.subtaskDetail = response
        DispatchQueue.main.async {
            self.taskDetailsTableView.reloadData()
        }
    }
    
    
}
