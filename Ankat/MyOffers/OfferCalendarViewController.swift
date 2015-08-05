//
//  OfferCalendarViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 8/3/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse

func < (left: NSDate, right: NSDate) -> Bool {
    return left.compare(right) == NSComparisonResult.OrderedAscending
}

func == (left: NSDate, right: NSDate) -> Bool {
    return left.compare(right) == NSComparisonResult.OrderedSame
}

struct DateRange : SequenceType {
    
    var calendar: NSCalendar
    var startDate: NSDate
    var endDate: NSDate
    var stepUnits: NSCalendarUnit
    var stepValue: Int
    
    func generate() -> Generator {
        return Generator(range: self)
    }
    
    struct Generator: GeneratorType {
        
        var range: DateRange
        
        mutating func next() -> NSDate? {
            let nextDate = range.calendar.dateByAddingUnit(range.stepUnits,
                value: range.stepValue,
                toDate: range.startDate,
                options: NSCalendarOptions.allZeros)
            if range.endDate < nextDate! {
                return nil
            }
            else {
                range.startDate = nextDate!
                return nextDate
            }
        }
    }
}


class OfferCalendarViewController: UIViewController, GLCalendarViewDelegate {

    var recommendation : Offer!
    
    @IBOutlet var calendarView : GLCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let reccomendation = recommendation {
            self.title = recommendation.name
        }
        
        self.calendarView.delegate = self
        self.calendarView.showMaginfier = false
        
        let today = NSDate()
        
        self.calendarView.firstDate = GLDateUtils.dateByAddingDays(-120, toDate: today)
        self.calendarView.lastDate = GLDateUtils.dateByAddingDays(120, toDate: today)
       
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            DataManager.findOfferDates(self.recommendation, completionBlock: { (offerDates : [AnyObject]?, error : NSError?) -> Void in
                var ranges : NSMutableArray = NSMutableArray()
                
                if let offerDates = offerDates as? [PFObject] {
                    for offerDate in offerDates {
                        if let date = offerDate["startDate"] as? NSDate {
                            let range = GLCalendarDateRange(beginDate: date, endDate: date)
                            range.editable = false
                            range.backgroundColor = UIColor().appGreenLigthColor()
                            ranges.addObject(range)
                        }
                    }
                    
                    self.calendarView.ranges = ranges
                    
                    self.calendarView.reload()
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.calendarView.scrollToDate(today, animated: false)
                    })
                    
                }
                
            })
            
        })
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destinationViewController as? SelectOfferDayViewController {
            
            let calendar = NSCalendar.currentCalendar()
            var days : [NSDate] = []
            for ranges in calendarView.ranges  {
                if let ranges = ranges as? GLCalendarDateRange {
                    
                    let dateRange = DateRange(calendar: calendar,
                        startDate: ranges.beginDate,
                        endDate: ranges.endDate,
                        stepUnits: NSCalendarUnit.CalendarUnitDay,
                        stepValue: 1)
                    
                    days.append(ranges.beginDate)
                    
                    for date in dateRange {
                        days.append(date)
                    }
                }
            }
            vc.days = days
            vc.recommendation = recommendation
        }
    }
    

    //MARK: GLCalendarViewDelegate
    
    func calenderView(calendarView: GLCalendarView!, rangeToAddWithBeginDate beginDate: NSDate!) -> GLCalendarDateRange! {
        let endDate = GLDateUtils.dateByAddingDays(0, toDate: beginDate)
        let range = GLCalendarDateRange(beginDate: beginDate, endDate: endDate)
        range.editable = true
        range.backgroundColor = UIColor().appGreenColor()
        calendarView.beginToEditRange(range)
        
        return range
    }
    func calenderView(calendarView: GLCalendarView!, canAddRangeWithBeginDate beginDate: NSDate!) -> Bool {
        if beginDate == NSDate()  {
            return true
        }
        if beginDate < NSDate()  {
            return false
        }
        return true
    }
    
    func calenderView(calendarView: GLCalendarView!, canUpdateRange range: GLCalendarDateRange!, toBeginDate beginDate: NSDate!, endDate: NSDate!) -> Bool {
        
        return true
    }
    
    func calenderView(calendarView: GLCalendarView!, beginToEditRange range: GLCalendarDateRange!) {
        if self.calendarView.ranges.containsObject(range) {
            self.calendarView.removeRange(range)
        }
    }
    func calenderView(calendarView: GLCalendarView!, didUpdateRange range: GLCalendarDateRange!, toBeginDate beginDate: NSDate!, endDate: NSDate!) {
        
    }
    func calenderView(calendarView: GLCalendarView!, finishEditRange range: GLCalendarDateRange!, continueEditing: Bool) {
        
    }
}
 