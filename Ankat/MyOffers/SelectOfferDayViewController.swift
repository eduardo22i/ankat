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
        self.title = recommendation.name
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
                let components = calendar?.components( .Calendar, fromDate: date)
                
                components?.day = Int(dateformatterDay.stringFromDate(date))!
                components?.month = Int(dateformatterMonth.stringFromDate(date))!
                components?.year = Int(dateformatterYear.stringFromDate(date))!
                
                components?.hour = Int(dateformatterHour.stringFromDate(datePicker.date))!
                components?.minute = Int(dateformatterMinutes.stringFromDate(datePicker.date))!
                components?.second = 00
                
                
                //End date
                let dateformatterHour2 = NSDateFormatter()
                dateformatterHour2.dateFormat = "HH"
                
                
                let calendarEnd = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
                let componentsEnd = calendar?.components( .Calendar, fromDate: date )
                
                componentsEnd?.day = Int(dateformatterDay.stringFromDate(date))!
                componentsEnd?.month = Int(dateformatterMonth.stringFromDate(date))!
                componentsEnd?.year = Int(dateformatterYear.stringFromDate(date))!
                
                let hours = Int(dateformatterHour2.stringFromDate(datePicker.date))! + Int(dateformatterHour2.stringFromDate(timePicker.date))!
                
                componentsEnd?.hour = hours % 24
                
                componentsEnd?.minute
                    = Int(dateformatterMinutes.stringFromDate(datePicker.date))! + Int(dateformatterMinutes.stringFromDate(timePicker.date))!
                components?.second = 00

                
                if hours > 24 {
                    if let day =   componentsEnd?.day {
                        componentsEnd?.day = day + 1
                    }
                }
                
                if let startDay = calendar?.dateFromComponents(components!), let endDay = calendarEnd?.dateFromComponents(componentsEnd!) {
                    DataManager.saveOfferDay(recommendation, startDay: startDay, endDay: endDay)
                    
                    let localNotification = UILocalNotification()
                    localNotification.fireDate = calendar?.dateFromComponents(components!)
                    // TODO:
                    //localNotification.alertTitle = recommendation.name!
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
