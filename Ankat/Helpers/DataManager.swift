//
//  DataManager.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/10/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

class DataManager: NSObject {
   
    //MARK: GET
    
    func getCategories (options : NSDictionary!) -> NSArray {
        //Search for recomendations
        
        return getTmpCategories ()
    }

    
    func getRecommendation (options : NSDictionary!) -> Recommendation {
        //Search for recomendations
        
        return addTmpRecommendations()[0] as! Recommendation
        
    }
    
    
    func getRecommendations (options : NSDictionary!) -> NSArray {
        //Search for recomendations
        
        return addTmpRecommendations()
    }
    
    
    //MARK: Temporal
    
    func getTmpCategories () -> NSArray {
        
        var categories = [ [ "name":  "Bakery", "icon" : UIImage(named: "Icons-01.png")! ] ]
        categories.append([ "name":  "Bar", "icon" : UIImage(named: "Icons-02.png")! ])
        categories.append([ "name":  "Buffet", "icon" : UIImage(named: "Icons-03.png")! ])
        categories.append([ "name":  "Coffee", "icon" : UIImage(named: "Icons-04.png")! ])
        categories.append([ "name":  "Ice Cream", "icon" : UIImage(named: "Icons-05.png")! ])
        categories.append([ "name":  "Home Made", "icon" : UIImage(named: "Icons-10.png")! ])
        categories.append([ "name":  "Lounge", "icon" : UIImage(named: "Icons-06.png")! ])
        categories.append([ "name":  "Restaurant", "icon" : UIImage(named: "Icons-07.png")! ])
        categories.append([ "name":  "Tea Room", "icon" : UIImage(named: "Icons-08.png")! ])
        categories.append([ "name":  "Winery", "icon" : UIImage(named: "Icons-09.png")! ] )
        
        return categories
    }
    
    func addTmpRecommendations () -> NSArray {
        var offers : NSMutableArray = []
        
        let recommendation = Recommendation()
        recommendation.title = "Make School Summer Academy"
        recommendation.address = "1547 Mission St, San Francisco, CA"
        recommendation.brief = "Muffin bonbon tiramisu sweet cake powder chocolate bar pudding cake. Candy canes marshmallow pie cotton candy powder pie. Cotton candy dragée carrot cake jujubes carrot cake. Bonbon lollipop pastry tootsie roll.\n\n Apple pie carrot cake danish. Sweet dessert cotton candy halvah caramels soufflé jelly beans gummi bears. Sugar plum tart jelly-o sweet cake liquorice tart. Marshmallow jelly tiramisu."
        recommendation.image = UIImage(named: "tmp-01.jpg")
        
        offers.insertObject(recommendation, atIndex: offers.count)
        
        
        let recommendation2 = Recommendation()
        recommendation2.title = "Example 1"
        recommendation2.address = "532 Powell St, San Francisco, CA"
        recommendation2.brief = "Muffin bonbon tiramisu sweet cake powder chocolate bar pudding cake. Candy canes marshmallow pie cotton candy powder pie. Cotton candy dragée carrot cake jujubes carrot cake. Bonbon lollipop pastry tootsie roll.\n\n Apple pie carrot cake danish. Sweet dessert cotton candy halvah caramels soufflé jelly beans gummi bears. Sugar plum tart jelly-o sweet cake liquorice tart. Marshmallow jelly tiramisu."
        recommendation2.image = UIImage(named: "tmp-02.jpg")
        
        offers.insertObject(recommendation2, atIndex: offers.count)
        
        
        let recommendation3 = Recommendation()
        recommendation3.title = "Monsters Food Festival"
        recommendation3.address = "527 Dolores St, San Francisco, CA"
        recommendation3.brief = "Muffin bonbon tiramisu sweet cake powder chocolate bar pudding cake. Candy canes marshmallow pie cotton candy powder pie. Cotton candy dragée carrot cake jujubes carrot cake. Bonbon lollipop pastry tootsie roll.\n\n Apple pie carrot cake danish. Sweet dessert cotton candy halvah caramels soufflé jelly beans gummi bears. Sugar plum tart jelly-o sweet cake liquorice tart. Marshmallow jelly tiramisu."
        recommendation3.image = UIImage(named: "tmp-03.jpg")
        
        offers.insertObject(recommendation3, atIndex: offers.count)
        
        return offers
    }
    
    
}
