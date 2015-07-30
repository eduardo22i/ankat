//
//  HourDateFormatter.swift
//  PPS Timer
//
//  Created by Eduardo Irías on 7/14/15.
//  Copyright (c) 2015 Pacesetter Personnel ServiceI Inc. All rights reserved.
//

import UIKit

class HourDateFormatter: NSObject {
    
    var state = false
    var hourTargetLabel : UILabel!
    var dateTargetLabel : UILabel!
    
    
    override init() {
        super.init()
    }
    
    func setTargetsLabel (hourTargetLabel : UILabel, dateTargetLabel : UILabel) {
        
        self.hourTargetLabel = hourTargetLabel
        self.dateTargetLabel = dateTargetLabel
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
    }
    
    func update () {
        
        let date = NSDate()
        
        if let targetLabel = self.hourTargetLabel {
            targetLabel.text = getHourFormat(date)
        }
        
        if let targetLabel = self.dateTargetLabel {
            targetLabel.text = getDateFormat(date)
        }
        
    }
    
    func getHourFormat (date : NSDate) -> String {
        
        let components = getTimeFormtat(date)
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "mm"
        
        let ampm = components.hour < 12 ? "AM" : "PM"
        var hour = (components.hour == 0 || components.hour == 12) ? 12 :  (components.hour % 12)
        var hourString =  ( (hour) < 10) ? "0\(hour)"  : "\(hour)"
        
        if state == false {
            self.state = true
            return "\(hourString):\(dateFormat.stringFromDate(date)) \(ampm)"
        } else {
            self.state = false
            return "\(hourString) \(dateFormat.stringFromDate(date)) \(ampm)"
            
        }
        
    }
    
    func getDateFormat (date : NSDate) -> String {
        
        let components = getTimeFormtat(date)
        
        let mL = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        let daysInWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
        
        return "\(daysInWeek[components.weekday-1]), \(mL[components.month-1]) \(components.day), \(components.year)"
        
    }
    
    func getTimeFormtat (date : NSDate) -> NSDateComponents {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components (.CalendarUnitHour | .CalendarUnitMinute | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitWeekday | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitYear, fromDate: date)
        
        return components
    }
    
}
