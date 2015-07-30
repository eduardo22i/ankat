//
//  PreferencesViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/21/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse

let SubcategoryPreferenceOfferReuseIdentifier = "NewOfferCell"


class PreferencesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var category : PFObject! {
        didSet {
            /*
            DataManager.getSubCategories(["category" : category]) { ( objects : [AnyObject]?, error : NSError?) -> Void in
            
            //DataManager.getSubCategories([nil) { ( objects : [AnyObject]?, error : NSError?) -> Void in
                if let subcategories = objects as? [Subcategory] {
                    self.subcategories = subcategories
                }
            }
            */
            
            DataManager.getSubCategories(["category" : category], completionBlock: { (objects : [AnyObject]?, error : NSError?) -> Void in
                println(objects?.count)
                
                for obj in objects! {
                    if (obj is Subcategory) {
                        println("Yep")
                    } else {
                        println("Nope")
                    }
                }
                
                let user = PFUser.currentUser()
                DataManager.findUserSubcategoriesLikes(["user":user!], completionBlock: { (selectedUserSubcategory : [AnyObject]?, error : NSError?) -> Void in
                    
                    let selectedSubcategory = selectedUserSubcategory?.map{
                        $0.objectForKey("subcategory") as! Subcategory
                    }
                    
                    if let selectedSubcategories = selectedSubcategory  {
                        for selectedSubcategory in selectedSubcategories {
                            println(selectedSubcategory.objectId!)
                            self.selectedSubCategory.addObject(selectedSubcategory as Subcategory)
                        }
                    }
                    
                    if let subcategories = objects as? [PFObject] {
                        for subcategoryD in subcategories {
                            if let name = subcategoryD as? Subcategory  {
                                self.subcategories.append(name)
                            }
                        }
                        //self.subcategories = subcategories as? Subcategory
                    }
                    
                    self.collectionView.reloadData()
                    
                })
                
                
                
            })
            
        }
    }
    
    var subcategories : [Subcategory] = [] {
        didSet {
            //self.collectionView.reloadData()
        }
    }
    
    
    var selectedSubCategory : NSMutableSet = NSMutableSet()
    
    var dataManager : DataManager? = DataManager()
    
    var didShowOfferInfo = false
    
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var monsterAnimation: FrameAnimations!
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //animator = Animator(referenceView: self.view)
        
        //navigationBar.transparent()
        
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
    /*
    var savingEnded = false
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return savingEnded
    }
*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showPreferences" {
            

          
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SubcategoryPreferenceOfferReuseIdentifier, forIndexPath: indexPath) as! NewOfferCollectionViewCell
        
        // Configure the cell
        if subcategories.count > indexPath.row  {
            let category = subcategories[indexPath.row]
            cell.titleLabel.text = category.name
            category.downloadImage(cell.iconImageView)
            
            cell.backgroundColor = UIColor.groupTableViewBackgroundColor()
            
            for selectSubCategory in selectedSubCategory {
                if selectSubCategory.objectId! == category.objectId! {
                    cell.backgroundColor = UIColor.whiteColor()
                }
            }
            
            /*
            if selectedSubCategory.containsObject(category) {
                cell.backgroundColor = UIColor.lightGrayColor()
            }
            */
            
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? NewOfferCollectionViewCell {
            
            if !selectedSubCategory.containsObject(subcategories[indexPath.row]) {
                
                selectedSubCategory.addObject(subcategories[indexPath.row])
                cell.backgroundColor = UIColor.whiteColor()
                
                
                DataManager.saveUserLikeToSubCategory(PFUser.currentUser()!, subcategory: subcategories[indexPath.row], completionBlock: { (ended : Bool, error : NSError?) -> Void in
                    
                })
                
            } else {
                selectedSubCategory.removeObject(subcategories[indexPath.row])
                
                cell.backgroundColor = UIColor.groupTableViewBackgroundColor()
                
                DataManager.deleteUserLikeToSubCategory(PFUser.currentUser()!, subcategory: subcategories[indexPath.row], completionBlock: { (ended : Bool, error : NSError?) -> Void in
                    
                })
                
            }
            animator?.bouncesSmall(cell, delay: 0.0)
        }
    }
    // MARK: UICollectionViewDelegate
    
    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    
    // Uncomment this method to specify if the specified item should be selected
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    
    
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
    
    @IBAction func nextAction (sender : AnyObject) {
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("preferencesViewController") as! PersonalizedPreferencesViewController
        
        self.navigationController?.pushViewController(viewController, animated: true)
        */
        /*
            dispatch_async(dispatch_queue_create("my", nil), { () -> Void in
                if let user = PFUser.currentUser() {
                    for subcategory in self.selectedSubCategory {
                        
                        DataManager.deleteUserLikesToSubCategory(user, completionBlock: { () -> Void in
                            DataManager.saveUserLikeToSubCategory(user, subcategory: subcategory as! Subcategory , completionBlock: { (ended : Bool, error : NSError?) -> Void in
                                
                                
                                //preferencesViewController
                            })
                        })
                    }
                }
                dispatch_async(dispatch_get_main_queue() , { () -> Void in
                    
                })
            });
        */  
            
       
        
        
    }
    
}
