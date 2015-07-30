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

class Subcategory: PFObject, PFSubclassing {
   
    var photoUploadTask: UIBackgroundTaskIdentifier?
    var image : UIImage!
    
    @NSManaged var name: String?
    @NSManaged var icon: PFFile?
    @NSManaged var category: PFObject?


    
    static func parseClassName() -> String {
        return "Subcategory"
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
    
    func uploadPost(completionBlock: PFBooleanResultBlock) {
        // 1
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        let imageFile = PFFile(name: "image.jpg", data: imageData)
        
        photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
        }
        
        
        // 2
        imageFile.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            // 3
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
        }
        
        self.icon = imageFile
        
        saveInBackgroundWithBlock(completionBlock)
        
    }

    
    func downloadImage( imageView : UIImageView ) {
        icon?.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
            if let data = data {
                let image = UIImage(data: data, scale:1.0)!
                self.image = image
                imageView.image = image
            }
        }
    }
    
}
