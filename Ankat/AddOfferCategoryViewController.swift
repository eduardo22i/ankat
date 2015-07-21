//
//  AddOfferViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/10/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse

let newOfferReuseIdentifier = "NewOfferCell"


class AddOfferCategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var category : PFObject! {
        didSet {
            
            DataManager.getSubCategories(["category" : category]) { ( objects : [AnyObject]?, error : NSError?) -> Void in
                if let subcategories = objects as? [Subcategory] {
                    self.subcategories = subcategories
                }
            }
            
        }
    }
    
    var subcategories : [Subcategory] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var dataManager : DataManager? = DataManager()
    
    var didShowOfferInfo = false

    @IBOutlet var monsterAnimation: FrameAnimations!

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //animator = Animator(referenceView: self.view)
        
        monsterAnimation.monsterType = MonsterTypes.Monster3
        monsterAnimation.alpha = 0
        
        DataManager.getCategories(nil, completionBlock: { (objects : [AnyObject]?, error : NSError?) -> Void in
            
            if (objects?.count == 0 || error != nil) {
                    return
            }
            
            
            if let category =  objects?[0] as? PFObject {
                
                self.category = category
                
                
            }
            
        })
        
        
       
    }
    
    override func viewDidAppear(animated: Bool) {
        if !didShowOfferInfo {
            animator?.bounces(monsterAnimation)
            collectionView.alpha = 1
        } else {
            animator?.fadeIn(monsterAnimation, delay: 0.0, direction: AnimationDirection.Right, velocity : AnimationVelocity.Fast)
            
            animator?.fadeIn(collectionView, delay: 0.0, direction: AnimationDirection.Right, velocity : AnimationVelocity.Fast)

        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        /*
        self.monsterAnimation.center = CGPointMake(self.monsterAnimation.center.x - 50, self.monsterAnimation.center.y)
        animator?.fadeLeft(monsterAnimation, delay: 0.0, blockAn: { (ended : Bool, error :NSError?) -> Void in
            self.monsterAnimation.center = CGPointMake(self.monsterAnimation.center.x - 100, self.monsterAnimation.center.y)
        })
        
        self.collectionView.center = CGPointMake(self.collectionView.center.x - 50, self.collectionView.center.y)
        animator?.fadeLeft(collectionView, delay: 0.0, blockAn: { (ended : Bool, error :NSError?) -> Void in
            self.collectionView.center = CGPointMake(self.collectionView.center.x - 100, self.collectionView.center.y)
        })
        */
        animator?.fadeOut(monsterAnimation, direction: AnimationDirection.Left)
        animator?.fadeOut(collectionView, direction: AnimationDirection.Left)
        
        
        
        
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
        didShowOfferInfo = true
        let vc = segue.destinationViewController as! AddOfferInformationViewController
        if let indexPath = collectionView.indexPathsForSelectedItems()[0] as? NSIndexPath {
            vc.subcategory = subcategories[indexPath.row]
        }
    }

    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return subcategories.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(newOfferReuseIdentifier, forIndexPath: indexPath) as! NewOfferCollectionViewCell
        
        // Configure the cell
        if subcategories.count > indexPath.row  {
            let category = subcategories[indexPath.row]
            cell.titleLabel.text = category.name
            category.downloadImage(cell.iconImageView)
            
            //animator?.bouncesSmall(cell, delay: Double(indexPath.row/10))
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        collectionView.indexPathsForVisibleItems()
        
        var countDelay = 0.0
        var cont = 0
        let delay = Int(self.view.frame.width / 120.0)
        
        /*
        for cell in self.collectionView.visibleCells() {
            
            animator?.bouncesSmall(cell, delay: Double(countDelay/10.0))
            
            cont++
            
            if cont > delay {
                cont = 0
                countDelay++
            }
        
        }
        */
        
    }
    // MARK: UICollectionViewDelegate
    
    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */


}
