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
    
    
    
    
    var crewPropertyIds = [String]()
    
    
    static var newInstance: CommonTaskDetailVC? {
        let storyboard = UIStoryboard(name: Storyboard.taskDetails.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? CommonTaskDetailVC
        return vc
    }
    
    private lazy var incompleteViewController: IncompleteTasksVC = {
        let storyboard = UIStoryboard(name: Storyboard.taskDetails.name, bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "IncompleteTasksVC") as! IncompleteTasksVC
        viewController.crewPropertyIds = crewPropertyIds
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
        userNameLabel.text = UserDefaults.standard.string(forKey: "fullname")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    @IBAction func incompleteButtonAction(_ sender: Any) {
        setSegmentedUI(selectedButton: incompleteButton, UnSelectButton: completeButton)
        calendarView.isHidden = true
        remove(asChildViewController: completeViewController)
        add(asChildViewController: incompleteViewController)
    }
    
    @IBAction func completedButtonAction(_ sender: Any) {
        setSegmentedUI(selectedButton: completeButton, UnSelectButton: incompleteButton)
        calendarView.isHidden = false
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
        self.dismiss(animated: false)
    }
    
    
    @IBAction func didTapOnNotificationCenterViewButton(_ sender: Any) {
        print("didTapOnNotificationCenterViewButton")
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
