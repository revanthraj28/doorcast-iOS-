//
//  DateExtension.swift
//  DoorcastRebase
//
//  Created by CODEBELE-01 on 05/05/22.
//

import Foundation



extension Date {
    
    func customDateStringFormat(_ format: String? = "MMM d, EEEE"
    ) -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = format
        return dateFormatterPrint.string(from: self) as String
    }
    
    
    func dateByAddingMonths(months: Int) -> Date {
        return NSCalendar.current.date(byAdding: .month, value: months, to: self as Date)!
    }
    
    var startOfMonth:Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    var endOfMonth:Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
    }
    var monthName:String? {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM")
        return df.string(from: self)
    }
    var monthYearName:String? {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMMM YYYY")
        return df.string(from: self)
    }
    var dateDayString:String? {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("DD MMM YYYY")
        return df.string(from: self)
    }
    var dateMonth: String? {
        let df = DateFormatter()
        df.dateFormat = "MM/DD"
        return df.string(from: self)
    }
    var dateFormatString:String? {
        let df = DateFormatter()
        df.dateFormat = "DD/MM/YYYY"
        return df.string(from: self)
    }
    var MonthDateDayFormatter: String? {
        let df = DateFormatter()
        df.dateFormat = "MMMM dd, YYYY"
        return df.string(from: self)
    }
    
    
    var onlyDayString:String? {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("dd")
        return df.string(from: self)
    }
    
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    func getWeekDates() -> (thisWeek:[Date],nextWeek:[Date]) {
        var tuple: (thisWeek:[Date],nextWeek:[Date])
        var arrThisWeek: [Date] = []
        for i in 0..<7 {
            arrThisWeek.append(Calendar.current.date(byAdding: .day, value: i, to: startOfWeek)!)
        }
        var arrNextWeek: [Date] = []
        for i in 1...7 {
            arrNextWeek.append(Calendar.current.date(byAdding: .day, value: i, to: arrThisWeek.last!)!)
        }
        tuple = (thisWeek: arrThisWeek,nextWeek: arrNextWeek)
        return tuple
    }
    
    var startOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .day, value: 1, to: sunday!)!
    }
}
