//
//  CommonTaskDetailVC.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import UIKit

class CommonTaskDetailVC: UIViewController {
    
    @IBOutlet weak var incompleteButton: UIButton!
    @IBOutlet weak var parentSegmentView: UIView!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var timerView: TimerView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var calImageViewHolder: UIView!
    @IBOutlet weak var calImageView: UIImageView!
    @IBOutlet weak var calShowButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var notificationViewButton: UIButton!
    @IBOutlet weak var completedTaskCountHolderView: UIView!
    @IBOutlet weak var completedTaskCountLabel: UILabel!
    @IBOutlet weak var speechView: SpeechBubble!
    @IBOutlet weak var startDaylbl: UILabel!
    @IBOutlet weak var startDayButton: UIButton!
    @IBOutlet weak var dayAlertlbl: UILabel!
    
    
    
    
    var crewPropertyIds = [String]()
    var timer : Timer?
    var seconds = 0
    
    
    static var newInstance: CommonTaskDetailVC? {
        let storyboard = UIStoryboard(name: Storyboard.taskDetails.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? CommonTaskDetailVC
        return vc
        
        
    }
    
    
    private lazy var incompleteViewController: IncompleteTasksVC = {
        let storyboard = UIStoryboard(name: Storyboard.taskDetails.name, bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "IncompleteTasksVC") as! IncompleteTasksVC
        //viewController.crewPropertyIds = crewPropertyIds
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var completeViewController: CompletedTasksVC = {
        let storyboard = UIStoryboard(name: Storyboard.taskDetails.name, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CompletedTasksVC") as! CompletedTasksVC
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.view.bringSubviewToFront(self.speechView)
        
        if let fullname = UserDefaults.standard.string(forKey: "fullname") {
            userNameLabel.text = fullname.uppercased()
        }
        
        changeStatusBarColor(with: .ThemeColor)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.font = UIFont.oswaldMedium(size: 18)
        dateLabel.font = UIFont.oswaldMedium(size: 18)
        configureUI()
        setupUI()
    }
    
    func configureUI(){
        navigationController?.navigationBar.isHidden = true
        calendarView.isHidden = true
        // userNameLabel.text = SessionManager.loginInfo?.data?.fullname?.uppercased() ?? ""
        
        setSegmentedUI(selectedButton: incompleteButton, UnSelectButton: completeButton)
        remove(asChildViewController: completeViewController)
        add(asChildViewController: incompleteViewController)
    }
    
    func setupUI() {
        
        calImageViewHolder.layer.cornerRadius = 18
        calImageViewHolder.clipsToBounds = true
        calImageViewHolder.backgroundColor = .ThemeColor
        calendarView.backgroundColor = .clear
        
        completedTaskCountHolderView.backgroundColor = UIColor.white
        completedTaskCountLabel.text = "0"
        self.calendarView.bringSubviewToFront(self.calImageViewHolder)
        
        calImageView.image = UIImage(named: "chevron-down-solid")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.white)
        calShowButton.setTitle("", for: .normal)
        calShowButton.backgroundColor = .clear
        self.view.bringSubviewToFront(self.timerView)
        self.dateLabel.text = Date().MonthDateDayFormatter
        backButton.setImage(UIImage(named: "chevron-left-solid")?.withTintColor(UIColor.white), for: .normal)
        notificationViewButton.setImage(UIImage(named: "menu")?.withTintColor(UIColor.white), for: .normal)
        
        self.parentSegmentView.bringSubviewToFront(self.speechView)
        speechView.backgroundColor = UIColor.clear
        speechView.isHidden = true
        startDaylbl.text = "Start day"
        startDaylbl.textColor = UIColor.white
        startDaylbl.textAlignment = .center
        startDaylbl.font = UIFont.poppinsSemiBold(size: 14)
        
        dayAlertlbl.textColor = UIColor.white
        dayAlertlbl.backgroundColor = UIColor.red
        dayAlertlbl.isHidden = true
        dayAlertlbl.text = "Your day has beeen started"
        dayAlertlbl.textAlignment = .center
        dayAlertlbl.font = UIFont.oswaldLightItalic(size: 25)
        
        
    }
    
    @IBAction func incompleteButtonAction(_ sender: Any) {
        setSegmentedUI(selectedButton: incompleteButton, UnSelectButton: completeButton)
        calendarView.isHidden = true
        self.speechView.isHidden = true
        remove(asChildViewController: completeViewController)
        add(asChildViewController: incompleteViewController)
    }
    
    @IBAction func completedButtonAction(_ sender: Any) {
        setSegmentedUI(selectedButton: completeButton, UnSelectButton: incompleteButton)
        calendarView.isHidden = false
        self.speechView.isHidden = true
        remove(asChildViewController: incompleteViewController)
        add(asChildViewController: completeViewController)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func didTapOnCalenderShowButton(_ sender: Any) {
        print("didTapOnCalenderShowButton")
        
        let sb = UIStoryboard(name: "TaskDetails", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CalendarVC")
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
        
    }
    
    
    @IBAction func didTapOnBackButton(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "gotoOnBoardingVC"), object: startDaylbl.text ?? "")
    }
    
    
    @IBAction func didTapOnNotificationCenterViewButton(_ sender: Any) {
        print("didTapOnNotificationCenterViewButton")
        guard let vc = NotificationCenterVC.newInstance else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    @IBAction func startStopDayAction(_ sender: Any) {
        print("startStopDayAction")
        
        
        if startDaylbl.text == "Start day" {
            
            self.dayAlertlbl.fadeIn()
            self.dayAlertlbl.fadeOut()
            
            
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "daytask"), object: startDaylbl.text ?? "")
            startDaylbl.text = "Stop day"
        }else {
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "daytask"), object: startDaylbl.text ?? "")
            startDaylbl.text = "Start day"
        }
        
    }
    
    
    
    // MARK: - Helper Methods
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        // Add Child View as Subview
        parentSegmentView.addSubview(viewController.view)
        // Configure Child View
        viewController.view.frame = parentSegmentView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        // Notify Child View Controller
        viewController.removeFromParent()
    }
}





extension CommonTaskDetailVC {
    
    
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
