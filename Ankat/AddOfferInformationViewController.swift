//
//  AddOfferInformationViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/10/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse

enum OfferData : Int {
    case Text = 0
    case Address = 1
    case Price = 2
    case Subcategory = 3
    case Description = 4
}

class AddOfferInformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EditFromCellDelegate, AddOfferCategoryDelegate {

    var offerData = [["value" : "Name", "type" : "text"] ]
    var subcategory : Subcategory!
    var recommendation = Offer() /*{
        didSet {
            tableView.reloadData()
        }
    }
*/
    
    @IBOutlet var decoration1: FrameAnimations!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        offerData.append(["value" : "Address", "type" : "text"])
        offerData.append(["value" : "Price", "type" : "text"])
        offerData.append(["value" : "Subcategory", "type" : "text"])
        offerData.append(["value" : "Description", "type" : "text"])
        
        decoration1.alpha = 0
        decoration1.monsterType = MonsterTypes.Monster4
        /*
        if let subcategory = subcategory {
            recommendation.subcategory = subcategory
        }*/
        recommendation.createdBy = PFUser.currentUser()
        tableView.reloadData()
    }

    override func viewDidAppear(animated: Bool) {
        animator?.bounces(decoration1)
    }
    
    override func viewWillDisappear(animated: Bool) {
        decoration1.alpha = 0
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
            let vc = segue.destinationViewController as! AddOfferDetailViewController
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
        
        if indexPath.row != OfferData.Subcategory.rawValue {
            let vc = storyboard.instantiateViewControllerWithIdentifier("editFromCellViewController") as! EditFromCellViewController
            
            vc.indexPath = indexPath
            vc.key = offerData[ indexPath.row]["value"]!
            
            
            switch (indexPath.row ) {
            case OfferData.Text.rawValue:
                if let address = recommendation.name {
                    vc.value = recommendation.name! ?? ""
                }
                
                break;
            case OfferData.Address.rawValue:
                if let address = recommendation.address {
                    vc.value = recommendation.address! ?? ""
                }
                break;
            case OfferData.Price.rawValue:
                if let address = recommendation.price {
                    vc.value = "\(recommendation.price)" ?? ""
                }
                
                vc.keyboardType = UIKeyboardType.DecimalPad
                break;
                /*
                if let subcategory = recommendation.subcategory {
                vc.value = subcategory.name
                }
                */
            case OfferData.Description.rawValue:
                if let address = recommendation.brief {
                    vc.value = recommendation.brief! ?? ""
                }
                break;
            default:
                break;
            }
            
            vc.delegate = self
            self.showViewController(vc, sender: self)
            
        } else {
             let vc = storyboard.instantiateViewControllerWithIdentifier("addOfferCategoryViewController") as! AddOfferCategoryViewController
            vc.delegate = self
            self.showViewController(vc, sender: self)
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell!
        
        // Configure the cell...
        
        if offerData[indexPath.row]["type"] == "text" {
            cell = tableView.dequeueReusableCellWithIdentifier("newOfferCell", forIndexPath: indexPath) as! UITableViewCell
            
            cell.textLabel?.text = offerData[indexPath.row]["value"]
            switch (indexPath.row) {
            case 0:
                cell.detailTextLabel?.text = recommendation.name
                break;
            case 1:
                cell.detailTextLabel?.text = recommendation.address
                break;
            case 2:
                cell.detailTextLabel?.text = " "
                if let price = recommendation.price {
                    cell.detailTextLabel?.text = "\(price)"
                }
                break;
            case 3:
                cell.detailTextLabel?.text = " "
                if let subcategory = recommendation.subcategory {
                    subcategory.fetchIfNeeded()
                    cell.detailTextLabel?.text = subcategory.name
                } 
                break;
            case 4:
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
            recommendation.name = value
            self.title = value
            break;
        case 1:
            recommendation.address = value
            break;
        case 2:
            recommendation.price = value.toDouble() ?? 0.0
            break;
        case 3:
            //recommendation.price = value.toDouble() ?? 0.0
            break;
        case 4:
            recommendation.brief = value
            break;
        default:
            break;
        }
        
        tableView.reloadData()
    }
    
    //MARK: AddOfferCategoryDelegate
    func didSelectedSubcategory(subcategory: Subcategory) {
        recommendation.subcategory = subcategory
        tableView.reloadData()
    }
}
