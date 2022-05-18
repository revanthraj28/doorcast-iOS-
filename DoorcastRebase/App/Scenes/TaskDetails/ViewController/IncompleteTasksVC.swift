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
    
    var tastListShowBool = true
    let bottomView: TimerView = TimerView()
    var timer : Timer?
    var counter = 0
    var mainVC: CommonTaskDetailVC?
    var crewPropertyIds = [String]()
    var roleName = String()
    var loginID = String()
    var selectedSegmentIndex = Int()
    var selectedSegmentTitle = String()
    
    static var newInstance: IncompleteTasksVC? {
        let storyboard = UIStoryboard(name: Storyboard.taskDetails.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? IncompleteTasksVC
        return vc
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.selectedSegmentIndex = meOrTeamSegment.selectedSegmentIndex
        self.selectedSegmentTitle = meOrTeamSegment.titleForSegment(at: self.selectedSegmentIndex) ?? ""
        
        observeNotifcations()
        configureContents()
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
    
    func observeNotifcations(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(didTapOnTimerView(notification:)), name: NSNotification.Name.init(rawValue: "timer"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(dayTaskAction(notification:)), name: NSNotification.Name.init(rawValue: "daytask"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(gotoOnBoardingVC(notification:)), name: NSNotification.Name.init(rawValue: "gotoOnBoardingVC"), object: nil)
        
    }
    
    
    func configureContents() {
        print("crewPropertyIds all == \(crewPropertyALLIds.joined(separator: ","))")
        
        
        callApi()
        
        mainVC = self.parent as? CommonTaskDetailVC
        self.taskListTableView.bringSubviewToFront(mainVC?.speechView ?? UIView())
        
        
        if timerBool == true {
            self.taskListTableView.isUserInteractionEnabled = true
            self.taskListTableView.alpha = 1
        }else {
            self.taskListTableView.isUserInteractionEnabled = false
            self.taskListTableView.alpha = 0.4
        }
    }
    
    @objc func gotoOnBoardingVC(notification:Notification) {
        
        if timerBool == false {
            guard let vc = OnBoardingVC.newInstance else {return}
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            
        }else {
            
            guard let vc = CommonAlertVC.newInstance else {return}
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false)
        }
        
    }
    
    
    @objc func dayTaskAction(notification:Notification) {
        
        mainVC?.speechView.isHidden = true
        if let day = notification.object as? String {
            if day == "Start day" {
                
                self.taskListTableView.isUserInteractionEnabled = true
                self.taskListTableView.alpha = 1
                mainVC?.timerView.timerButton.setImage(UIImage(named: "pauseTimer"), for: .normal)
                
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(processTimer), userInfo: nil, repeats: true)
                timerBool = true
        
            }else {
        
                mainVC?.timerView.timerButton.setImage(UIImage(named: "startTimer"), for: .normal)
                timer?.invalidate()
                timer = nil
                timerBool = false
                gotoBackScreen()
                
            }
        }
        
    }
    
    
    func gotoBackScreen() {
        guard let vc = OnBoardingVC.newInstance else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    

    @objc func didTapOnTimerView(notification:Notification) {
        mainVC?.speechView.isHidden = false
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
    
    
    func callApi() {
        
        
        if self.selectedSegmentIndex == 0 {
            
            if showproperty == "all" {
                
                
                viewModel.InCompleteListApi(task_type: "incomplete", from_date: "all", to_date: "all", propertyid: "\(crewPropertyALLIds.joined(separator: ","))", crew_members: "me")
            } else {
                
                
                viewModel.InCompleteListApi(task_type: "incomplete", from_date: "all", to_date: "all", propertyid: "\(crewPropertyIds.joined(separator: ","))", crew_members: "me")
            }
            
            defaults.set("me", forKey: UserDefaultsKeys.task_type)
            
        }else {
            
            
            if showproperty == "all" {
                
                
                viewModel.InCompleteListApi(task_type: "incomplete", from_date: "all", to_date: "all", propertyid: "\(crewPropertyALLIds.joined(separator: ","))", crew_members: "team")
            } else {
                
                
                viewModel.InCompleteListApi(task_type: "incomplete", from_date: "all", to_date: "all", propertyid: "\(crewPropertyIds.joined(separator: ","))", crew_members: "team")
            }
            
            defaults.set("team", forKey: UserDefaultsKeys.task_type)
            
        }
        
        
        
    }
    
    
    @IBAction func selectionSegment(_ sender: UISegmentedControl) {
        self.selectedSegmentIndex = sender.selectedSegmentIndex
        self.selectedSegmentTitle = sender.titleForSegment(at: self.selectedSegmentIndex) ?? ""
        
        callApi()
    }
    
}


extension IncompleteTasksVC: TaskListProtocol {
    func showInCompleteTaskList(response: IncompleteTaskListModel?) {
        self.incompleteTaskListModel = response
        
        print(self.incompleteTaskListModel)
        
        
        self.roleName = self.incompleteTaskListModel?.data?.first?.role_name ?? ""
        
        if self.incompleteTaskListModel?.data?.first?.role_name ?? "" == "CrewLead"{
            meOrTeamHeightConstraint.constant = 40
            meOrTeamSegment.isHidden = false
        } else {
            meOrTeamHeightConstraint.constant = 0
            meOrTeamSegment.isHidden = true
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
        
        if let incompleteData = incompleteTaskListModel?.data?[indexPath.row] {
            cell.configureUI(modelData: incompleteData, task: "incomplete")
        }
        
        
        
        if  self.roleName == "CrewLead" && UserDefaults.standard.string(forKey: "loginid") == incompleteTaskListModel?.data?[indexPath.row].crew_id {
            
            
            if self.selectedSegmentTitle == "Team" {
                cell.roleLabel.text = "\(self.incompleteTaskListModel?.data?[indexPath.row].role_name ?? "") •"
            }else {
                cell.roleLabel.text = self.incompleteTaskListModel?.data?[indexPath.row].role_name
            }
        }else {
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
