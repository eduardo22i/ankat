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
    case text = 0
    case address = 1
    case price = 2
    case subcategory = 3
    case description = 4
}

class AddOfferInformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EditFromCellDelegate, LongTextEditDelegate, MapFromCellDelegate, AddOfferCategoryDelegate {

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
        decoration1.monsterType = MonsterTypes.monster4
        /*
        if let subcategory = subcategory {
            recommendation.subcategory = subcategory
        }*/
        recommendation.createdBy = PFUser.current()
        tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        animator?.bounces(decoration1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        decoration1.alpha = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "previewNewOffer" {
            let vc = segue.destination as! AddOfferDetailViewController
            vc.recommendation = recommendation
        }
        
    }


    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return offerData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if ((indexPath as NSIndexPath).row == OfferData.text.rawValue) || ((indexPath as NSIndexPath).row == OfferData.price.rawValue)
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "editFromCellViewController") as! EditFromCellViewController
            
            vc.indexPath = indexPath
            vc.key = offerData[ (indexPath as NSIndexPath).row]["value"]!
            
            
            switch ((indexPath as NSIndexPath).row ) {
            case OfferData.text.rawValue:
                if let name = recommendation.name {
                    vc.value = name
                }
                
                break;
            case OfferData.price.rawValue:
                if let price = recommendation.price {
                    vc.value = price.stringValue
                }
                
                vc.keyboardType = UIKeyboardType.decimalPad
                break;
            default:
                break;
            }
            
            vc.delegate = self
            self.show(vc, sender: self)
        } else if (indexPath as NSIndexPath).row == OfferData.address.rawValue {
            
            let vc = storyboard.instantiateViewController(withIdentifier: "mapFromCellViewController") as! MapEditFromCellViewController
            
            vc.delegate = self
            vc.indexPath = indexPath
            vc.key = offerData[ (indexPath as NSIndexPath).row]["value"]!
            

            if let address = recommendation.location {
                vc.currentLocation = CLLocation(latitude: address.latitude, longitude: address.longitude)
            }
            self.show(vc, sender: self)
        } else if (indexPath as NSIndexPath).row == OfferData.description.rawValue {
             let vc = storyboard.instantiateViewController(withIdentifier: "longTextEditFromCellViewController") as! LongTextEditFromCellViewController
            vc.delegate = self
            vc.indexPath = indexPath
            vc.key = offerData[ (indexPath as NSIndexPath).row]["value"]!
            vc.value = recommendation.brief ?? ""
            self.show(vc, sender: self)
        } else if (indexPath as NSIndexPath).row == OfferData.subcategory.rawValue {
            let vc = storyboard.instantiateViewController(withIdentifier: "addOfferCategoryViewController") as! AddOfferCategoryViewController
            vc.delegate = self
            self.show(vc, sender: self)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell!
        
        // Configure the cell...
        
        if offerData[(indexPath as NSIndexPath).row]["type"] == "text" {
            cell = tableView.dequeueReusableCell(withIdentifier: "newOfferCell", for: indexPath) 
            
            cell.textLabel?.text = offerData[(indexPath as NSIndexPath).row]["value"]
            switch ((indexPath as NSIndexPath).row) {
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
                // TODO:
                /*
                if let brief = recommendation.brief {
                    let endIndex =  brief.length < 180 ? brief.length : 160
                    let index: String.Index = advance( brief.startIndex, endIndex )
                    cell.detailTextLabel?.text = brief.substringToIndex(index)
                }
                */
                break;
            default:
                cell.detailTextLabel?.text = ""
                break;
            }
            
        }
        
        return cell
    }
    
    //MARK: EditFromCellDelegate
    
    func didEndEditing(_ value : String, indexPath : IndexPath) {
        
        switch ((indexPath as NSIndexPath).row) {
        case 0:
            recommendation.name = value
            self.title = value
            break;
        case 1:
            recommendation.address = value
            break;
        case 2:
            recommendation.price = value.toDouble() as NSNumber?? ?? 0.0
            break;
        //case 3:
            //recommendation.price = value.toDouble() ?? 0.0
        //    break;
        case 4:
            recommendation.brief = value
            break;
        default:
            break;
        }
        
        tableView.reloadData()
    }
    
    //MARK: MapFromCellDelegate
    
    func didEndSelectingLocation(_ location : CLLocation, value: String, indexPath: IndexPath) {
        recommendation.location = PFGeoPoint(latitude: location.coordinate.latitude , longitude: location.coordinate.longitude)
        recommendation.address = value
        tableView.reloadData()
    }
    
    //MARK: LongTextEditFromCellViewController
    
    func didEndEditingLongText(_ value: String, indexPath: IndexPath) {
        recommendation.brief = value
        tableView.reloadData()
    }
    
    //MARK: AddOfferCategoryDelegate
    func didSelectedSubcategory(_ subcategory: Subcategory) {
        recommendation.subcategory = subcategory
        tableView.reloadData()
    }
}
