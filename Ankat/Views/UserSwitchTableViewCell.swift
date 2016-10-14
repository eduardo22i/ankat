//
//  UserSwitchTableViewCell.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/9/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate {
    func didSelectSwitchOptionFromCell(_ row : Int, status : Bool)
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func changeSwitchOption(_ sender: UISwitch) {
        if sender.isOn {
            print("On")
            if let delegate = delegate {
                delegate.didSelectSwitchOptionFromCell(index , status : true)
            }
        } else {
            print("Off")
            if let delegate = delegate {
                delegate.didSelectSwitchOptionFromCell(index , status : false)
            }
        }
    }
    
}
