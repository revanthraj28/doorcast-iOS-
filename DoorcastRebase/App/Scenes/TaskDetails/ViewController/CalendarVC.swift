//
//  CalendarVC.swift
//  DoorcastRebase
//
//  Created by CODEBELE-01 on 05/05/22.
//

import UIKit
import JTAppleCalendar


class CalendarVC: UIViewController {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarViewHolder: UIView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var sundayLabel: UILabel!
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    @IBOutlet weak var labelSelectedDays: UILabel!
    @IBOutlet weak var doneButtonHolderView: UIView!
    @IBOutlet weak var closeImage: UIImageView!
    @IBOutlet weak var ButtonDone: UIButton!
    
    var selectedfirstDate : Date?
    var selectedlastDate : Date?
    let df = DateFormatter()
    var startDate = Date().dateByAddingMonths(months: -12).startOfMonth
    var endDate = Date().dateByAddingMonths(months: 12).endOfMonth
    var selectedDays: Date?
    let grayView = UIView()
    var btnDoneActionBool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupCalView()
    }
    
    
    func updateUI() {
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        holderView.backgroundColor = .white
        holderView.layer.shadowColor = UIColor.lightGray.cgColor
        holderView.layer.shadowOpacity = 1
        holderView.layer.shadowOffset = .zero
        holderView.layer.shadowRadius = 5
        
        doneButtonStyle(Selected: false)
      
        monthLabel.textColor = .black
        monthLabel.font = UIFont.oswaldMedium(size: 14)
      
        sundayLabel.textColor = .black
        sundayLabel.font = UIFont.oswaldMedium(size: 12)
        sundayLabel.text = "SU"
        
        mondayLabel.textColor = .black
        mondayLabel.font = UIFont.oswaldMedium(size: 12)
        mondayLabel.text = "MO"
        
        tuesdayLabel.textColor = .black
        tuesdayLabel.font = UIFont.oswaldMedium(size: 12)
        tuesdayLabel.text = "TU"
        
        wednesdayLabel.textColor = .black
        wednesdayLabel.font = UIFont.oswaldMedium(size: 12)
        wednesdayLabel.text = "WE"
        
        thursdayLabel.textColor = .black
        thursdayLabel.font = UIFont.oswaldMedium(size: 12)
        thursdayLabel.text = "TH"
        
        fridayLabel.textColor = .black
        fridayLabel.font = UIFont.oswaldMedium(size: 12)
        fridayLabel.text = "FR"
        
        saturdayLabel.textColor = .black
        saturdayLabel.font = UIFont.oswaldMedium(size: 12)
        saturdayLabel.text = "SA"
        
        
        doneButtonHolderView.backgroundColor = UIColor.clear
        ButtonDone.setTitle("", for: .normal)
        
       
    }
    
    
    func setupCalView() {
        
        
        calendarViewHolder.backgroundColor = .clear
        
        // Do any additional setup after loading the view.
        calendarView.scrollDirection  = .horizontal
        calendarView.scrollingMode = .stopAtEachSection
        calendarView.showsHorizontalScrollIndicator = false
        
        calendarView.scrollToDate(Date(),animateScroll: false)
        
        calendarView.register(UINib(nibName: "calendarCVCell", bundle: nil), forCellWithReuseIdentifier: "calendarCVCell")
        //        calendarView.allowsSelection = true
        calendarView.allowsMultipleSelection = true
        calendarView.isRangeSelectionUsed = true
        calendarView.ibCalendarDelegate = self
        calendarView.ibCalendarDataSource = self
        
        calendarView.visibleDates { (visibleDates) in
            self.setupMonthLabel(date: visibleDates.monthDates.first?.date ?? Date())
        }
        
        let panGensture = UILongPressGestureRecognizer(target: self, action: #selector(didStartRangeSelecting(gesture:)))
        panGensture.minimumPressDuration = 0.5
        calendarView.addGestureRecognizer(panGensture)
        
        labelSelectedDays.textColor = .white
    }
    
    
    
    @objc func didStartRangeSelecting(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: gesture.view!)
        let rangeSelectedDates = calendarView.selectedDates
        
        guard let cellState = calendarView.cellStatus(at: point) else { return }
        
        if !rangeSelectedDates.contains(cellState.date) {
            let dateRange = calendarView.generateDateRange(from: rangeSelectedDates.first ?? cellState.date, to: cellState.date)
            calendarView.selectDates(dateRange, keepSelectionIfMultiSelectionAllowed: true)
        }
    }
    
    func setupMonthLabel(date: Date) {
        monthLabel.text = date.monthYearName
    }
    func handleConfiguration(cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? calendarCVCell else { return }
        handleCellColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
        
        if calendarView.selectedDates.count == 0 {
            labelSelectedDays.text = ""
            doneButtonStyle(Selected: false)
        }else if calendarView.selectedDates.count == 1 {
            labelSelectedDays.text = "\(cellState.date.customDateStringFormat("dd/MM/YYYY"))"
            doneButtonStyle(Selected: true)
        }else {
            labelSelectedDays.text = "\(calendarView.selectedDates.first?.customDateStringFormat("dd/MM/YYYY") ?? "") - \(calendarView.selectedDates.last?.customDateStringFormat("dd/MM/YYYY") ?? "")"
            doneButtonStyle(Selected: true)
        }
    }
    
    
    func handleCellColor(cell: calendarCVCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.label.textColor = UIColor.black
        } else {
            cell.label.textColor = UIColor.lightGray
        }
    }
    
    func handleCellSelected(cell: calendarCVCell, cellState: CellState) {
        cell.selectedView.isHidden = !cellState.isSelected
        switch cellState.selectedPosition() {
        case .left:
            cell.selectedView.layer.cornerRadius = 0
            cell.selectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            cell.selectedView.isHidden = false
            cell.selectedView.backgroundColor = UIColor.ThemeColor
            cell.label.textColor = UIColor.white
        case .middle:
            cell.selectedView.layer.cornerRadius = 0
            cell.selectedView.layer.maskedCorners = []
            cell.selectedView.isHidden = false
            cell.selectedView.backgroundColor = UIColor.ThemeColor
            cell.label.textColor = UIColor.white
        case .right:
            cell.selectedView.layer.cornerRadius = 0
            cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            cell.selectedView.isHidden = false
            cell.selectedView.backgroundColor = UIColor.ThemeColor
            cell.label.textColor = UIColor.white
        case .full:
            cell.selectedView.layer.cornerRadius = 0
            cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            cell.selectedView.isHidden = false
            cell.selectedView.backgroundColor = UIColor.ThemeColor
            cell.label.textColor = UIColor.white
        default: break
        }
    }
    
    
    func doneButtonStyle(Selected: Bool) {
        if Selected == false {
            ButtonDone.layer.cornerRadius = ButtonDone.frame.size.height / 2
            ButtonDone.layer.shadowColor = UIColor.lightGray.cgColor
            ButtonDone.layer.shadowOpacity = 1
            ButtonDone.layer.shadowOffset = .zero
            ButtonDone.layer.shadowRadius = 5
            ButtonDone.layer.backgroundColor = UIColor.white.cgColor
            ButtonDone.layer.borderWidth = 1
            ButtonDone.layer.borderColor = UIColor.lightGray.cgColor
            ButtonDone.tintColor = UIColor.ThemeColor
            // ButtonDone.setImage(UIImage(named: "close"), for: .normal)
            closeImage.image = UIImage(named: "close")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.ThemeColor)
            
            doneButtonHolderView.isHidden = false
        }else {
            ButtonDone.layer.cornerRadius = ButtonDone.frame.size.height / 2
            ButtonDone.layer.backgroundColor = UIColor.ActionsColor.cgColor
            ButtonDone.layer.borderWidth = 3
            ButtonDone.layer.borderColor = UIColor.white.cgColor
            ButtonDone.tintColor = UIColor.white
            // ButtonDone.setImage(UIImage(named: "LeftArrow"), for: .normal)
            closeImage.image = UIImage(named: "LeftArrow")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.white)
            
            doneButtonHolderView.isHidden = false
            doneButtonHolderView.backgroundColor = .ActionsColor
            doneButtonHolderView.layer.cornerRadius = doneButtonHolderView.frame.size.height / 2
            
        }
    }
    
    
    
    
    
    @IBAction func leftButtonClick(_ sender: Any) {
        calendarView.scrollToSegment(.previous)
    }
    
    @IBAction func rightButtonClick(_ sender: Any) {
        calendarView.scrollToSegment(.next)
    }
    @IBAction func buttonToday(_ sender: Any) {
        calendarView.deselectAllDates()
        calendarView.selectDates([Date()], triggerSelectionDelegate: false)
    }
    
    @IBAction func buttonYesterday(_ sender: Any) {
        calendarView.deselectAllDates()
        calendarView.selectDates([Date.yesterday], triggerSelectionDelegate: false)
    }
    
    @IBAction func buttonThisWeek(_ sender: Any) {
        calendarView.deselectAllDates()
        let arrWeekDates = Date().getWeekDates() // Get dates of Current and Next week.
        let thisMon = arrWeekDates.thisWeek.first!
        let thisTues = arrWeekDates.thisWeek[arrWeekDates.thisWeek.count - 6]
        let thisWed = arrWeekDates.thisWeek[arrWeekDates.thisWeek.count - 5]
        let thisTHur = arrWeekDates.thisWeek[arrWeekDates.thisWeek.count - 4]
        let thisFri = arrWeekDates.thisWeek[arrWeekDates.thisWeek.count - 3]
        let thisSat = arrWeekDates.thisWeek[arrWeekDates.thisWeek.count - 2]
        let thisSun = arrWeekDates.thisWeek[arrWeekDates.thisWeek.count - 1]
        
        calendarView.selectDates([thisMon,thisTues,thisWed,thisTHur,thisFri,thisSat,thisSun], triggerSelectionDelegate: false)
    }
    
    
    @IBAction func btnDoneAction(_ sender: Any) {
        
        selectedfirstDate = nil
        selectedlastDate = nil
        
        //    (self.parent as? CalendarViewProtocol)?.CloseCalendarAction()
        self.dismiss(animated: true)
    }
    
}




