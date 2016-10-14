//
//  SelectOfferDayViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/31/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

class SelectOfferDayViewController: UIViewController {

    var recommendation : Offer!
    var days : [Date] = []
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        self.title = recommendation.name
    }
    
    func dateSeletec () {
        
        
    }
    
    
    
    @IBAction  func dateSelectAction (_ sender : AnyObject ) {
        if let recommendation = recommendation {
            
            //self.startLoading("Saving")
            
            for date in days {
                //let date = days[0]
                
                let dateformatterDay = DateFormatter()
                dateformatterDay.dateFormat = "dd"
                let dateformatterMonth = DateFormatter()
                dateformatterMonth.dateFormat = "MM"
                let dateformatterYear = DateFormatter()
                dateformatterYear.dateFormat = "YYYY"
                
                let dateformatterHour = DateFormatter()
                dateformatterHour.dateFormat = "h"
                
                let dateformatterMinutes = DateFormatter()
                dateformatterMinutes.dateFormat = "mm"
                
                
                let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
                var components = (calendar as NSCalendar?)?.components( .calendar, from: date)
                
                components?.day = Int(dateformatterDay.string(from: date))!
                components?.month = Int(dateformatterMonth.string(from: date))!
                components?.year = Int(dateformatterYear.string(from: date))!
                
                components?.hour = Int(dateformatterHour.string(from: datePicker.date))!
                components?.minute = Int(dateformatterMinutes.string(from: datePicker.date))!
                components?.second = 00
                
                
                //End date
                let dateformatterHour2 = DateFormatter()
                dateformatterHour2.dateFormat = "HH"
                
                
                let calendarEnd = Calendar(identifier: Calendar.Identifier.gregorian)
                var componentsEnd = (calendar as NSCalendar?)?.components( .calendar, from: date )
                
                componentsEnd?.day = Int(dateformatterDay.string(from: date))!
                componentsEnd?.month = Int(dateformatterMonth.string(from: date))!
                componentsEnd?.year = Int(dateformatterYear.string(from: date))!
                
                let hours = Int(dateformatterHour2.string(from: datePicker.date))! + Int(dateformatterHour2.string(from: timePicker.date))!
                
                componentsEnd?.hour = hours % 24
                
                componentsEnd?.minute
                    = Int(dateformatterMinutes.string(from: datePicker.date))! + Int(dateformatterMinutes.string(from: timePicker.date))!
                components?.second = 00

                
                if hours > 24 {
                    if let day =   componentsEnd?.day {
                        componentsEnd?.day = day + 1
                    }
                }
                
                if let startDay = calendar.date(from: components!), let endDay = calendarEnd.date(from: componentsEnd!) {
                    DataManager.saveOfferDay(recommendation, startDay: startDay, endDay: endDay)
                    
                    let localNotification = UILocalNotification()
                    localNotification.fireDate = calendar.date(from: components!)
                    // TODO:
                    //localNotification.alertTitle = recommendation.name!
                    localNotification.alertBody = "\(recommendation.name!) is now live"
                    localNotification.alertAction = "View List"
                    
                    localNotification.soundName = UILocalNotificationDefaultSoundName
                    UIApplication.shared.scheduleLocalNotification(localNotification)
                    
                }
                
                
            }
            
            
            self.stopLoading({ () -> Void in
                
            })
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "offerDateSavedViewController") as! AddOfferSavedViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        
    }
}
