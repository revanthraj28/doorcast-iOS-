//
//  CompletedTasksVC.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import UIKit

class CompletedTasksVC: UIViewController,TimerViewDelegate {
   

    @IBOutlet weak var taskListTableView: UITableView!
    var viewModel : TaskListViewModel!
    var incompleteTaskListModel : IncompleteTaskListModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        viewModel.InCompleteListApi(task_type: "complete", from_date: "all", to_date: "all", propertyid: "44", crew_members: "me")
    }
    
    
    
    
    func didTapOnTimerView(view: TimerView) {
        print("didTapOnTimerView")
    }
    
    
    @IBAction func selectionSegment(_ sender: UISegmentedControl) {
         let selectedSegment = sender.selectedSegmentIndex
            if selectedSegment == 0 {
                viewModel.InCompleteListApi(task_type: "complete", from_date: "all", to_date: "all", propertyid: "44", crew_members: "me")
            } else {
                viewModel.InCompleteListApi(task_type: "complete", from_date: "all", to_date: "all", propertyid: "44", crew_members: "team")
            }
    }
}
extension CompletedTasksVC: TaskListProtocol {
    func showInCompleteTaskList(response: IncompleteTaskListModel?) {
        self.incompleteTaskListModel = response
        DispatchQueue.main.async {
            self.taskListTableView.reloadData()
        }
    }
}
extension CompletedTasksVC: UITableViewDelegate, UITableViewDataSource {
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
