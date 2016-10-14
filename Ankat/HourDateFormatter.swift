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
    var timer : Timer!
    
    override init() {
        super.init()
    }
    
    func setTargetsLabel (_ hourTargetLabel : UILabel, dateTargetLabel : UILabel) {
        
        self.hourTargetLabel = hourTargetLabel
        self.dateTargetLabel = dateTargetLabel
        
        
        
    }
    
    func start () {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(HourDateFormatter.update), userInfo: nil, repeats: true)
    }
    
    func stop () {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    func update () {
        
        let date = Date()
        
        if let targetLabel = self.hourTargetLabel {
            targetLabel.text = getHourFormat(date)
        }
        
        if let targetLabel = self.dateTargetLabel {
            targetLabel.text = getDateFormat(date)
        }
        
    }
    
    func getHourFormat (_ date : Date) -> String {
        
        let components = getTimeFormtat(date)
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "mm"
        
        let ampm = components.hour! < 12 ? "AM" : "PM"
        let hour = (components.hour! == 0 || components.hour! == 12) ? 12 :  (components.hour! % 12)
        let hourString =  ( (hour) < 10) ? "0\(hour)"  : "\(hour)"
        
        if state == false {
            self.state = true
            return "\(hourString):\(dateFormat.string(from: date)) \(ampm)"
        } else {
            self.state = false
            return "\(hourString) \(dateFormat.string(from: date)) \(ampm)"
            
        }
        
    }
    
    func getDateFormat (_ date : Date) -> String {
        
        let components = getTimeFormtat(date)
        
        let mL = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        let daysInWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
        
        return "\(daysInWeek[components.weekday!-1]), \(mL[components.month!-1]) \(components.day!), \(components.year!)"
        
    }
    
    func getTimeFormtat (_ date : Date) -> DateComponents {
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .month, .weekday, .day, .year], from: date)
        
        return components
    }
    
}
