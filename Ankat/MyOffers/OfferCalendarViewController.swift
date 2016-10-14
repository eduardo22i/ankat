//
//  OfferCalendarViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 8/3/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse

func < (left: Date, right: Date) -> Bool {
    return left.compare(right) == ComparisonResult.orderedAscending
}

func == (left: Date, right: Date) -> Bool {
    return left.compare(right) == ComparisonResult.orderedSame
}

struct DateRange : Sequence {
    
    var calendar: Calendar
    var startDate: Date
    var endDate: Date
    var stepUnits: NSCalendar.Unit
    var stepValue: Int
    
    func makeIterator() -> Iterator {
        return Iterator(range: self)
    }
    
    struct Iterator: IteratorProtocol {
        
        var range: DateRange
        
        mutating func next() -> Date? {
            let nextDate = (range.calendar as NSCalendar).date(byAdding: range.stepUnits,
                value: range.stepValue,
                to: range.startDate,
                options: NSCalendar.Options())
            if range.endDate.compare(nextDate!) == .orderedAscending {
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
        
        self.title = recommendation.name
        
        self.calendarView.delegate = self
        self.calendarView.showMaginfier = false
        
        let today = Date()
        
        self.calendarView.firstDate = GLDateUtils.date(byAddingDays: -120, to: today)
        self.calendarView.lastDate = GLDateUtils.date(byAddingDays: 120, to: today)
       
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: { () -> Void in
            DataManager.findOfferDates(self.recommendation, completionBlock: { (offerDates : [Any]?, error: Error?) in
                
                let ranges : NSMutableArray = NSMutableArray()
                
                if let offerDates = offerDates as? [PFObject] {
                    for offerDate in offerDates {
                        if let date = offerDate["startDate"] as? Date, let range = GLCalendarDateRange(begin: date, end: date) {
                            range.editable = false
                            range.backgroundColor = UIColor().appGreenLigthColor()
                            ranges.add(range)
                        }
                    }
                    
                    self.calendarView.ranges = ranges
                    
                    self.calendarView.reload()
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.calendarView.scroll(to: today, animated: false)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? SelectOfferDayViewController {
            
            let calendar = Calendar.current
            var days : [Date] = []
            for ranges in calendarView.ranges  {
                if let ranges = ranges as? GLCalendarDateRange {
                    
                    let dateRange = DateRange(calendar: calendar,
                        startDate: ranges.beginDate,
                        endDate: ranges.endDate,
                        stepUnits: .day,
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
    
    func calenderView(_ calendarView: GLCalendarView!, rangeToAddWithBegin beginDate: Date!) -> GLCalendarDateRange! {
        let endDate = GLDateUtils.date(byAddingDays: 0, to: beginDate)
        let range = GLCalendarDateRange(begin: beginDate, end: endDate)
        range?.editable = true
        range?.backgroundColor = UIColor().appGreenColor()
        calendarView.begin(toEdit: range)
        
        return range
    }
    func calenderView(_ calendarView: GLCalendarView!, canAddRangeWithBegin beginDate: Date!) -> Bool {
        if beginDate.compare(Date()) == .orderedSame  {
            return true
        }
        if beginDate.compare(Date()) == .orderedDescending  {
            return false
        }
        return true
    }
    
    func calenderView(_ calendarView: GLCalendarView!, canUpdate range: GLCalendarDateRange!, toBegin beginDate: Date!, end endDate: Date!) -> Bool {
        
        return true
    }
    
    func calenderView(_ calendarView: GLCalendarView!, beginToEdit range: GLCalendarDateRange!) {
        if self.calendarView.ranges.contains(range) {
            self.calendarView.removeRange(range)
        }
    }
    func calenderView(_ calendarView: GLCalendarView!, didUpdate range: GLCalendarDateRange!, toBegin beginDate: Date!, end endDate: Date!) {
        
    }
    func calenderView(_ calendarView: GLCalendarView!, finishEdit range: GLCalendarDateRange!, continueEditing: Bool) {
        
    }
}
 
