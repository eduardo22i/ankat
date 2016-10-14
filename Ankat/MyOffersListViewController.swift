//
//  MyOffersListViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/6/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse

class MyOffersListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, OfferCalendarShowDelegate {

    var user : PFUser!
    var offers : NSMutableArray = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var monsterAnimation: FrameAnimations!
    @IBOutlet var firstOfferView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.navigationController?.transparent()
        
        monsterAnimation.alpha = 0
        monsterAnimation.monsterType = MonsterTypes.monster1
        monsterAnimation.originalCenter = CGPoint(x: self.view.frame.width/2,  y: monsterAnimation.center.y)
        
        
        //tableView.alpha = 0
        //monsterAnimation.alpha = 0
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        firstOfferView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {

        user = PFUser.current()
        
        if user != nil {
            self.startLoading()
            
            if let user = PFUser.current() {
                DataManager.getOffers( ["status" : 1, "createdBy" : user ] , completionBlock: { ( objects : [Any]?, error: Error?) -> Void in
                    self.offers = NSMutableArray(array: objects!)
                    if self.offers.count == 0 {
                        self.firstOfferView.alpha = 1
                    }
                    self.stopLoading()
                })
            }
        } else {
            showLogin ()
        }
        
        //tableView.reloadData()
        /*
        if let cells = tableView.visibleCells() as? [OfferTableViewCell] {
        for cell in cells {
        animator?.fadeIn(cell, direction: AnimationDirection.Top)
        }
        }
        */
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /*
        if let cells = tableView.visibleCells() as? [OfferTableViewCell] {
            for cell in cells {
                //animator?.fadeDown(cell, delay: 0.0)
                cell.alpha = 0
            }
        }
        */
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segue
    
    func showLogin () {
        self.tabBarController?.selectedIndex = 0
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "loginNavViewController") as! UINavigationController
        self.present(viewController, animated: true, completion: { () -> Void in
            
        })
    }
    
   override  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if segue.identifier == "showMyOffer" {
            let indexPath =  tableView.indexPathForSelectedRow!
            let vc = segue.destination as? OfferDetailViewController
            if let offer = offers.object(at: (indexPath as NSIndexPath).row) as? Offer {
                offer.fetchIfNeeded()
                vc?.recommendation = offer
            }
        } else if segue.identifier == "selectedDayForOfferViewController" {
            //let indexPath =  tableView.indexPathForSelectedRow()
            
            let vc = segue.destination as? OfferCalendarViewController
            if let offer = offers.object(at: 0) as? Offer {
                offer.fetchIfNeeded()
                vc?.recommendation = offer
            }

        }
    }

    
    // MARK: - Scroll
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        monsterAnimation.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        monsterAnimation.scrollViewWillBeginDragging(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let indexPath = IndexPath(row: 0, section: 0)
        animator?.bounces(tableView.cellForRow(at: indexPath)!, delay: 0.1)
        
        let indexPath1 = IndexPath(row: 1, section: 0)
        animator?.bounces(tableView.cellForRow(at: indexPath1)!, delay: 0.2)
    }
    
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if offers.count == 0 {
            tableView.alpha = 0
            monsterAnimation.alpha = 0
            firstOfferView.alpha = 1
        } else {
            tableView.alpha = 1
            //monsterAnimation.alpha = 1
            firstOfferView.alpha = 0
        }
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "offerCell", for: indexPath) as! OfferTableViewCell
        
        cell.delegate = self
        cell.showIndex = (indexPath as NSIndexPath).row
        
        // Configure the cell...
        let offer = offers[(indexPath as NSIndexPath).row] as! Offer
        
        
        cell.offerNameLabel.text = offer.name
        cell.offerAddressLabel.text = offer.address
        offer.downloadImage(cell.offerImage)
        
        cell.alpha = 0
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //animator?.bounces(cell, delay : Double(indexPath.row/10))
    }
    /*
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.width + 10 + 21 + 10 + 21 + 10
    }
    */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        /*
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let offerDetailVC = storyboard.instantiateViewControllerWithIdentifier("offerDetailViewController") as! OfferDetailViewController
        offerDetailVC.recommendation = offers.objectAtIndex(indexPath.row) as! Offer
        offerDetailVC.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        offerDetailVC.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(offerDetailVC, animated: true) { () -> Void in
        }
        */
    }

    //MARK: Segmented Control
    
    @IBAction func segmentedControllerAction(_ sender: UISegmentedControl) {
       
        
        
        switch sender.selectedSegmentIndex {
            
        case 0:
            
            DataManager.getOffers( ["status" : 1] , completionBlock: { ( objects : [Any]?, error: Error?) -> Void in
                self.offers = NSMutableArray(array: objects!)
            })
            
        case 1:
            
            DataManager.getOffers( ["status" : 2] , completionBlock: { ( objects : [Any]?, error: Error?) -> Void in
                self.offers = NSMutableArray(array: objects!)
            })

            
        case 2:
            
            DataManager.getOffers( ["status" : 3] , completionBlock: { ( objects : [Any]?, error: Error?) -> Void in
                self.offers = NSMutableArray(array: objects!)
            })
            
        default:
            break;
            
        }
    }
    
    //MARK : OfferCalendarShowDelegate
    
    func showCalendar(_ index: Int) {
     //
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "offerCalendarViewController") as! OfferCalendarViewController
        
        if let offer = offers.object(at: index) as? Offer {
            offer.fetchIfNeeded()
            vc.recommendation = offer
            
            self.navigationController?.pushViewController(vc, animated: true)

        }
        
    }
    
    //MARK : Actions
    
    @IBAction func doneAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
    }
    
}

