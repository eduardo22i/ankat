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
        let query = PFQuery(className: SubcategoryClass)
        
        if let options = options {
            for (key, value)  in options {
                query.whereKey(key as! String , equalTo: value )
            }
        }
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
    
    //MARK: SET
    
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
