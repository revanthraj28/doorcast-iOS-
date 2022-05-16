//
//  NotificationCenterVC.swift
//  DoorcastRebase
//
//  Created by Codebele 06 on 09/05/22.
//

import UIKit

class NotificationCenterVC: UIViewController {
    
    static var newInstance: NotificationCenterVC? {
        let storyboard = UIStoryboard(name: Storyboard.notificationcenter.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? NotificationCenterVC
        return vc
    }
    
    @IBOutlet weak var noticationCenterLbl: UILabel!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var CancelImage: UIImageView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var CancelView: UIView!
    @IBOutlet weak var taskTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.register(UINib(nibName: "TaskAssignedTVCell", bundle: nil), forCellReuseIdentifier: "TaskAssignedTVCell")
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.backgroundColor = .black
       
    }
    

    @IBAction func closeButtonAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func profileButtonAction(_ sender: Any) {
    
        guard let vc = ProfileVC.newInstance else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
}


extension NotificationCenterVC: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskAssignedTVCell") as! TaskAssignedTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            cell.subtitleLabel.text = "<Crew Lead> has assigned you a new task at <property> unit <task_unit>"
            
            return cell
       }
}