extension CalendarVC: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        handleConfiguration(cell: cell, cellState: cellState)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCVCell", for: indexPath) as! calendarCVCell
        cell.label.text = cellState.text
        cell.holderView.backgroundColor = .white
        handleConfiguration(cell: cell, cellState: cellState)
        //        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        if cellState.dateBelongsTo == .thisMonth {
            cell.isHidden = false
        } else {
            cell.isHidden = true
        }
        
        if date > Date(){
            cell.label.textColor = .lightGray
        }
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupMonthLabel(date: visibleDates.monthDates.first!.date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleConfiguration(cell: cell, cellState: cellState)
        
        
        if selectedfirstDate != nil {
            if date < selectedfirstDate! {
                calendarView.selectDates(from: date, to: selectedfirstDate!,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
                selectedlastDate = calendarView.selectedDates.last
                selectedfirstDate = calendarView.selectedDates.first
                
            } else {
                selectedlastDate = calendarView.selectedDates.last
                calendarView.selectDates(from: selectedfirstDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
            }
        } else {
            selectedfirstDate = calendarView.selectedDates.first
            selectedlastDate = nil
            handleConfiguration(cell: cell, cellState: cellState)
        }
        
        print(calendarView.selectedDates)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleConfiguration(cell: cell, cellState: cellState)
        
        if selectedfirstDate != nil{
            if date > (selectedfirstDate!){
                calendarView.deselectDates(from: selectedfirstDate!, to: date, triggerSelectionDelegate: false)
                selectedfirstDate = calendarView.selectedDates.first
            } else if selectedlastDate == nil || date == selectedlastDate {
                selectedfirstDate = nil
                selectedlastDate = nil
                handleConfiguration(cell: cell, cellState: cellState)
                
            }else {
                handleConfiguration(cell: cell, cellState: cellState)
            }
        }
        print(calendarView.selectedDates)
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        print("configureCalendar")
        let parameter = ConfigurationParameters(startDate: self.startDate,
                                                endDate: self.endDate,
                                                numberOfRows: 6,
                                                generateInDates: .forAllMonths,
                                                generateOutDates: .tillEndOfGrid,
                                                firstDayOfWeek: .monday,
                                                hasStrictBoundaries:true)
        return parameter
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        return date < Date()
    }
    
}
