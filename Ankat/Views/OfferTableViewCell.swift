//
//  OfferTableViewCell.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/9/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

protocol OfferCalendarShowDelegate {
    func showCalendar (index : Int)
}

class OfferTableViewCell: UITableViewCell {

    var delegate : OfferCalendarShowDelegate!
    
    @IBOutlet var offerImage: UIImageView!
    @IBOutlet var offerNameLabel: UILabel!
    @IBOutlet var offerAddressLabel: UILabel!
    
    var showIndex : Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func showCalendar () {
        if let delegate = delegate, index = showIndex {
            delegate.showCalendar(index)
        }
    }

}
