//
//  PersonalizedPreferencesViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/27/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

class PersonalizedPreferencesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchTableViewCellDelegate {

    var preferences : [Preference] = [] {
        didSet {
            var cont = 0
            for preference in preferences {
                DataManager.findUserPreference(user!, preference: preference) { (results : [Any]?, error : Error?) -> Void in
                    if results?.count > 0 {
                        self.selectedPreferences.add(preference)
                    }
                    
                    cont += 1
                    if cont == self.preferences.count {
                        self.tableView.reloadData()
                    }
                    self.stopLoading()
                }
                
                
            }
            
            
        }
    }
    let user = PFUser.current()

    var selectedPreferences : NSMutableSet = NSMutableSet()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.startLoading()
        
        DataManager.getPreferences(nil, completionBlock: { (results : [Any]?, error : Error?) -> Void in
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userTableCellSwitch", for: indexPath) as! UserSwitchTableViewCell
        
        let preference = preferences[(indexPath as NSIndexPath).row]
        
        cell.delegate = self
        cell.index = (indexPath as NSIndexPath).row
        // Configure the cell...
        cell.titleLabel?.text = preference.caption
        
        cell.switchButton.setOn(false, animated: false)
        
        for selectPreference in selectedPreferences {
            if (selectPreference as AnyObject).objectId! == preference.objectId! {
                cell.switchButton.setOn(true, animated: true)
            }
        }
        
        return cell
    }
    
    //MARK: SwitchTableViewCellDelegate
    
    func didSelectSwitchOptionFromCell(_ row: Int, status: Bool) {
        if status {
            let preference = preferences[row]
            DataManager.saveUserPreference(user!, preference: preference, completionBlock: { (ended : Bool, error : Error?) -> Void in
                
            })
            
        } else {
            
            let preference = preferences[row]
            DataManager.deleteUserPreference(user!, preference: preference, completionBlock: { () -> Void in
                
            })
            
        }
    }
    
    @IBAction func doneAction (_ sender : AnyObject) {
        var didDismiss = false
        let defaults = UserDefaults.standard
        let onboarding = defaults.bool(forKey: "isOnBoarding") 
        if  (onboarding) {
            didDismiss = true

            defaults.set(false, forKey: "isOnBoarding")
            defaults.synchronize()
            
            self.dismiss(animated: true, completion: { () -> Void in
                self.showInformation("Welcome To Ankat", icons : [UIImage(named: "Monster 4 A")!, UIImage(named: "Monster 4 B")!])
            })
        }
        
        if !didDismiss {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
