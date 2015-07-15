//
//  SettingsViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/9/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EditFromCellDelegate {

    var userSettings = [["value" : "User", "type" : "user"] ];
    var userValue = ["INFO","eduardo22i", "eduardoirias@me.com", "Male", "ON", "ON", "" ]

    
    var userImage : UIImageView!
    
    @IBOutlet var tableView: UITableView!
    
    //MARK: View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //animator = Animator(referenceView: self.view)
        
        userSettings = [["value" : "User", "type" : "user"] ];
        userSettings.append(["value" : "User", "type" : "text"])
        userSettings.append(["value" : "Email", "type" : "text"])
        userSettings.append(["value" : "Gender", "type" : "text"])
            
        userSettings.append(["value" : "Location Recommendations", "type" : "switch"])
        userSettings.append(["value" : "Time Recommendations", "type" : "switch"])
        userSettings.append(["value" : "Configure Recommendations", "type" : "open"])
            
        userSettings.append(["value" : "Help", "type" : "open"])
        userSettings.append(["value" : "Terms of Service", "type" : "open"])
        userSettings.append(["value" : "Report a Problem", "type" : "open"])
            
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //tableView.reloadData()
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? UserProfileTableViewCell {
            
            //if (hasBounced != nil) && !hasBounced {
                
                cell.userImageView.alpha = 0
                animator?.bounces(cell.userImageView)
                
                animator?.fadeIn(cell.userNameLabel, delay: 0.1, direction: AnimationDirection.Top, velocity: AnimationVelocity.Medium, alpha: 0.0, uniformScale: 0.0)
                animator?.fadeIn(cell.userUsernameLabel, delay: 0.2, direction: AnimationDirection.Top, velocity: AnimationVelocity.Medium, alpha: 0.0, uniformScale: 0.0)
                hasBounced = true
            //}

        }
    }
    
    override func viewDidLayoutSubviews() {
        if (userImage != nil){
            //animator?.bounces(userImage)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
    
        hasBounced = false

        let indexPath1 = NSIndexPath(forRow: 0, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath1)! as! UserProfileTableViewCell
        
        let pos = CGPointMake( cell.userImageView.center.x,cell.userImageView.center.y)
        animator?.fadeDown (cell.userImageView, delay : 0.0, blockAn : { (ended : Bool, error : NSError?) -> Void in
            cell.userImageView.center = pos
        })
        
        let pos2 = CGPointMake( cell.userNameLabel.center.x,cell.userNameLabel.center.y)
        animator?.fadeDown (cell.userNameLabel, delay : 0.0, blockAn : { (ended : Bool, error : NSError?) -> Void in
            cell.userNameLabel.center = pos2
        })
        
        let pos3 = CGPointMake( cell.userUsernameLabel.center.x,cell.userUsernameLabel.center.y)
        
        animator?.fadeDown (cell.userUsernameLabel, delay : 0.0, blockAn : { (ended : Bool, error : NSError?) -> Void in
            cell.userUsernameLabel.center = pos3
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
        
        if segue.identifier == "editValueFromCell" {
            let vc = segue.destinationViewController as! EditFromCellViewController
            vc.delegate = self
            if let  indexPath = tableView.indexPathForSelectedRow() {
                
                vc.indexPath = indexPath
                vc.key = userSettings[ indexPath.row]["value"]!
                vc.value = userValue[ indexPath.row]
            }
        }
    }

    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return userSettings.count
    }

    /*
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return section == 1 ? "User" : "Recommendations"
        return ""
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ?  0 : 30
    }

    */
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 0 ? 200.0 : 44.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if userSettings[indexPath.row]["type"] == "user" {
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }
        if userSettings[indexPath.row]["type"] == "switch" {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell!
        
        // Configure the cell...
        
        if userSettings[indexPath.row]["type"] == "text" {
            cell = tableView.dequeueReusableCellWithIdentifier("userTableCell", forIndexPath: indexPath) as! UITableViewCell

            cell.textLabel?.text = userSettings[indexPath.row]["value"]
            cell.detailTextLabel?.text = userValue[indexPath.row]

        } else if userSettings[indexPath.row]["type"] == "switch" {
            var cell2 = tableView.dequeueReusableCellWithIdentifier("userTableCellSwitch", forIndexPath: indexPath) as! UserSwitchTableViewCell
            
            cell2.titleLabel.text = userSettings[indexPath.row]["value"]
            
            cell = cell2

            
        } else if userSettings[indexPath.row]["type"] == "user" {
            var cell2 = tableView.dequeueReusableCellWithIdentifier("userProfileCellSwitch", forIndexPath: indexPath) as! UserProfileTableViewCell
            
            //cell2.titleLabel.text = userSettings[indexPath.section][indexPath.row]["value"]
            cell2.userImageView.inCircle()
            cell2.userNameLabel.text = "Eduardo Irías"
            cell2.userUsernameLabel.text = "eduardo22i"
            
            
            
            cell = cell2
            
        } else if userSettings[indexPath.row]["type"] == "open" {
            cell = tableView.dequeueReusableCellWithIdentifier("userTableCellOpen", forIndexPath: indexPath) as! UITableViewCell
            
            cell.textLabel?.text = userSettings[indexPath.row]["value"]
            
        }
        
        return cell
    }
    
    //MARK: EditFromCellDelegate
    
    func didEndEditing(value : String, indexPath : NSIndexPath) {
        userValue[indexPath.row] = value
        tableView.reloadData()
    }
    
}
