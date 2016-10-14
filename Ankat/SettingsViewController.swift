//
//  SettingsViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/9/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EditFromCellDelegate {

    var user : PFUser!
    var userSettings : [ NSDictionary ] = [ ]
    var userSettings2 : [ NSDictionary ] = [ ]
    var userSettings3 : [ NSDictionary ] = [ ]

    var userValue = ["INFO"," ", " ", "ON", "ON", "" ]

    var userImage : UIImage!
    
    var updateProfile = false
    
    @IBOutlet var tableView: UITableView!
    
    //MARK: View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        getSettingsTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //tableView.reloadData()
        user = PFUser.current()
        
        if user != nil {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? UserProfileTableViewCell {
                
                //if (hasBounced != nil) && !hasBounced {
                
                cell.userImageView.alpha = 0
                animator?.bounces(cell.userImageView)
                
                animator?.fadeIn(cell.userNameLabel, delay: 0.1, direction: AnimationDirection.top, velocity: AnimationVelocity.medium, alpha: 0.0, uniformScale: 0.0)
                animator?.fadeIn(cell.userUsernameLabel, delay: 0.2, direction: AnimationDirection.top, velocity: AnimationVelocity.medium, alpha: 0.0, uniformScale: 0.0)
                hasBounced = true
                //}
                
            }
            
            
            if userSettings.count == 0 {
            
                getSettingsTable ()
                self.tableView.reloadData()
            } else {
                if updateProfile {
                    user["name"] = self.userValue[1]
                    user["email"] = self.userValue[2]
                    user.saveInBackground()
                }
                updateProfile = false
            }
        } else {
            showLogin ()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if user != nil {
            hasBounced = false
            
            let indexPath1 = IndexPath(row: 0, section: 0)
            let cell = tableView.cellForRow(at: indexPath1)! as! UserProfileTableViewCell
            
            let pos = CGPoint( x: cell.userImageView.center.x,y: cell.userImageView.center.y)
            animator?.fadeDown (cell.userImageView, delay : 0.0, blockAn : { (ended : Bool, error : NSError?) -> Void in
                cell.userImageView.center = pos
            })
            
            let pos2 = CGPoint( x: cell.userNameLabel.center.x,y: cell.userNameLabel.center.y)
            animator?.fadeDown (cell.userNameLabel, delay : 0.0, blockAn : { (ended : Bool, error : NSError?) -> Void in
                cell.userNameLabel.center = pos2
            })
            
            let pos3 = CGPoint( x: cell.userUsernameLabel.center.x,y: cell.userUsernameLabel.center.y)
            
            animator?.fadeDown (cell.userUsernameLabel, delay : 0.0, blockAn : { (ended : Bool, error : NSError?) -> Void in
                cell.userUsernameLabel.center = pos3
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getSettingsTable () {
        if user != nil {
            userSettings.append(["value" : "User", "type" : "user"])
            userSettings.append(["value" : "Name", "type" : "text"])
            userSettings.append(["value" : "Email", "type" : "text"])
            //userSettings.append(["value" : "Gender", "type" : "text"])
            
            userSettings2.append(["value" : "Location Recommendations", "type" : "switch"])
            userSettings2.append(["value" : "Time Recommendations", "type" : "switch"])
            userSettings2.append(["value" : "Configure Recommendations", "type" : "openPref"])
            
            userSettings3.append(["value" : "Help", "type" : "open"])
            userSettings3.append(["value" : "Terms of Service", "type" : "open"])
            userSettings3.append(["value" : "Report a Problem", "type" : "open"])
            
            
            if let name = user!["name"] as? String {
                self.userValue[1] = name
            }
            
            if let email = user!["email"] as? String {
                self.userValue[2] = email
            }
            
            
            if let userP = PFUser.current()  {
                userP.downloadUserImage({ (data : Data?, error : Error?) -> Void in
                    self.userImage = UIImage(data: data!)!
                    self.tableView.reloadData()
                })
            }
            
        }
    }
    
    func showLogin () {
        self.tabBarController?.selectedIndex = 0
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "loginNavViewController") as! UINavigationController
        self.present(viewController, animated: true, completion: { () -> Void in
            
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "editValueFromCell" {
            let vc = segue.destination as! EditFromCellViewController
            vc.delegate = self
            if let  indexPath = tableView.indexPathForSelectedRow {
                
                vc.indexPath = indexPath
                vc.key = userSettings[ (indexPath as NSIndexPath).row]["value"]! as! String
                vc.value = userValue[ (indexPath as NSIndexPath).row]
            }
            updateProfile = true
        }
    }

    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if section == 0 {
            
        } else if section == 1 {
            return userSettings2.count
        } else if section == 2 {
            return userSettings3.count
        }
        return userSettings.count
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Recommendations" : ( section == 2 ? "Information & Support" : "" )
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        /* 
        UILabel *myLabel = [[UILabel alloc] init];
        myLabel.frame = CGRectMake(20, 8, 320, 20);
        myLabel.font = [UIFont boldSystemFontOfSize:18];
        myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
        
        UIView *headerView = [[UIView alloc] init];
        [headerView addSubview:myLabel];
        
        return headerView;
        */
        let label = UILabel(frame: CGRect(x: 20, y: 25, width: self.view.frame.size.width, height: 28))
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.lightGray
        
        label.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        
        let headerView = UIView()
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ?  0 : 60
    }


    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((indexPath as NSIndexPath).row == 0 && (indexPath as NSIndexPath).section == 0) ? 200.0 : 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var setting : NSDictionary = NSDictionary()
        setting = userSettings[(indexPath as NSIndexPath).row]
        
        if (setting["type"] as! String)  == "user" {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        //if userSettings[indexPath.row]["type"] == "switch" {
            tableView.deselectRow(at: indexPath, animated: true)
        //}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell!
        
        // Configure the cell...
        var setting : NSDictionary = NSDictionary()
        setting = userSettings[(indexPath as NSIndexPath).row]
        let section = (indexPath as NSIndexPath).section
        
        if section == 0 {
             setting = userSettings[(indexPath as NSIndexPath).row]
        } else if section == 1 {
             setting = userSettings2[(indexPath as NSIndexPath).row]
        } else if section == 2 {
             setting = userSettings3[(indexPath as NSIndexPath).row]
        }
        
        if (setting["type"] as! String) == "text" {
            cell = tableView.dequeueReusableCell(withIdentifier: "userTableCell", for: indexPath) 

            cell.textLabel?.text = setting["value"] as? String
            cell.detailTextLabel?.text = userValue[(indexPath as NSIndexPath).row]

        } else if (setting["type"] as! String) == "switch" {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "userTableCellSwitch", for: indexPath) as! UserSwitchTableViewCell
            
            cell2.titleLabel.text = setting["value"] as? String
            
            
            if (indexPath as NSIndexPath).row == 0 {
                cell2.switchButton.isEnabled = false
                cell2.switchButton.setOn(false, animated: false)
                
                let defaults = UserDefaults.standard
                if defaults.bool(forKey: "userLocation") {
                    cell2.switchButton.setOn(true, animated: true)
                }
                
            }
            cell = cell2

            
        } else if (setting["type"] as! String) == "user" {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "userProfileCellSwitch", for: indexPath) as! UserProfileTableViewCell
            
            //cell2.titleLabel.text = userSettings[indexPath.section][indexPath.row]["value"]
            cell2.userImageView.inCircle()
            //cell2.userNameLabel.text = "Eduardo Irías"
            
            cell2.userImageView.image = self.userImage
            
            cell2.userNameLabel.text = self.userValue[1]
            cell2.userUsernameLabel.text = self.userValue[2]

            cell = cell2
            
        } else if (setting["type"] as! String) == "open" {
            cell =
                tableView.dequeueReusableCell(withIdentifier: "userTableCellOpen", for: indexPath) 
            
            cell.textLabel?.text = setting["value"] as? String
            
        } else if (setting["type"] as! String) == "openPref"  {
            cell = tableView.dequeueReusableCell(withIdentifier: "userTableCellPreferencesOpen", for: indexPath) 
            
            cell.textLabel?.text = setting["value"] as? String

        }
        
        return cell
    }
    
    //MARK: EditFromCellDelegate
    
    func didEndEditing(_ value : String, indexPath : IndexPath) {
        userValue[(indexPath as NSIndexPath).row] = value
        tableView.reloadData()
    }
    
    //MARK: Actions
    
    @IBAction func logOutAction () {
        PFUser.logOut()
        user = nil
        userSettings = [ ]
        userSettings2 = [ ]
        userSettings3 = [ ]
        
        self.tableView.reloadData()
        
        showLogin ()
    }

    
}
