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
    
    @IBOutlet weak var timerView: TimerView!
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
    var withInLocationBool = false
    var isVisible = false
    var mainVC: CommonTaskDetailVC?
    var viewModel : TaskListViewModel?
    var viewModel1 : TaskDetailsViewModel?
    var day = String()
    var task_id_check = String()
    
    static var newInstance: TaskDetailsVC? {
        let storyboard = UIStoryboard(name: Storyboard.taskDetails.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? TaskDetailsVC
        return vc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
     
        DispatchQueue.main.async {
            print("=======")
            print(defaults.string(forKey: UserDefaultsKeys.task_id_cipher ))
                  print(defaults.string(forKey: UserDefaultsKeys.task_id ))
            
            self.viewModel1?.callExstreamTaskLocationAPI(taskidcheck: defaults.string(forKey: UserDefaultsKeys.task_id_cipher) ?? "", taskid: defaults.string(forKey: UserDefaultsKeys.task_id) ?? "")
            
        }
        
        
        if timerBool == true {
            self.timerView.bringSubviewToFront(self.timerView.speechView)
            self.timerView.playPauseImage.image = UIImage(named: "Stop")?.withRenderingMode(.alwaysOriginal).withTintColor(.red)
            self.timerView.startDaylbl.text = "Stop day"
            dayTaskAction()
        }
        
        
        // self.parentvc = self.parent as? CommonTaskDetailVC ?? UIViewController()
        
        // updateLocation
        NotificationCenter.default.addObserver(self, selector: #selector(setDistanceFromCurrentLocation(notification:)), name: NSNotification.Name.init(rawValue: "updateLocation"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didTapOnTimerView(notification:)), name: NSNotification.Name.init(rawValue: "timer"), object: nil)
        
       // NotificationCenter.default.addObserver(self, selector: #selector(dayTaskAction(notification:)), name: NSNotification.Name.init(rawValue: "daytask"), object: nil)
        
        setupui()
        taskName.text = defaults.string(forKey: UserDefaultsKeys.taskname)
        companyLabel.text = defaults.string(forKey: UserDefaultsKeys.propertyname)
        propertyAddresLabel.text = defaults.string(forKey: UserDefaultsKeys.address)
        editBackgroundView.isHidden = true
        

    }
    
    
    @objc func didTapOnTimerView(notification:Notification) {
        print("didTapOnTimerView")
        self.timerView.speechView.isHidden = false
    }
    
    
     func dayTaskAction() {
        
        print("dayTaskAction ==== TaskDetailsVC \(KLat)")
        
        mainVC?.speechView.isHidden = true
       
            
         if self.day == "Start day" {
                
                defaults.set("start", forKey: "daytype")
               // self.viewModel.startOrStopDayTask()
                self.timerView.playPauseImage.image = UIImage(named: "Stop")?.withRenderingMode(.alwaysOriginal).withTintColor(.red)
                
                mainVC?.runTimer()
                timerBool = true
                
            }else {
                
                defaults.set("stop", forKey: "daytype")
                self.timerView.playPauseImage.image = UIImage(named: "startTimer")?.withRenderingMode(.alwaysOriginal).withTintColor(.red)
                timerBool = false
                gotoBackScreen()
                
            }
        
        
    }
    
    
    func gotoBackScreen() {
        NotificationCenter.default.removeObserver(self)
        guard let vc = OnBoardingVC.newInstance else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    
    @objc func setDistanceFromCurrentLocation(notification:Notification) {
        
        let DestinationLocation = CLLocation(latitude: latdistance, longitude: longdistance)
        let currentLocation = CLLocation(latitude: Double(KLat) ?? 0.0, longitude: Double(KLong) ?? 0.0)
        let distance = DestinationLocation.distance(from: currentLocation)
        
        print(String(format: "The distance to my buddy is %.01fm", distance))
        distanceLabel.text = "\(Int(distance))"
        
        if distance < 500 {
            print("less then 500")
            withInLocationBool = true
        }else {
            withInLocationBool = false
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subTaskListViewModel = SubTaskListViewModel(self)
        viewModel1 = TaskDetailsViewModel(view: self)

    }
    
    
    func setupui(){
        dateLabel.text =  Date().MonthDateDayFormatter?.uppercased()
        
        moreView.layer.cornerRadius = 18
        sidearrowView.layer.cornerRadius = 18
        
        tickMarkView.layer.cornerRadius = 25
        playpauseView.layer.cornerRadius = 25
        
        taskDetailsTableView.delegate = self
        taskDetailsTableView.dataSource = self
        
        
        
        //        taskDetailsTableView.register(CheckboxInTaskDetailsTVCell.self, forCellReuseIdentifier: "CheckboxInTaskDetailsTVCell")
        taskDetailsTableView.register(UINib(nibName: "CheckboxInTaskDetailsTVCell", bundle: nil), forCellReuseIdentifier: "CheckboxInTaskDetailsTVCell")
        
        
        let taskId = defaults.string(forKey: UserDefaultsKeys.task_id)
        let task_id_check = defaults.string(forKey: UserDefaultsKeys.task_id_cipher)
        let group_id = defaults.string(forKey: UserDefaultsKeys.group_id)
        let task_type = defaults.string(forKey: UserDefaultsKeys.task_type)
        let property_id = defaults.string(forKey: UserDefaultsKeys.property_id)
//        let image_captured = defaults.string(forKey: UserDefaultsKeys.image_captured)
        subTaskListViewModel?.SubTaskListApi(task_id: taskId ?? "", task_id_check: task_id_check ?? "" , group_id: group_id ?? "" , type: task_type ?? "" )
        
        
    }
    
    
    @IBAction func menuButtonAction(_ sender: Any) {
        guard let vc = NotificationCenterVC.newInstance else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
    
    
    
    @IBAction func playPauseButtonAction(_ sender: Any) {
    }
    
    
    @IBAction func tickButtonAction(_ sender: Any) {
    }
    
    
}


extension TaskDetailsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subtaskDetail?.data?.subtask?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var commonCell = UITableViewCell()
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CheckboxInTaskDetailsTVCell", for: indexPath) as? CheckboxInTaskDetailsTVCell {
            
            let data = subtaskDetail?.data?.subtask?[indexPath.row]
            cell.numbersLabel?.text = data?.sub_task_name
            commonCell = cell
        }
        return commonCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(withInLocationBool)
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CheckboxInTaskDetailsTVCell") as? CheckboxInTaskDetailsTVCell {
            if withInLocationBool == true {
                
                if cell.selectDeselectImage.isUserInteractionEnabled == true && cell.selectDeselectImage.image == UIImage(named: "taskChecked") {
                    cell.selectDeselectImage.image = UIImage(named: "taskUnCheck")
                } else if  cell.selectDeselectImage.isUserInteractionEnabled == true && cell.selectDeselectImage.image == UIImage(named: "taskUnCheck") {
                    cell.selectDeselectImage.image = UIImage(named: "taskChecked")
                }
                gotoNextScreen()
                
            }else {
                
                self.showAlertOnWindow(title: "", message: "Idle time has begun. You have been away from the unit for 5 minutes", titles: ["OK"], completionHanlder: nil)
            }
            
        }
    }
    
    
    func gotoNextScreen() {
        guard let vc = StartTheClockVC.newInstance else {return}
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
}

extension TaskDetailsVC : SubTaskListProtocol,TaskDetailsViewModelDelegate{
    func exstreamTaskLocationResponse(response: ExstreamTaskLocationModel?) {
        print("exstreamTaskLocationResponse = \(response)")
    }

    
    
    
    func subTaskList(response: SubtaskDetailModel?) {
        
        self.subtaskDetail = response
      //  print("subtaskDetailresponse = \(response)")
        latdistance = Double(subtaskDetail?.latitude ?? "") ?? 0.0
        longdistance = Double(subtaskDetail?.longitude ?? "") ?? 0.0
        DispatchQueue.main.async {
            self.taskDetailsTableView.reloadData()
        }
    }
    
    
}





// on view will appear
//URL: ```https://staging.doorcast.tech/api/exstream_TaskLocation```
//
//Method: POST
//
//Authentication Headers:
//```
//  Content-Type: application\/json,
//  Accesstoken: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.Ijc0OSI.0SuocLrTA4szVKXCbZEMuaCYhqPSwToxOynGmWB82EU
//```
//
//Payload: ```{
//  "task_id_check" : "3304",
//  "task_id" : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.IjMzMDQi.76pOxjkRBi9kofiZzt-JvWqej1fPdYDo4BpLK9XJqXg"
//}```
//
//Response: ```{
//    data =     (
//    );
//    message = "Details are here";
//    status = 1;
//    time =     {
//        "day_status" = 1;
//        "ideal_time" = "00:00:05";
//        "individual_working_time" = "00:00:29";
//        "task_status" = NULL;
//        "working_time" = "00:00:00";
//    };
//}```




//start or stop on play button tap

//URL: ```https://staging.doorcast.tech/api/exstream_crewTaskLog```
//
//Method: POST
//
//Authentication Headers:
//```
//  Content-Type: application\/json,
//  Accesstoken: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.Ijc0OSI.0SuocLrTA4szVKXCbZEMuaCYhqPSwToxOynGmWB82EU
//```
//
//Payload: ```{
//  "distance" : "",
//  "task_id" : "3304",
//  "longitude" : "76.922889",
//  "device" : "iPhone SE (2nd generation)",
//  "type" : "start",
//  "os_type" : "15.4.1",
//  "latitude" : "15.151513",
//  "device_id" : "D462D210-77BB-44A7-A79C-B2B924A56F8D"
//}```
//
//Response: ```{
//    data =     {
//        "ideal_time" = "00:01:12";
//        "individual_taskworking_time" = "00:00:29";
//        "working_time" = "00:00:00";
//    };
//    message = "Total ideal time for Task";
//    status = 1;
//}```
//
//____________



//check or uncheck box tap

//URL: ```https://staging.doorcast.tech/api/exstream_updateTaskStatus```
//
//Method: POST
//
//Authentication Headers:
//```
//  Accesstoken: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.Ijc0OSI.0SuocLrTA4szVKXCbZEMuaCYhqPSwToxOynGmWB82EU,
//  Content-Type: application\/json
//```
//
//Payload: ```{
//  "subtask_id" : "12624",
//  "crew_role" : "CrewLead",
//  "taskStatus" : "incomplete",
//  "task_id" : ""
//}```
//
//Response: ```{
//    data = "<null>";
//    message = "Updated successfully";
//    status = 1;
//}```



// after write check button tap

//URL: ```https://staging.doorcast.tech/api/exstream_updateTaskStatus```
//
//Method: POST
//
//Authentication Headers:
//```
//  Content-Type: application\/json,
//  Accesstoken: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.Ijc0OSI.0SuocLrTA4szVKXCbZEMuaCYhqPSwToxOynGmWB82EU
//```
//
//Payload: ```{
//  "crew_role" : "CrewLead",
//  "taskStatus" : "complete",
//  "task_id" : "3304",
//  "subtask_id" : ""
//}```
//
//Response: ```{
//    data = "<null>";
//    message = "Updated successfully";
//    status = 1;
//}```
//
//_____________________________
//
//
//
//200
//JsonResult ={
//    data = "<null>";
//    message = "Please start the session";
//    status = 1;
//}
//My res taskvc2 = Optional("Please start the session")
//
//
//_____________________________
//
//Date: 23 May 2022 12:48:10.806 PM
//
//URL: ```https://staging.doorcast.tech/api/exstream_crewTaskLog```
//
//Method: POST
//
//Authentication Headers:
//```
//  Accesstoken: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.Ijc0OSI.0SuocLrTA4szVKXCbZEMuaCYhqPSwToxOynGmWB82EU,
//  Content-Type: application\/json
//```
//
//Payload: ```{
//  "distance" : "",
//  "type" : "pause",
//  "latitude" : "15.151517",
//  "longitude" : "76.922867",
//  "device" : "iPhone SE (2nd generation)",
//  "device_id" : "D462D210-77BB-44A7-A79C-B2B924A56F8D",
//  "os_type" : "15.4.1",
//  "task_id" : "3304"
//}```
//
//Response: ```{
//    data = "<null>";
//    message = "Please start the session";
//    status = 1;
//}```




//image button tap

//URL: ```https://staging.doorcast.tech/api/exstream_property_location```
//
//Method: POST
//
//Authentication Headers:
//```
//  Content-Type: application\/json,
//  Accesstoken: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.Ijc0OSI.0SuocLrTA4szVKXCbZEMuaCYhqPSwToxOynGmWB82EU
//```
//
//Payload: ```{
//  "task_id" : "3335",
//  "longitude" : "76.922867",
//  "task_pic" : "iVBORw0KGgoAAAANSUhEUgAAAu4AAALuCAIAAAB+fwSdAAAAAXNSR0IArs4c6QAAAERlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAC7qADAAQAAAABAAAC7gAA
//SLYAUN4LW\/dQyqlFm723E9m8oi4jwnUWvypqkFKLEPj6f3xVmFmfMU59\/stCMKFgghc8jfWdRkobja7VLjph\/9rbe3\/AfFTVM2cMENYAAAAAElFTkSuQmCC",
//"latitude" : "15.151517"
//}```
//
//Response: ```{
//  data =     (
//  );
//  message = success;
//  status = 1;
//}```
