//
//  OffersListViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/6/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

class OffersListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var offers = [Offer]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var monsterAnimation: FrameAnimations!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
        monsterAnimation.alpha = 0
        monsterAnimation.monsterType = MonsterTypes.monster1
        monsterAnimation.originalCenter = CGPoint(x: self.view.frame.width/2,  y: monsterAnimation.center.y)
        
        DataManager.getOffers(["status" : 1]) { (objects : [Any]?, error: Error?) in
            if let objects = objects as? [Offer] {
                self.offers = objects
            }
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        monsterAnimation.alpha = 1
        
        //tableView.reloadData()
        
        if let cells = tableView.visibleCells as? [OfferTableViewCell] {
            for cell in cells {
                animator?.fadeIn(cell, direction: AnimationDirection.top)
            }
        }

    }
    
     @IBAction func unwindToSegue(_ segue: UIStoryboardSegue) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let cells = tableView.visibleCells as? [OfferTableViewCell] {
            for _ in cells {
                //animator?.fadeDown(cell, delay: 0.0)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "offerCell", for: indexPath) as! OfferTableViewCell
        
        // Configure the cell...
        let offer = offers[(indexPath as NSIndexPath).row]
        
        cell.offerNameLabel.text = offer.name
        cell.offerAddressLabel.text = offer.address
        offer.downloadImage(cell.offerImage)
        cell.offerImage.inCircle()
        
        cell.alpha = 0
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        animator?.bounces(cell, delay : Double((indexPath as NSIndexPath).row/10))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return self.view.frame.width + 10 + 21 + 10 + 21 + 10
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let offerDetailVC = storyboard.instantiateViewController(withIdentifier: "offerDetailViewController") as! OfferDetailViewController
        offerDetailVC.recommendation = offers[indexPath.row]
        offerDetailVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        offerDetailVC.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(offerDetailVC, animated: true) { () -> Void in
        }
        
    }

}

