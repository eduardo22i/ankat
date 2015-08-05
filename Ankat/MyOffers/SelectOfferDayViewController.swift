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
    var days : [NSDate] = []
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        if let reccomendation = recommendation {
            self.title = recommendation.name
        }
    }
    
    func dateSeletec () {
        
        
    }
    
    
    
    @IBAction  func dateSelectAction (sender : AnyObject ) {
        if let recommendation = recommendation {
            
            //self.startLoading("Saving")
            
            for date in days {
                //let date = days[0]
                
                let dateformatterDay = NSDateFormatter()
                dateformatterDay.dateFormat = "dd"
                let dateformatterMonth = NSDateFormatter()
                dateformatterMonth.dateFormat = "MM"
                let dateformatterYear = NSDateFormatter()
                dateformatterYear.dateFormat = "YYYY"
                
                let dateformatterHour = NSDateFormatter()
                dateformatterHour.dateFormat = "h"
                
                let dateformatterMinutes = NSDateFormatter()
                dateformatterMinutes.dateFormat = "mm"
                
                
                let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
                let components = calendar?.components( NSCalendarUnit.CalendarUnitCalendar, fromDate: date)
                
                components?.day = dateformatterDay.stringFromDate(date).toInt()!
                components?.month = dateformatterMonth.stringFromDate(date).toInt()!
                components?.year = dateformatterYear.stringFromDate(date).toInt()!
                
                components?.hour = dateformatterHour.stringFromDate(datePicker.date).toInt()!
                components?.minute = dateformatterMinutes.stringFromDate(datePicker.date).toInt()!
                components?.second = 00
                
                
                //End date
                let dateformatterHour2 = NSDateFormatter()
                dateformatterHour2.dateFormat = "HH"
                
                
                
                
                let dateEnd = calendar?.dateFromComponents(components!)
                
                let calendarEnd = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
                let componentsEnd = calendar?.components( NSCalendarUnit.CalendarUnitCalendar, fromDate: date )
                
                componentsEnd?.day = dateformatterDay.stringFromDate(date).toInt()!
                componentsEnd?.month = dateformatterMonth.stringFromDate(date).toInt()!
                componentsEnd?.year = dateformatterYear.stringFromDate(date).toInt()!
                
                var hours = dateformatterHour2.stringFromDate(datePicker.date).toInt()! + dateformatterHour2.stringFromDate(timePicker.date).toInt()!
                
                componentsEnd?.hour = hours % 24
                
                componentsEnd?.minute = dateformatterMinutes.stringFromDate(datePicker.date).toInt()! + dateformatterMinutes.stringFromDate(timePicker.date).toInt()!
                components?.second = 00

                
                if hours > 24 {
                    if let day =   componentsEnd?.day {
                        componentsEnd?.day = day + 1
                    }
                }
                
                if let startDay = calendar?.dateFromComponents(components!), endDay = calendarEnd?.dateFromComponents(componentsEnd!) {
                    DataManager.saveOfferDay(recommendation, startDay: startDay, endDay: endDay)
                    
                    var localNotification = UILocalNotification()
                    localNotification.fireDate = calendar?.dateFromComponents(components!)
                    localNotification.alertTitle = recommendation.name!
                    localNotification.alertBody = "\(recommendation.name!) is now live"
                    localNotification.alertAction = "View List"
                    
                    localNotification.soundName = UILocalNotificationDefaultSoundName
                    UIApplication.sharedApplication().scheduleLocalNotification(localNotification)

                }
                
                
            }
            
            
            self.stopLoading({ () -> Void in
                
            })
            
            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("offerDateSavedViewController") as! AddOfferSavedViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        
    }
}
