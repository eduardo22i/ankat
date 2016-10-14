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
    static let OfferDateClass    = "OfferDate"

    typealias DeleteEndedBlock = () -> Void

    //MARK: GET
    
    static func getCategories (_ options : NSDictionary!, completionBlock: @escaping PFArrayResultBlock)  {
        //Search for recomendations
        let query = PFQuery(className: CategoryClass)
        
        if let options = options {
            for (key, value)  in options {
                query.whereKey(key as! String , equalTo: value )
            }
        }
        
        query.whereKey("hidden", equalTo: false)
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground(block: completionBlock)
        
    }
    
    static func getSubCategories (_ options : NSDictionary!, completionBlock: @escaping PFArrayResultBlock)  {
        //Search for recomendations
        let query = Subcategory.query()! //PFQuery(className: SubcategoryClass)
//        query.cachePolicy = PFCachePolicy.NetworkOnly
        if let options = options {
            for (key, value)  in options {
                query.whereKey(key as! String , equalTo: value )
            }
        }
        query.includeKey("category")
        query.order(byAscending: "name")
        query.findObjectsInBackground(block: completionBlock)
        
    }

    
    static func getOffers (_ options : NSDictionary!, completionBlock: @escaping PFArrayResultBlock)  {
        //Search for recomendations
        let query = PFQuery(className: OfferClass)
        
        if let options = options {
            for (key, value)  in options {
                query.whereKey(key as! String , equalTo: value )
            }
        }
        query.order(byDescending: "updatedAt")
        query.includeKey("subcategory")
        query.findObjectsInBackground(block: completionBlock)
    }
    
    static func getOffers (_ options : NSDictionary!, user : PFObject ,completionBlock: @escaping PFArrayResultBlock)  {
        
        DataManager.findUserSubcategoriesLikes(["user":user]) { (subcategories : [Any]?, error : Error?) -> Void in
            
            if let subcategories = subcategories as? [PFObject] {
                let selectedSubcategory = subcategories.map{
                    $0.object(forKey: "subcategory") as! Subcategory
                }
                let query = PFQuery(className: DataManager.OfferClass)
                
                if let options = options {
                    for (key, value)  in options {
                        query.whereKey(key as! String , equalTo: value )
                    }
                }
                
                
                query.whereKey("subcategory", containedIn: selectedSubcategory)
                query.order(byAscending: "location")
                query.includeKey("subcategory")
                query.findObjectsInBackground(block: completionBlock)
            }
        }
        
    }
    
    static func findUserSubcategoriesLikes (_ options : NSDictionary!, completionBlock: @escaping PFArrayResultBlock)  {
        //Search for recomendations
        let query = PFQuery(className: UserSubcategoriesLikes)
        
        if let options = options {
            for (key, value)  in options {
                query.whereKey(key as! String , equalTo: value )
            }
        }
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground(block: completionBlock)
    }
    
    
    static func getPreferences (_ options : NSDictionary!, completionBlock: @escaping PFArrayResultBlock)  {
        //Search for recomendations
        let query = PFQuery(className: PreferenceClass)
        
        if let options = options {
            for (key, value)  in options {
                query.whereKey(key as! String , equalTo: value )
            }
        }
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground(block: completionBlock)
    }
    
    static func findUserPreferences(_ user : PFObject, completionBlock: @escaping PFArrayResultBlock ) {
        let query = PFQuery(className: UserPreferenceClass)
        query.whereKey("user" , equalTo: user )
        query.findObjectsInBackground(block: completionBlock)
    }
    
    static func findUserPreference(_ user : PFObject, preference : Preference, completionBlock: @escaping PFArrayResultBlock ) {
        let query = PFQuery(className: UserPreferenceClass)
        query.whereKey("user" , equalTo: user )
        query.whereKey("preference" , equalTo: preference )
        query.findObjectsInBackground(block: completionBlock)
    }

    static func findOfferPreferences(_ offer : PFObject, completionBlock: @escaping PFArrayResultBlock ) {
        let query = PFQuery(className: OfferPreferenceClass)
        query.whereKey("offer" , equalTo: offer )
        query.includeKey("preference")
        query.findObjectsInBackground(block: completionBlock)
    }
    
    static func findOfferPreferencesInThread(_ offer : PFObject ) -> [AnyObject] {
        let query = PFQuery(className: OfferPreferenceClass)
        query.whereKey("offer" , equalTo: offer )
        query.includeKey("preference")
        return query.findObjects()! as [AnyObject]
        //query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    
    static func findOfferDates(_ offer : PFObject, completionBlock: @escaping PFArrayResultBlock ) {
        let query = PFQuery(className: OfferDateClass)
        query.whereKey("offer" , equalTo: offer )
        query.whereKey("endDate", greaterThanOrEqualTo: Date())
        
        query.findObjectsInBackground(block: completionBlock)
    }

    static func findOfferDatesInDate(_ offer : PFObject , completionBlock: @escaping PFIntegerResultBlock) {
        let query = PFQuery(className: OfferDateClass)
        query.whereKey("offer" , equalTo: offer )
        query.whereKey("startDate", lessThanOrEqualTo: Date())
        query.whereKey("endDate", greaterThanOrEqualTo: Date())
        query.includeKey("offer")
        
        query.countObjectsInBackground(block: completionBlock)
        //query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func findOfferDatesInDateInThread(_ offer : PFObject ) -> Int {
        let query = PFQuery(className: OfferDateClass)
        query.whereKey("offer" , equalTo: offer )
        query.whereKey("startDate", lessThanOrEqualTo: Date())
        query.whereKey("endDate", greaterThanOrEqualTo: Date())
        query.includeKey("offer")
        
        return query.countObjects()
        //query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    //MARK: SAVE
    
    func setOffer (_ offer : Offer) {
        /*
        let offerObject = PFObject(className: OfferClass)
        likeObject["name"] = offer.title
        likeObject["brief"] = offer.brief
        likeObject["name"] = offer.title
        likeObject[ParseLikeToPost] = post
        
        likeObject.saveInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
*/
    }
    
    static func saveUserLikeToSubCategory (_ user : PFObject, subcategory : Subcategory, completionBlock: @escaping PFBooleanResultBlock ) {
        let userSubcategoriesLike = PFObject(className: UserSubcategoriesLikes)
        userSubcategoriesLike["user"] = user
        userSubcategoriesLike["subcategory"] = subcategory
        
        userSubcategoriesLike.saveInBackground(block: completionBlock)
    }
    
    static func saveUserPreference (_ user : PFObject, preference : Preference, completionBlock: @escaping PFBooleanResultBlock ) {
        let userSubcategoriesLike = PFObject(className: UserPreferenceClass)
        userSubcategoriesLike["user"] = user
        userSubcategoriesLike["preference"] = preference
        
        userSubcategoriesLike.saveInBackground(block: completionBlock)
    }
    
    static func saveOfferDay (_ offer : Offer, startDay: Date, endDay: Date) {
        
        let offerDateObject = PFObject(className: OfferDateClass)
        offerDateObject["offer"] = offer
        offerDateObject["startDate"] = startDay
        offerDateObject["endDate"] = endDay
        
        offerDateObject.saveInBackground(block: nil)
    }

    
    //MARK: Delete
    
    static func deleteUserLikeToSubCategory (_ user : PFObject, subcategory : Subcategory, completionBlock: @escaping PFBooleanResultBlock ) {
        let query = PFQuery(className: UserSubcategoriesLikes)
        query.whereKey("user" , equalTo: user )
        query.whereKey("subcategory" , equalTo: subcategory )
        query.getFirstObjectInBackground { (object : PFObject?, error : Error?) -> Void in
            (object?.deleteInBackground(block: completionBlock))!
        }
    }
    
    static func deleteUserLikesToSubCategory(_ user : PFObject, subcategory : Subcategory, completionBlock: @escaping DeleteEndedBlock ) {
        let query = PFQuery(className: UserSubcategoriesLikes)
        query.whereKey("user" , equalTo: user )
        query.findObjectsInBackground { (results : [Any]?, error : Error?) -> Void in
            
            let results = results as? [PFObject] ?? []
            
            for like in results {
                like.deleteInBackground()
            }
            
            completionBlock()
        }
    }
    
    static func deleteUserPreference(_ user : PFObject, preference : Preference, completionBlock: @escaping DeleteEndedBlock ) {
        
        findUserPreference(user, preference: preference) { (results :  [Any]?, error : Error?) -> Void in
            
            let results = results as? [PFObject] ?? []
            
            for result in results {
                result.deleteInBackground()
            }
            
            completionBlock()
        }
        
    }
    
    
}
