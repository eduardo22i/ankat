//
//  OffersListViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/6/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

class OffersListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var offers : NSMutableArray = []
    
    var dataManager : DataManager? = DataManager()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var monsterAnimation: FrameAnimations!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //animator = Animator(referenceView: self.view)
        
        monsterAnimation.alpha = 0
        monsterAnimation.monsterType = MonsterTypes.Monster1
        monsterAnimation.originalCenter = CGPointMake(self.view.frame.width/2,  monsterAnimation.center.y)
        
        offers = NSMutableArray(array: dataManager!.getRecommendations(nil))
        

    }

    override func viewDidAppear(animated: Bool) {
        
        monsterAnimation.alpha = 1
        
        //tableView.reloadData()
        
        if let cells = tableView.visibleCells() as? [OfferTableViewCell] {
            for cell in cells {
                animator?.fadeIn(cell, direction: AnimationDirection.Top)
            }
        }

    }
    
     @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let cells = tableView.visibleCells() as? [OfferTableViewCell] {
            for cell in cells {
                animator?.fadeDown(cell, delay: 0.0)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Scroll
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        monsterAnimation.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        monsterAnimation.scrollViewWillBeginDragging(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        animator?.bounces(tableView.cellForRowAtIndexPath(indexPath)!, delay: 0.1)
        
        let indexPath1 = NSIndexPath(forRow: 1, inSection: 0)
        animator?.bounces(tableView.cellForRowAtIndexPath(indexPath1)!, delay: 0.2)
    }
    
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return offers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("offerCell", forIndexPath: indexPath) as! OfferTableViewCell
        
        // Configure the cell...
        let offer = offers[indexPath.row] as! Recommendation
        
        cell.offerNameLabel.text = offer.title
        cell.offerAddressLabel.text = offer.address
        cell.offerImage.image =  offer.image
        
        cell.alpha = 0
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        animator?.bounces(cell, delay : Double(indexPath.row/10))
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.width + 10 + 21 + 10 + 21 + 10
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let offerDetailVC = storyboard.instantiateViewControllerWithIdentifier("offerDetailViewController") as! OfferDetailViewController
        offerDetailVC.recommendation = offers.objectAtIndex(indexPath.row) as! Recommendation
        offerDetailVC.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        offerDetailVC.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(offerDetailVC, animated: true) { () -> Void in
        }
        
    }

}

