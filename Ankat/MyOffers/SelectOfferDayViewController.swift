//
//  SelectOfferDayViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/31/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

class SelectOfferDayViewController: UIViewController {

    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        
        datePicker.minimumDate = NSDate()
    }
}
