//
//  IncompleteTasksVC.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import UIKit
import Network

class IncompleteTasksVC: UIViewController {
    
    @IBOutlet weak var taskListTableView: UITableView!
    @IBOutlet weak var meOrTeamSegment: UISegmentedControl!
    
    @IBOutlet weak var meOrTeamHeightConstraint: NSLayoutConstraint!
    var viewModel : TaskListViewModel!
    var incompleteTaskListModel : IncompleteTaskListModel?
    var IncompleteTaskList : IncompleteTaskListModelData?
    var timerBool = false
    var tastListShowBool = true
    let bottomView: TimerView = TimerView()
    var totalSecond = Int()
    var timer : Timer?
    var counter = 0
    var mainVC: CommonTaskDetailVC?
    var crewPropertyIds = [String]()
    var roleName = String()
    var loginID = String()
    
    static var newInstance: IncompleteTasksVC? {
        let storyboard = UIStoryboard(name: Storyboard.taskDetails.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? IncompleteTasksVC
        return vc
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let crewpropertyIds = self.crewPropertyIds
        print("crewPropertyIds == \(crewPropertyIds.joined(separator: ","))")
        
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didTapOnTimerView(notification:)), name: NSNotification.Name.init(rawValue: "timer"), object: nil)
        
        
        print("crewPropertyIds all == \(crewPropertyALLIds.joined(separator: ","))")
        
        
        if showproperty == "all" {
            
            
            viewModel.InCompleteListApi(task_type: "incomplete", from_date: "all", to_date: "all", propertyid: "\(crewPropertyALLIds.joined(separator: ","))", crew_members: "me")
        } else {
            viewModel.InCompleteListApi(task_type: "incomplete", from_date: "all", to_date: "all", propertyid: "\(crewPropertyIds.joined(separator: ","))", crew_members: "me")
        }
        
        defaults.set("me", forKey: UserDefaultsKeys.task_type)
        mainVC = self.parent as? CommonTaskDetailVC
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = TaskListViewModel(self)
        
        configureUI()
    }
    
    func configureUI(){
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
        taskListTableView.register(TaskListTVCell.cellNib, forCellReuseIdentifier: TaskListTVCell.cellId)
    }
    
    func configureContents(){
        
        //        let arr = crewPropertyIds.joined(separator: ",")
        
    }
    
    
    
    @objc func didTapOnTimerView(notification:Notification) {
        
        self.taskListTableView.isUserInteractionEnabled = true
        self.taskListTableView.alpha = 1
        
        if timerBool == false {
            mainVC?.timerView.timerButton.setImage(UIImage(named: "pauseTimer"), for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(processTimer), userInfo: nil, repeats: true)
            timerBool = true
        }else {
            mainVC?.timerView.timerButton.setImage(UIImage(named: "startTimer"), for: .normal)
            timer?.invalidate()
            timer = nil
            timerBool = false
        }
        
    }
    
    
    @objc func processTimer() {
        
        let hours = counter / 3600
        let minutes = counter / 60 % 60
        let seconds = counter % 60
        counter = counter + 1
        
        DispatchQueue.main.async {
            self.mainVC?.timerView.idleTimerValueLbl.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        
    }
    
    
    @IBAction func selectionSegment(_ sender: UISegmentedControl) {
        let selectedSegment = sender.selectedSegmentIndex
        if selectedSegment == 0 {
            
            viewModel.InCompleteListApi(task_type: "incomplete", from_date: "all", to_date: "all", propertyid: "44", crew_members: "me")
            defaults.set("me", forKey: UserDefaultsKeys.task_type)
        } else {
            
            viewModel.InCompleteListApi(task_type: "incomplete", from_date: "all", to_date: "all", propertyid: "44", crew_members: "team")
            defaults.set("team", forKey: UserDefaultsKeys.task_type)
        }
    }
    
}


extension IncompleteTasksVC: TaskListProtocol {
    func showInCompleteTaskList(response: IncompleteTaskListModel?) {
        self.incompleteTaskListModel = response
        
        print("Response  \(response)")
        if self.incompleteTaskListModel?.data?.first?.role_name ?? "" == "Crew"
        {
            meOrTeamHeightConstraint.constant = 0
            meOrTeamSegment.isHidden = true
        } else {
            meOrTeamHeightConstraint.constant = 40
            meOrTeamSegment.isHidden = false
        }
        
        if let count = self.incompleteTaskListModel?.data?.count {
            if count <= 0 {
                TableViewHelper.EmptyMessage(message: "No Tasks Assigned", tableview: self.taskListTableView, vc: self)
            }else {
                TableViewHelper.EmptyMessage(message: "", tableview: self.taskListTableView, vc: self)
            }
        }
        
        
        DispatchQueue.main.async {
            self.taskListTableView.reloadData()
        }
    }
}


extension IncompleteTasksVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incompleteTaskListModel?.data?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskListTVCell.cellId, for: indexPath) as! TaskListTVCell
        
        
        cell.selectionStyle = .none
        self.taskListTableView.isUserInteractionEnabled = false
        self.taskListTableView.alpha = 0.3
        if let incompleteData = incompleteTaskListModel?.data?[indexPath.row] {
            cell.configureUI(modelData: incompleteData)
        }
        
        if self.loginID == incompleteTaskListModel?.data?[indexPath.row].crew_id  {
            cell.roleLabel.text = self.incompleteTaskListModel?.data?[indexPath.row].role_name ?? "" + " • "
        } else {
            cell.roleLabel.text = self.incompleteTaskListModel?.data?[indexPath.row].role_name
        }
        
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = TaskDetailsVC.newInstance else {return}
        vc.modalPresentationStyle = .fullScreen
        if let incompleteData = incompleteTaskListModel?.data?[indexPath.row] {
            defaults.set(incompleteData.task_id, forKey: UserDefaultsKeys.task_id)
            defaults.set(incompleteData.task_id_cipher, forKey: UserDefaultsKeys.task_id_cipher)
            defaults.set(incompleteData.taskname, forKey: UserDefaultsKeys.taskname)
            defaults.set(incompleteData.group_id, forKey: UserDefaultsKeys.group_id)
            defaults.set(incompleteData.propertyid, forKey: UserDefaultsKeys.property_id)
            
        }
        self.present(vc, animated: true)
        
    }
    
    
    
}
