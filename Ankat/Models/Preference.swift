//
//  Subcategory
//  Ankat
//
//  Created by Eduardo Irías on 7/7/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse
import MapKit

class Preference: PFObject, PFSubclassing {
   
    @NSManaged var caption: String?

    static func parseClassName() -> String {
        return "Preference"
    }
    
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
//            self.registerSubclass()
        }
    }
    
    func savePreference(completionBlock: PFBooleanResultBlock) {
        
        saveInBackgroundWithBlock(completionBlock)
        
    }


    
}
