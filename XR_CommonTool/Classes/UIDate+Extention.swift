//
//  UIDate+Extention.swift
//  KRActivityIndicatorView
//
//  Created by Mr.Xr on 2020/7/25.
//

import UIKit

// MARK: - Date
extension Date {
    /// 比较两个日期是否是同一天
    public func isSameDay(_ otherDay:Date) -> Bool{
        
        let calendar = Calendar.current
        
        let comp1 = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month,Calendar.Component.day], from: self)
        
        let comp2 = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month,Calendar.Component.day], from: otherDay)
        
        return comp1.day == comp2.day && comp1.month == comp2.month  && comp1.year == comp2.year;
    }
    
    /**
     * 获取日、月、年、小时、分钟、秒
     */
    public var day: Int {
        return NSCalendar.current.component(Calendar.Component.day, from: self)
    }
    
    public var month: Int {
        return NSCalendar.current.component(Calendar.Component.month, from: self)
    }
    
    public var year: Int {
        return NSCalendar.current.component(Calendar.Component.year, from: self)
    }
    
    public var hour: Int {
        return NSCalendar.current.component(Calendar.Component.hour, from: self)
    }
    
    public var minute: Int {
        return NSCalendar.current.component(Calendar.Component.minute, from: self)
    }
    
    public var second: Int {
        return NSCalendar.current.component(Calendar.Component.second, from: self)
    }
    
    /// 一年中的总天数
    public func daysInYear() -> Int {
        return self.isLeapYear() ? 366 : 365
    }
    
    /// 是否润年
    public func isLeapYear() -> Bool {
        let year = self.year
        if (year % 4 == 0 && year % 100 != 0) || year % 400 == 0 {
            return true
        }
        return false
    }
    
    /// 是否在未来
    public var isInFuture: Bool {
        return self > Date()
    }
    
    /// 是否在过去
    public var isInPast: Bool {
        return self < Date()
    }
    
    /// 是否在本天
    public var isInToday: Bool {
        return self.day == Date().day && self.month == Date().month && self.year == Date().year
    }
    
    /// 是否在本月
    public var isInMonth: Bool {
        return self.month == Date().month && self.year == Date().year
    }
    
    //获得当前月份第一天星期几
    public var weekdayForFirstday: Int {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        var comp = calendar.dateComponents([.year, .month, .day], from: self)
        comp.day = 1
        let firstDayInMonth = calendar.date(from: comp)!
        let weekday = calendar.ordinality(of: Calendar.Component.weekday, in: Calendar.Component.weekOfMonth, for: firstDayInMonth)
        return weekday! - 1
    }
    
    // 获得一个月总天数
    public var daysInMonth: Int {
        return Calendar.current.range(of: Calendar.Component.day, in: Calendar.Component.month, for: self)!.count
    }
    

    /// 获取其他月的数据
    ///
    /// - Parameter poor: 与当前的date相差几个月 (-1---上月,  1---下月)
    /// - Returns: 目标date
    public func getOtherMonthDate(_ poor: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = poor
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    //MARK: 今天星期几
    public static func currentWeekDay() -> Int {
        let interval = Int(Date().timeIntervalSince1970)
        let days = Int(interval/86400) // 24*60*60
        let weekday = ((days + 4)%7+7)%7
        return weekday == 0 ? 7 : weekday
    }
}

extension Date {
    
    /// 获取当前 秒级 时间戳 - 10位
    public var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    
    /// 获取当前 毫秒级 时间戳 - 13位
    public var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    // Year
    public var currentYear: Int {
        return Int(getDateComponent(dateFormat: "yy"))!
        //return getDateComponent(dateFormat: "yyyy")
    }
    
    // Month
    public var currentMonth: Int {
        return Int(getDateComponent(dateFormat: "M"))!
        
        //return getDateComponent(dateFormat: "MM")
        
        //return getDateComponent(dateFormat: "MMM")
        
        //return getDateComponent(dateFormat: "MMMM")
    }
    
    // Day
    public var currentDay: Int {
        return Int(getDateComponent(dateFormat: "dd"))!
        //return getDateComponent(dateFormat: "dd")
    }
    
    public func getOtherDayDate(_ poor: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = poor
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    public func getOtherHourDate(hour: Int, _ minute: Int = 0) -> Date {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    public func getOtherSecondDate(second: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.second = second
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    public func getDateComponent(dateFormat: String) -> String {
        NSTimeZone.resetSystemTimeZone()
        let format = DateFormatter()
        format.dateFormat = dateFormat
        format.locale = Locale.init(identifier: "en_US")
        return format.string(from: self)
    }
    
    public static func zeroTimeDate() -> Date {
        let calendar: NSCalendar = NSCalendar.current as NSCalendar
        let unitFlags: NSCalendar.Unit = [
            NSCalendar.Unit.year,
            NSCalendar.Unit.month,
            NSCalendar.Unit.day,
            .hour,
            .minute,
            .second]
        var components = calendar.components(unitFlags, from: Date())
        components.hour = 0
        components.minute = 0
        components.second = 0
        let date = calendar.date(from: components)
        return date!
    }
    
    public func zeroTimeDate() -> Date {
        let calendar: NSCalendar = NSCalendar.current as NSCalendar
        let unitFlags: NSCalendar.Unit = [
            NSCalendar.Unit.year,
            NSCalendar.Unit.month,
            NSCalendar.Unit.day,
            .hour,
            .minute,
            .second]
        var components = calendar.components(unitFlags, from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        let date = calendar.date(from: components)
        return date!
    }
    
    public func getOtherDayWeek(day: Int) -> Int {
          (self.dayOfWeek() - 1 + 7 + day) % 7
    }
    
    /// 获取星期几
    /// 周日
    public func dayOfWeek() -> Int {
        let interval = Int(self.timeIntervalSince1970)
        let days = Int(interval/86400) // 24*60*60
        return (days - 2) % 7
    }
}
