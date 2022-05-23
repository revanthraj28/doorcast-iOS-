//
//  CompletedTasksVC.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import UIKit
import Reachability

class CompletedTasksVC: UIViewController {
    
    @IBOutlet weak var taskListTableView: UITableView!
    @IBOutlet weak var meOrTeamSegment: UISegmentedControl!
    @IBOutlet weak var meOrTeamHeightConstraint: NSLayoutConstraint!
    
    var viewModel : TaskListViewModel!
    var completeTaskListModel : IncompleteTaskListModel?
    
    var tastListShowBool = true
    let bottomView: TimerView = TimerView()
    var counter = 0
    var mainVC: CommonTaskDetailVC?
    var roleName = String()
    var loginID = String()
    var selectedSegmentIndex = Int()
    var selectedSegmentTitle = String()
    var calBool = false
    var calStartDate = String()
    var calEndDate = String()
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
            changeStatusBarColor(with: .ThemeColor)
      
        
        print("crewPropertyALLIds  \(crewPropertyIds.joined(separator: ","))")
        
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        // self.view.addGestureRecognizer(tap)
        
        
    }
    
    
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.mainVC?.speechView.isHidden = true
    }
    
    func observeNotifcations(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(didTapOnTimerView(notification:)), name: NSNotification.Name.init(rawValue: "timer"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(dayTaskAction(notification:)), name: NSNotification.Name.init(rawValue: "daytask"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(gotoOnBoardingVC(notification:)), name: NSNotification.Name.init(rawValue: "gotoOnBoardingVC"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(tofromdate(notification:)), name: NSNotification.Name.init(rawValue: "tofromdate"), object: nil)
        
        
    }
    
    func configureContents(){
        
        callApi()
        mainVC = self.parent as? CommonTaskDetailVC
        self.taskListTableView.bringSubviewToFront(mainVC?.speechView ?? UIView())
        
    }
    
    func CheckInternetConnection() {
        if ServiceManager.isConnection() == true {
            print("Internet Connection Available!")
            self.callApi()
        }else{
            print("Internet Connection not Available!")
            self.showAlertOnWindow(title: "No Internet Connection!", message: "Please check your internet connection and try again", titles: ["retry"]) { (key) in
                self.CheckInternetConnection()
            }
        }
    }
    
    
    
    @objc func tofromdate(notification:Notification) {
        
        let userinfo = notification.userInfo as? [String:Any]
        calBool = userinfo?["calBool"] as? Bool ?? false
        calStartDate = userinfo?["fromDate"] as? String ?? ""
        calEndDate = userinfo?["toDate"] as? String ?? ""
        
        callApi()
        
    }
    
    
    @objc func gotoOnBoardingVC(notification:Notification) {
        CheckInternetConnection()
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
        
        CheckInternetConnection()
        print("dayTaskAction CompletedTasksVC")
        mainVC?.speechView.isHidden = true
        
        if let day = notification.object as? String {
            if day == "Start day" {
                
                self.taskListTableView.isUserInteractionEnabled = true
                self.taskListTableView.alpha = 1
                mainVC?.timerView.timerButton.setImage(UIImage(named: "pauseTimer"), for: .normal)
                
                mainVC?.runTimer()
                timerBool = true
                
                
            }else {
                
                mainVC?.timerView.timerButton.setImage(UIImage(named: "startTimer"), for: .normal)
                
                //                timer?.invalidate()
                //                timer = nil
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
        CheckInternetConnection()
        mainVC?.speechView.isHidden = false
    }
    
    
    
    
    
    func callApi() {
        
        if self.calBool == true {
            callViewModelAPI(fromDate: "\(self.calStartDate)", todate: "\(calEndDate)")
        }else {
            callViewModelAPI(fromDate: "all", todate: "all")
        }
        
    }
    
    
    
    func callViewModelAPI(fromDate:String,todate:String) {
        
        if self.selectedSegmentIndex == 0 {
            
            if showproperty == "all" {
                
                viewModel.InCompleteListApi(task_type: "complete", from_date: "\(fromDate)", to_date: "\(todate)", propertyid: "\(crewPropertyALLIds.joined(separator: ","))", crew_members: "me")
            } else {
                
                
                viewModel.InCompleteListApi(task_type: "complete", from_date: "\(fromDate)", to_date: "\(todate)", propertyid: "\(crewPropertyIds.joined(separator: ","))", crew_members: "me")
            }
            
            defaults.set("me", forKey: UserDefaultsKeys.task_type)
            
        }else {
            
            
            if showproperty == "all" {
                
                
                viewModel.InCompleteListApi(task_type: "complete", from_date: "\(fromDate)", to_date: "\(todate)", propertyid: "\(crewPropertyALLIds.joined(separator: ","))", crew_members: "team")
            } else {
                
                
                viewModel.InCompleteListApi(task_type: "complete", from_date: "\(fromDate)", to_date: "\(todate)", propertyid: "\(crewPropertyIds.joined(separator: ","))", crew_members: "team")
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





extension CompletedTasksVC: TaskListProtocol {
    
    func CrewTaskLogResponse(response: CrewTaskLogModel?) {
        print(response?.data?.idealtime)
    }
    
    func showInCompleteTaskList(response: IncompleteTaskListModel?) {
        self.completeTaskListModel = response
        
        print(self.completeTaskListModel as Any)
        
        mainVC?.completedTaskCountLabel.text = String(self.completeTaskListModel?.data?.count ?? 0)
        self.roleName = self.completeTaskListModel?.data?.first?.role_name ?? ""
        
        if self.completeTaskListModel?.data?.first?.role_name ?? "" == "CrewLead"{
            meOrTeamHeightConstraint.constant = 40
            meOrTeamSegment.isHidden = false
        } else {
            meOrTeamHeightConstraint.constant = 0
            meOrTeamSegment.isHidden = true
        }
        
        if let count = self.completeTaskListModel?.data?.count {
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







extension CompletedTasksVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completeTaskListModel?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskListTVCell.cellId, for: indexPath) as! TaskListTVCell
        cell.selectionStyle = .none
        
        if let incompleteData = completeTaskListModel?.data?[indexPath.row] {
            cell.configureUI(modelData: incompleteData, task: "complete")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
