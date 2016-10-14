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
    
    
    func savePreference(_ completionBlock: @escaping PFBooleanResultBlock) {
        
        saveInBackground(block: completionBlock)
        
    }


    
}
