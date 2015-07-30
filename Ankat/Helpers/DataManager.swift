//
//  DataManager.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/10/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse

class DataManager: NSObject {
   
    static let OfferClass       = "Offer"
    static let CategoryClass    = "Category"
    static let SubcategoryClass    = "Subcategory"
    static let UserSubcategoriesLikes    = "UserSubcategoriesLikes"
    static let PreferenceClass    = "Preference"
    static let UserPreferenceClass    = "UserPreference"
    static let OfferPreferenceClass    = "OfferPreference"

    typealias DeleteEndedBlock = () -> Void

    //MARK: GET
    
    static func getCategories (options : NSDictionary!, completionBlock: PFArrayResultBlock)  {
        //Search for recomendations
        let query = PFQuery(className: CategoryClass)
        
        if let options = options {
            for (key, value)  in options {
                query.whereKey(key as! String , equalTo: value )
            }
        }
        
        query.whereKey("hidden", equalTo: false)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
    }
    
    static func getSubCategories (options : NSDictionary!, completionBlock: PFArrayResultBlock)  {
        //Search for recomendations
        let query = Subcategory.query()! //PFQuery(className: SubcategoryClass)
//        query.cachePolicy = PFCachePolicy.NetworkOnly
        if let options = options {
            for (key, value)  in options {
                query.whereKey(key as! String , equalTo: value )
            }
        }
        query.includeKey("category")
        query.orderByAscending("name")
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
    }

    
    func getOffer (options : NSDictionary!) -> Offer {
        //Search for recomendations
        
        return addTmpOffers()[0] as! Offer
        
    }
    
    
    static func getOffers (options : NSDictionary!, completionBlock: PFArrayResultBlock)  {
        //Search for recomendations
        let query = PFQuery(className: OfferClass)
        
        if let options = options {
            for (key, value)  in options {
                query.whereKey(key as! String , equalTo: value )
            }
        }
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func getOffers (options : NSDictionary!, user : PFObject ,completionBlock: PFArrayResultBlock)  {
        
        DataManager.findUserSubcategoriesLikes(["user":user]) { (subcategories : [AnyObject]?, error : NSError?) -> Void in
            
            let selectedSubcategory = subcategories?.map{
                $0.objectForKey("subcategory") as! Subcategory
            }
            
            
            let query = PFQuery(className: DataManager.OfferClass)
            query.whereKey("subcategory", containedIn: selectedSubcategory!)
            query.orderByAscending("location")
            query.findObjectsInBackgroundWithBlock(completionBlock)
            
        }
        
    }
    
    static func findUserSubcategoriesLikes (options : NSDictionary!, completionBlock: PFArrayResultBlock)  {
        //Search for recomendations
        let query = PFQuery(className: UserSubcategoriesLikes)
        
        if let options = options {
            for (key, value)  in options {
                query.whereKey(key as! String , equalTo: value )
            }
        }
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    
    static func getPreferences (options : NSDictionary!, completionBlock: PFArrayResultBlock)  {
        //Search for recomendations
        let query = PFQuery(className: PreferenceClass)
        
        if let options = options {
            for (key, value)  in options {
                query.whereKey(key as! String , equalTo: value )
            }
        }
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func findUserPreferences(user : PFObject, completionBlock: PFArrayResultBlock ) {
        let query = PFQuery(className: UserPreferenceClass)
        query.whereKey("user" , equalTo: user )
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func findUserPreference(user : PFObject, preference : Preference, completionBlock: PFArrayResultBlock ) {
        let query = PFQuery(className: UserPreferenceClass)
        query.whereKey("user" , equalTo: user )
        query.whereKey("preference" , equalTo: preference )
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }

    static func findOfferPreferences(offer : PFObject, completionBlock: PFArrayResultBlock ) {
        let query = PFQuery(className: OfferPreferenceClass)
        query.whereKey("offer" , equalTo: offer )
        query.includeKey("preference")
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func findOfferPreferencesInThread(offer : PFObject ) -> [AnyObject] {
        let query = PFQuery(className: OfferPreferenceClass)
        query.whereKey("offer" , equalTo: offer )
        query.includeKey("preference")
        return query.findObjects()!
        //query.findObjectsInBackgroundWithBlock(completionBlock)
    }

    
    //MARK: SAVE
    
    func setOffer (offer : Offer) {
        /*
        let offerObject = PFObject(className: OfferClass)
        likeObject["name"] = offer.title
        likeObject["brief"] = offer.brief
        likeObject["name"] = offer.title
        likeObject[ParseLikeToPost] = post
        
        likeObject.saveInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
*/
    }
    
    static func saveUserLikeToSubCategory (user : PFObject, subcategory : Subcategory, completionBlock: PFBooleanResultBlock ) {
        let userSubcategoriesLike = PFObject(className: UserSubcategoriesLikes)
        userSubcategoriesLike["user"] = user
        userSubcategoriesLike["subcategory"] = subcategory
        
        userSubcategoriesLike.saveInBackgroundWithBlock(completionBlock)
    }
    
    static func saveUserPreference (user : PFObject, preference : Preference, completionBlock: PFBooleanResultBlock ) {
        let userSubcategoriesLike = PFObject(className: UserPreferenceClass)
        userSubcategoriesLike["user"] = user
        userSubcategoriesLike["preference"] = preference
        
        userSubcategoriesLike.saveInBackgroundWithBlock(completionBlock)
    }
    
    //MARK: Delete
    
    static func deleteUserLikeToSubCategory (user : PFObject, subcategory : Subcategory, completionBlock: PFBooleanResultBlock ) {
        let query = PFQuery(className: UserSubcategoriesLikes)
        query.whereKey("user" , equalTo: user )
        query.whereKey("subcategory" , equalTo: subcategory )
        query.getFirstObjectInBackgroundWithBlock { (object : PFObject?, error : NSError?) -> Void in
            object?.deleteInBackgroundWithBlock(completionBlock)
        }
    }
    
    static func deleteUserLikesToSubCategory(user : PFObject, subcategory : Subcategory, completionBlock: DeleteEndedBlock ) {
        let query = PFQuery(className: UserSubcategoriesLikes)
        query.whereKey("user" , equalTo: user )
        query.findObjectsInBackgroundWithBlock { (results : [AnyObject]?, error : NSError?) -> Void in
            
            let results = results as? [PFObject] ?? []
            
            for like in results {
                like.deleteInBackground()
            }
            
            completionBlock()
            //completionBlock()
        }
    }
    
    static func deleteUserPreference(user : PFObject, preference : Preference, completionBlock: DeleteEndedBlock ) {
        
        findUserPreference(user, preference: preference) { (results :  [AnyObject]?, error : NSError?) -> Void in
            
            let results = results as? [PFObject] ?? []
            
            for result in results {
                result.deleteInBackground()
            }
            
            completionBlock()
        }
        
    }
    
    //MARK: Temporal
    
    
    func addTmpOffers () -> NSArray {
        var offers : NSMutableArray = []
        
        let recommendation = Offer()
        recommendation.name = "Make School Summer Academy"
        recommendation.address = "1547 Mission St, San Francisco, CA"
        recommendation.brief = "Muffin bonbon tiramisu sweet cake powder chocolate bar pudding cake. Candy canes marshmallow pie cotton candy powder pie. Cotton candy dragée carrot cake jujubes carrot cake. Bonbon lollipop pastry tootsie roll.\n\n Apple pie carrot cake danish. Sweet dessert cotton candy halvah caramels soufflé jelly beans gummi bears. Sugar plum tart jelly-o sweet cake liquorice tart. Marshmallow jelly tiramisu."
        recommendation.image = UIImage(named: "tmp-01.jpg")
        
        offers.insertObject(recommendation, atIndex: offers.count)
        
        
        let recommendation2 = Offer()
        recommendation2.name = "Example 1"
        recommendation2.address = "532 Powell St, San Francisco, CA"
        recommendation2.brief = "Muffin bonbon tiramisu sweet cake powder chocolate bar pudding cake. Candy canes marshmallow pie cotton candy powder pie. Cotton candy dragée carrot cake jujubes carrot cake. Bonbon lollipop pastry tootsie roll.\n\n Apple pie carrot cake danish. Sweet dessert cotton candy halvah caramels soufflé jelly beans gummi bears. Sugar plum tart jelly-o sweet cake liquorice tart. Marshmallow jelly tiramisu."
        recommendation2.image = UIImage(named: "tmp-02.jpg")
        
        offers.insertObject(recommendation2, atIndex: offers.count)
        
        
        let recommendation3 = Offer()
        recommendation3.name = "Monsters Food Festival"
        recommendation3.address = "527 Dolores St, San Francisco, CA"
        recommendation3.brief = "Muffin bonbon tiramisu sweet cake powder chocolate bar pudding cake. Candy canes marshmallow pie cotton candy powder pie. Cotton candy dragée carrot cake jujubes carrot cake. Bonbon lollipop pastry tootsie roll.\n\n Apple pie carrot cake danish. Sweet dessert cotton candy halvah caramels soufflé jelly beans gummi bears. Sugar plum tart jelly-o sweet cake liquorice tart. Marshmallow jelly tiramisu."
        recommendation3.image = UIImage(named: "tmp-03.jpg")
        
        offers.insertObject(recommendation3, atIndex: offers.count)
        
        return offers
    }
    
    
}
