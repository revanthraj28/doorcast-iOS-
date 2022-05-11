//
//  IncompleteTasksVC.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import UIKit

class IncompleteTasksVC: UIViewController {
    
    @IBOutlet weak var taskListTableView: UITableView!
    @IBOutlet weak var meOrTeamSegment: UISegmentedControl!
    
    var viewModel : TaskListViewModel!
    var incompleteTaskListModel : IncompleteTaskListModel?
    var timerBool = false
    let bottomView: TimerView = TimerView()
    var totalSecond = Int()
    var timer : Timer?
    var counter = 0
    var mainVC: CommonTaskDetailVC?
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didTapOnTimerView(notification:)), name: NSNotification.Name.init(rawValue: "timer"), object: nil)
        
        configureContents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI(){
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
        taskListTableView.register(TaskListTVCell.cellNib, forCellReuseIdentifier: TaskListTVCell.cellId)
    }
    
    func configureContents(){
        viewModel = TaskListViewModel(self)
        viewModel.InCompleteListApi(task_type: "incomplete", from_date: "all", to_date: "all", propertyid: "44", crew_members: "me")
        
        mainVC = self.parent as? CommonTaskDetailVC
    }
    
    
    
    @objc func didTapOnTimerView(notification:Notification) {
        print("didTapOnTimerView IncompleteTasksVC")
        
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
            print("\(hours):\(minutes):\(seconds)")
            self.mainVC?.timerView.idleTimeLabelValue.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        
    }
    
    
    @IBAction func selectionSegment(_ sender: UISegmentedControl) {
        let selectedSegment = sender.selectedSegmentIndex
        if selectedSegment == 0 {
            viewModel.InCompleteListApi(task_type: "incomplete", from_date: "all", to_date: "all", propertyid: "44", crew_members: "me")
        } else {
            viewModel.InCompleteListApi(task_type: "incomplete", from_date: "all", to_date: "all", propertyid: "44", crew_members: "team")
        }
    }
    
}


extension IncompleteTasksVC: TaskListProtocol {
    func showInCompleteTaskList(response: IncompleteTaskListModel?) {
        self.incompleteTaskListModel = response
        
        if let count = self.incompleteTaskListModel?.data?.count {
            if count <= 0 {
                TableViewHelper.EmptyMessage(message: "No Data Found", tableview: self.taskListTableView, vc: self)
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
        if let incompleteData = incompleteTaskListModel?.data?[indexPath.row] {
            cell.configureUI(modelData: incompleteData)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
