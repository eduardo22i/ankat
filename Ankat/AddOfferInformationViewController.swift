//
//  AddOfferInformationViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/10/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

class AddOfferInformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EditFromCellDelegate {

    var offerData = [["value" : "Name", "type" : "text"] ]
    var recommendation = Recommendation() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet var decoration1: FrameAnimations!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        offerData.append(["value" : "Address", "type" : "text"])
        offerData.append(["value" : "Price", "type" : "text"])
        offerData.append(["value" : "Description", "type" : "text"])
        
        decoration1.monsterType = MonsterTypes.Monster4
        
    }

    override func viewDidAppear(animated: Bool) {
        
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
        
        if segue.identifier == "previewNewOffer" {
            let vc = segue.destinationViewController as! OfferDetailViewController
            vc.recommendation = recommendation
        }
        
    }


    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return offerData.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("editFromCellViewController") as! EditFromCellViewController
        vc.delegate = self
        
        vc.indexPath = indexPath
        vc.key = offerData[ indexPath.row]["value"]!

        
        switch (indexPath.row) {
        case 0:
            vc.value = recommendation.title
            break;
        case 1:
            vc.value = recommendation.address
            break;
        case 2:
            vc.value = "\(recommendation.price)"
            vc.keyboardType = UIKeyboardType.DecimalPad
            break;
        case 3:
            vc.value = recommendation.brief
            break;
        default:
            break;
        }
        
        self.showViewController(vc, sender: self)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell!
        
        // Configure the cell...
        
        if offerData[indexPath.row]["type"] == "text" {
            cell = tableView.dequeueReusableCellWithIdentifier("newOfferCell", forIndexPath: indexPath) as! UITableViewCell
            
            cell.textLabel?.text = offerData[indexPath.row]["value"]
            switch (indexPath.row) {
            case 0:
                cell.detailTextLabel?.text = recommendation.title
                break;
            case 1:
                cell.detailTextLabel?.text = recommendation.address
                break;
            case 2:
                cell.detailTextLabel?.text = "\(recommendation.price)"
                break;
            case 3:
                cell.detailTextLabel?.text = " "
                break;
            default:
                cell.detailTextLabel?.text = ""
                break;
            }
            
        }
        
        return cell
    }
    
    //MARK: EditFromCellDelegate
    
    func didEndEditing(value : String, indexPath : NSIndexPath) {
        
        switch (indexPath.row) {
        case 0:
            recommendation.title = value
            self.title = value
            break;
        case 1:
            recommendation.address = value
            break;
        case 2:
            recommendation.price = value.toDouble() ?? 0.0
            break;
        case 3:
            recommendation.brief = value
            break;
        default:
            break;
        }
        
        tableView.reloadData()
    }
    
}
