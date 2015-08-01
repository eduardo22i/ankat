//
//  PersonalizedPreferencesViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/27/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse
class PersonalizedPreferencesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchTableViewCellDelegate {

    var preferences : [Preference] = [] {
        didSet {
            var cont = 0
            for preference in preferences {
                DataManager.findUserPreference(user!, preference: preference) { (results : [AnyObject]?, error : NSError?) -> Void in
                    if results?.count > 0 {
                        self.selectedPreferences.addObject(preference)
                    }
                    
                    cont++
                    if cont == self.preferences.count {
                        self.tableView.reloadData()
                    }
                    self.stopLoading()
                }
                
                
            }
            
            
        }
    }
    let user = PFUser.currentUser()

    var selectedPreferences : NSMutableSet = NSMutableSet()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.startLoading()
        
        DataManager.getPreferences(nil, completionBlock: { (results : [AnyObject]?, error :NSError?) -> Void in
            if let preferences = results as? [Preference] {
                self.preferences = preferences
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return preferences.count
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
        return 44.0
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("userTableCellSwitch", forIndexPath: indexPath) as! UserSwitchTableViewCell
        
        let preference = preferences[indexPath.row]
        
        cell.delegate = self
        cell.index = indexPath.row
        // Configure the cell...
        cell.titleLabel?.text = preference.caption
        
        cell.switchButton.setOn(false, animated: false)
        
        for selectPreference in selectedPreferences {
            if selectPreference.objectId! == preference.objectId! {
                cell.switchButton.setOn(true, animated: true)
            }
        }
        
        return cell
    }
    
    //MARK: SwitchTableViewCellDelegate
    
    func didSelectSwitchOptionFromCell(row: Int, status: Bool) {
        if status {
            let preference = preferences[row]
            DataManager.saveUserPreference(user!, preference: preference, completionBlock: { (ended : Bool, error : NSError?) -> Void in
                
            })
            
        } else {
            
            let preference = preferences[row]
            DataManager.deleteUserPreference(user!, preference: preference, completionBlock: { () -> Void in
                
            })
            
        }
        println (preferences[row])
        println (status)
    }
}
