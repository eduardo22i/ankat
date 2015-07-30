//
//  UserSwitchTableViewCell.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/9/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate {
    func didSelectSwitchOptionFromCell(row : Int, status : Bool)
}

class UserSwitchTableViewCell: UITableViewCell {

    var delegate : SwitchTableViewCellDelegate!
    var index = 0
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var switchButton: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func changeSwitchOption(sender: UISwitch) {
        if sender.on {
            println("On")
            if let delegate = delegate {
                delegate.didSelectSwitchOptionFromCell(index , status : true)
            }
        } else {
            println("Off")
            if let delegate = delegate {
                delegate.didSelectSwitchOptionFromCell(index , status : false)
            }
        }
    }
    
}
