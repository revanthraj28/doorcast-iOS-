//
//  TaskDetailsVC.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 09/05/22.
//

import UIKit
import CoreLocation

class TaskDetailsVC: UIViewController,CLLocationManagerDelegate {
    
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
    
    @IBOutlet weak var TimerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var tickMarkView: UIView!
    @IBOutlet weak var tickImage: UIImageView!
    @IBOutlet weak var tickButton: UIButton!
    @IBOutlet weak var playpauseView: UIView!
    @IBOutlet weak var playpauseButton: UIButton!
    
    
    var subTaskList: TaskDataModel?
    var subTaskListViewModel : SubTaskListViewModel?
    var subtaskDetail : SubtaskDetailModel?
    var taskname:String?
    var address:String?
    var propertyname:String?
    
    let locationManager = CLLocationManager()
    var locationOne = CLLocation()
    let locationTwo = CLLocation()
    var latdistance = Double()
    var longdistance = Double()
    var coordinates = [CLLocationCoordinate2D]()
    
    var isVisible = false
    
    static var newInstance: TaskDetailsVC? {
        let storyboard = UIStoryboard(name: Storyboard.taskDetails.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? TaskDetailsVC
        return vc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.setupLoactionMgr()
        setupui()
        taskName.text = defaults.string(forKey: UserDefaultsKeys.taskname)
        companyLabel.text = defaults.string(forKey: UserDefaultsKeys.propertyname)
        propertyAddresLabel.text = defaults.string(forKey: UserDefaultsKeys.address)
        
        editBackgroundView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subTaskListViewModel = SubTaskListViewModel(self)
        
       
        
    }
    
    func setupLoactionMgr() {
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
        case .authorizedAlways:
            return
        case .authorizedWhenInUse:
            return
        case .denied:
            return
        case .restricted :
            locationManager.requestWhenInUseAuthorization()
        case .notDetermined :
            locationManager.requestWhenInUseAuthorization()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        var currentLocation = CLLocation(latitude:  locationManager.location?.coordinate.latitude ?? 0, longitude: locationManager.location?.coordinate.longitude ?? 0)
        
        var DestinationLocation = CLLocation(latitude: latdistance, longitude: longdistance)
        var distance = currentLocation.distance(from: DestinationLocation)
        
        print(String(format: "The distance to my buddy is %.01fm", distance))
        distanceLabel.text = "\(distance) ".maxLength(length: 3)
        
        if distance < 500 {
            print("less then 500")
        }
        
        print("displayed location\(distanceLabel)")
    }
    
    func setupui(){
        dateLabel.text =  Date().MonthDateDayFormatter?.uppercased()
        distanceLabel.text = "1111"
        
        moreView.layer.cornerRadius = 18
        sidearrowView.layer.cornerRadius = 18
        
        
        tickMarkView.layer.cornerRadius = 25
        playpauseView.layer.cornerRadius = 25
        
        
        taskDetailsTableView.delegate = self
        taskDetailsTableView.dataSource = self
        
        taskDetailsTableView.register(CheckboxInTaskDetailsTVCell.self, forCellReuseIdentifier: "CheckboxInTaskDetailsTVCell")
        taskDetailsTableView.register(UINib(nibName: "CheckboxInTaskDetailsTVCell", bundle: nil), forCellReuseIdentifier: "CheckboxInTaskDetailsTVCell")
        
        
        let taskId = defaults.string(forKey: UserDefaultsKeys.task_id)
        let task_id_check = defaults.string(forKey: UserDefaultsKeys.task_id_cipher)
        let group_id = defaults.string(forKey: UserDefaultsKeys.group_id)
        let task_type = defaults.string(forKey: UserDefaultsKeys.task_type)
        let property_id = defaults.string(forKey: UserDefaultsKeys.property_id)
        subTaskListViewModel?.SubTaskListApi(task_id: taskId ?? "", task_id_check: task_id_check ?? "" , group_id: group_id ?? "" , type: task_type ?? "" )
        
        
    }
    
    
    @IBAction func menuButtonAction(_ sender: Any) {
        
    }
    
    
    @IBAction func moreButtonAction(_ sender: Any) {
        
        
        if isVisible == false {
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
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    @IBAction func addCrewBtnAction(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "TaskDetails", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SelectUserVC") as! SelectUserVC
        vc.isSelected = "Add Crew"
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func forceFinishBtnAction(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "TaskDetails", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SelectUserVC") as! SelectUserVC
        vc.isSelected = "Force Finish"
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func sidearrowButtonAction(_ sender: Any) {
        dismissDetail()
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
        self.present(vc, animated: true, completion: nil)
    }
}

extension TaskDetailsVC : SubTaskListProtocol {
    func subTaskList(response: SubtaskDetailModel?) {
        
        self.subtaskDetail = response
        print("subtaskDetailresponse = \(response)")
        latdistance = Double(subtaskDetail?.latitude ?? "") ?? 0.0
        longdistance = Double(subtaskDetail?.longitude ?? "") ?? 0.0
        DispatchQueue.main.async {
            self.taskDetailsTableView.reloadData()
        }
    }

}
