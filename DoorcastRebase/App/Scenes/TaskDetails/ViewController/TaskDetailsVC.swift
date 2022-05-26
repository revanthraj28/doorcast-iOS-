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
    
    @IBOutlet weak var topTimerViewHeightConstraint: NSLayoutConstraint!
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
    
    @IBOutlet weak var topTimerView: UIView!
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
    var imageBase64 = String()
    
    var dayStartedFlag = false
    var locationDistance = CLLocationDistance()
    var isAssigned = Bool()
    var showAlertOnce = Bool()
    var hidePopup = Bool()
    var showInAlert = Bool()
    var clockStartedFlag = false
    var subTaskListArray = [Subtask]()
    var subTaskID = String()
    var subTaskStatus = String()
    var completedSubtasksCount:Int = 0
    var captured = String()
    
    let locationManager = CLLocationManager()
    var locationOne = CLLocation()
    let locationTwo = CLLocation()
    var latdistance = Double()
    var longdistance = Double()
    var coordinates = [CLLocationCoordinate2D]()
    var withInLocationBool = false
    var isVisible = false
    var selectedRow = IndexPath()
    
    var parms = [String: Any]()
    
    var mainVC: CommonTaskDetailVC?
    var viewModel : TaskListViewModel?
    var viewModel1 : TaskDetailsViewModel?
    
    var UpdateTaskStatusViewModel1 : UpdateTaskStatusViewModel?
    var UpdateTaskStatusIncompleteResponse : UpdateTaskStatusModel?
    
    var UpdateTaskStatusCompleteViewModel1 : UpdateTaskStatusCompleteViewModel?
    var UpdateTaskStatusCompleteResponse1 : UpdateTaskStatusCompleteModel?
    
    var ExstreamTaskLocationViewModel1 : ExstreamTaskLocationViewModel?
    var ExstreamTaskLocationReasponse : ExstreamTaskLocationModel?
    
    var timer : Timer?
    var seconds = 0
    var ExstreamTaskpropertyLocation : CrewTaskPropertyLocationModel?
    var ExstreamTaskpropertyLocationResponse : crewpropertyLocationModel?
    
    var day = String()
    var task_id_check = String()
    
    static var newInstance: TaskDetailsVC? {
        let storyboard = UIStoryboard(name: Storyboard.taskDetails.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? TaskDetailsVC
        return vc
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    
        print(defaults.string(forKey: UserDefaultsKeys.task_id_cipher))
        print(defaults.string(forKey: UserDefaultsKeys.task_id))
        
        ExstreamTaskLocationApiCall()
        
        
        if timerBool == true {
            self.timerView.bringSubviewToFront(self.timerView.speechView)
            self.timerView.playPauseImage.image = UIImage(named: "Stop")?.withRenderingMode(.alwaysOriginal).withTintColor(.red)
            self.timerView.startDaylbl.text = "Stop day"
            dayTaskAction()
        }
        
        
        // updateLocation
        NotificationCenter.default.addObserver(self, selector: #selector(setDistanceFromCurrentLocation(notification:)), name: NSNotification.Name.init(rawValue: "updateLocation"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didTapOnTimerView(notification:)), name: NSNotification.Name.init(rawValue: "timer"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hidetimerView), name: NSNotification.Name("hidetimerView"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(takePhoto), name: NSNotification.Name.init(rawValue: "takePhoto"), object: nil)
        
         
        
        setupui()
        taskName.text = defaults.string(forKey: UserDefaultsKeys.taskname)
        companyLabel.text = defaults.string(forKey: UserDefaultsKeys.propertyname)
        propertyAddresLabel.text = defaults.string(forKey: UserDefaultsKeys.address)
        editBackgroundView.isHidden = true
        
        
    }
    
  
    @objc func takePhoto(notification : NSNotification) {
        print("taken a photo")
       
        self.imageBase64 = notification.object as? String ?? ""
        ExstreamTaskPropertyLocationApiCall()
        print("imageeebase64 = \(self.imageBase64)")
//        ExstreamTaskpropertyLocation?.CrewTaskPropertyLocationApi(dictParam: parms)
        

      
        
    }
   
    
    @objc func hidetimerView(notification: Notification) {
        print("hideeeeeeeeeeee")
        
        self.topTimerView.backgroundColor = .white
        self.playpauseView.isHidden = true
        self.timerView.isHidden = true
        self.timerLabel.isHidden = true
        self.tickMarkView.isHidden = true
        self.timerView.isHidden = false
        
    }
    
    @objc func didTapOnTimerView(notification:Notification) {
        print("didTapOnTimerView")
        // self.timerView.speechView.isHidden = false
        // self.mainVC?.speechView.isHidden = false
        
        guard let dialog = DayTaskPopviewVC.newInstance else {return}
        dialog.modalPresentationStyle = .popover
        dialog.preferredContentSize = CGSize(width: 100, height: 50)
        dialog.popoverPresentationController?.delegate = self
        dialog.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        dialog.popoverPresentationController?.sourceView = self.timerView.timerButton
        dialog.popoverPresentationController?.sourceRect = self.timerView.timerButton.frame
        self.present(dialog, animated: true, completion: nil)
    }
    
    
    func dayTaskAction() {
        
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
        UpdateTaskStatusViewModel1 = UpdateTaskStatusViewModel(self)
        ExstreamTaskLocationViewModel1 = ExstreamTaskLocationViewModel(self)
        ExstreamTaskpropertyLocation = CrewTaskPropertyLocationModel(self)
        
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
    
    func UpdateTaskStatusinCompleteApiCall(){
        
        parms["task_id"] = ""
        parms["subtask_id"] = defaults.string(forKey: UserDefaultsKeys.sub_task_id)
        parms["taskStatus"] = defaults.string(forKey: UserDefaultsKeys.completetasktype)
        parms["crew_role"] = defaults.value(forKey:UserDefaultsKeys.role_name)
        
        print(defaults.string(forKey: UserDefaultsKeys.sub_task_id))
        print(defaults.string(forKey: UserDefaultsKeys.completetasktype))
        print(defaults.value(forKey:UserDefaultsKeys.role_name))
        
        
        self.UpdateTaskStatusViewModel1?.UpdateTaskStatus(dictParam: parms)
        
    }
    
    
    
    func ExstreamTaskLocationApiCall(){
        parms["task_id"] = defaults.string(forKey: UserDefaultsKeys.task_id_cipher)
        parms["task_id_check"] = defaults.string(forKey: UserDefaultsKeys.task_id)
        
        
        self.ExstreamTaskLocationViewModel1?.ExstreamTaskLocationViewModel(dictParam: parms)
        
    }

    func ExstreamTaskPropertyLocationApiCall() {
        
        parms["task_id"] = defaults.string(forKey: UserDefaultsKeys.sub_task_id)
        parms["longitude"] = KLat
        parms["task_pic"] = self.imageBase64
        parms["latitude"] = KLong
        self.ExstreamTaskpropertyLocation?.CrewTaskPropertyLocationApi(dictParam: parms)
       
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckboxInTaskDetailsTVCell", for: indexPath) as! CheckboxInTaskDetailsTVCell
        
        let data = subtaskDetail?.data?.subtask?[indexPath.row]
        cell.numbersLabel.text = data?.sub_task_name
        
        if data?.completed_status == "complete" {
            self.taskDetailsTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            cell.selectDeselectImage.image = UIImage(named: "taskChecked")
        }else{
            self.taskDetailsTableView.deselectRow(at: indexPath, animated: false)
            cell.selectDeselectImage.image = UIImage(named: "taskUnCheck")
        }
        
       
        
        
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(withInLocationBool)
        
        let cell = tableView.cellForRow(at: indexPath) as! CheckboxInTaskDetailsTVCell
        
        if withInLocationBool == true {
            
            cell.selectDeselectImage.image = UIImage(named: "taskChecked")
            UpdateTaskStatusinCompleteApiCall()
            
           if subtaskDetail?.image_captured == "Captured" {
               guard let vc = StartTheClockVC.newInstance else {return}
               vc.modalPresentationStyle = .overCurrentContext
               vc.captured = "true"
               self.present(vc, animated: true, completion: nil)
//               NotificationCenter.default.post(name: Notification.Name("showTheClock"), object: nil)
            
            } else {
                print("startCamera")
                
                guard let vc = StartTheClockVC.newInstance else {return}
                vc.modalPresentationStyle = .overCurrentContext
                vc.captured = "false"
                self.present(vc, animated: true, completion: nil)

//                NotificationCenter.default.post(name: NSNotification.Name("startCamera"), object: nil)
            }
                
            }else {
                
                self.showAlertOnWindow(title: "", message: "Idle time has begun. You have been away from the unit for 5 minutes", titles: ["OK"], completionHanlder: nil)
            }
        

            
    }

}


extension TaskDetailsVC : SubTaskListProtocol,TaskDetailsViewModelDelegate , UpdateTaskStatusViewModelProtocol , UpdateTaskStatusCompleteViewModelProtocol , ExstreamTaskLocationViewModelProtocol, crewTaskPropertyLocationViewModelProtocol
{
   
   
    
    func ExstreamTaskLocationSuccess(ExstreamTaskLocationViewModelResponse: ExstreamTaskLocationModel) {
        self.ExstreamTaskLocationReasponse = ExstreamTaskLocationViewModelResponse
        print("ExstreamTaskLocationReasponse\(ExstreamTaskLocationReasponse)")
        
        print("ExstreamTaskLocationReasponseideal_time\(ExstreamTaskLocationReasponse?.time?.ideal_time)")
        
        if ExstreamTaskLocationReasponse?.time?.ideal_time != "00:00:00" {
            timerView.idleTimerValueLbl.text = ExstreamTaskLocationReasponse?.time?.ideal_time
            DispatchQueue.main.async {[self] in
                self.seconds = String().secondsFromString(string: ExstreamTaskLocationReasponse?.time?.ideal_time ?? "00:00:00")
                
                //                self.startDaylbl.text = "stop day"
                //            taskListTableView.isUserInteractionEnabled = true
                //            taskListTableView.alpha = 1
                self.timerView.playPauseImage.image = UIImage(named: "Stop")?.withRenderingMode(.alwaysOriginal).withTintColor(.red)
                self.runTimer()
                
            }
        }
        
        
        
        
    }
    
    func UpdateTaskStatusCompleteSuccess(UpdateTaskStatusCompleteResponse: UpdateTaskStatusCompleteModel) {
        self.UpdateTaskStatusCompleteResponse1 = UpdateTaskStatusCompleteResponse
        print("UpdateTaskStatusCompleteResponse\(UpdateTaskStatusCompleteResponse1)")
        
    }
    
    
    func UpdateTaskStatusSuccess(UpdateTaskStatusResponse: UpdateTaskStatusModel) {
        self.UpdateTaskStatusIncompleteResponse = UpdateTaskStatusResponse
        print("UpdateTaskStatusIncompleteResponse\(UpdateTaskStatusIncompleteResponse)")
        
        
    }
    func crewTaskPropertyLocationSuccess(CrewTaskpropertyLocation: crewpropertyLocationModel) {
        
        self.ExstreamTaskpropertyLocationResponse = CrewTaskpropertyLocation
        print("ExstreamTaskpropertyLocationResponse\(ExstreamTaskpropertyLocationResponse)")
    }
    
    
   
    
    func subTaskList(response: SubtaskDetailModel?) {
        
        self.subtaskDetail = response
        defaults.set(subtaskDetail?.data?.subtask?.first?.sub_task_id, forKey: UserDefaultsKeys.sub_task_id)
        defaults.set(subtaskDetail?.data?.subtask?.first?.sub_task_cipher, forKey: UserDefaultsKeys.sub_task_cipher)
        defaults.set(subtaskDetail?.data?.subtask?.first?.completed_status, forKey: UserDefaultsKeys.completetasktype)
        print("subtaskDetailresponse = \(response)")
        
        if subtaskDetail?.data?.subtask?.count ?? 0 > 0{
            subtaskDetail?.data?.subtask?.forEach({ i in
                if i.sub_task_assined_to_this_crew == false {
                    self.topTimerViewHeightConstraint.constant = 0
                    self.topTimerView.backgroundColor = .white
                    self.playpauseView.isHidden = true
                    self.timerView.isHidden = true
                    self.timerLabel.isHidden = true
                    self.tickMarkView.isHidden = true
                    self.timerView.isHidden = false
                }
            })
            
        } else {
            
            print("sub_task_assined_to_this_crew")
            
        }
        
        latdistance = Double(subtaskDetail?.latitude ?? "") ?? 0.0
        longdistance = Double(subtaskDetail?.longitude ?? "") ?? 0.0
        DispatchQueue.main.async {
            self.taskDetailsTableView.reloadData()
        }
    }
    
    
    func startStopTaskLogResponse(response: CrewTaskLogModel?) {
        print("startStopTaskLogResponse \(response)")
    }
    
}
extension TaskDetailsVC {
    
    
    func runTimer() {
        if !(timer?.isValid ?? false) {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }else {
            timer?.invalidate()
        }
    }
    
    @objc func updateTimer() {
        seconds += 1
        self.timerView.idleTimerValueLbl.text = timeString(time: TimeInterval(seconds))
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}



extension TaskDetailsVC: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
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
