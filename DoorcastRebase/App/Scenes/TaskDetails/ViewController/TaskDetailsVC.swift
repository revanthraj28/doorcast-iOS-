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
    
    
    var subTaskList: TaskDataModel?
    var subTaskListViewModel : SubTaskListViewModel?
    var subtaskDetail : SubtaskDetailModel?
    var taskname:String?
    var address:String?
    var propertyname:String?
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
        
    }

    @IBAction func sidearrowButtonAction(_ sender: Any) {
//        guard let vc = IncompleteTasksVC.newInstance else {return}
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true)
    }
    
}


extension TaskDetailsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subtaskDetail?.data?.subtask?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = taskDetailsTableView.dequeueReusableCell(withIdentifier: "CheckboxInTaskDetailsTVCell", for: indexPath) as! CheckboxInTaskDetailsTVCell
        let data = subtaskDetail?.data?.subtask?[indexPath.row]
        cell.numbersLabel.text = data?.sub_task_name
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = taskDetailsTableView.dequeueReusableCell(withIdentifier: "CheckboxInTaskDetailsTVCell", for: indexPath) as! CheckboxInTaskDetailsTVCell
        if cell.selectDeselectImage.isUserInteractionEnabled == true && cell.selectDeselectImage.image == UIImage(named: "taskChecked") {

            cell.selectDeselectImage.image = UIImage(named: "taskUnCheck")

        } else if  cell.selectDeselectImage.isUserInteractionEnabled == true && cell.selectDeselectImage.image == UIImage(named: "taskUnCheck") {
            cell.selectDeselectImage.image = UIImage(named: "taskChecked")
        }

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
