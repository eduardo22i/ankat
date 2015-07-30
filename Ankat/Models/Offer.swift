//
//  Offer
//  Ankat
//
//  Created by Eduardo Irías on 7/7/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse
import MapKit

class Offer: PFObject, PFSubclassing {
   
    var photoUploadTask: UIBackgroundTaskIdentifier?
    var image : UIImage!
    
    @NSManaged var name: String?
    @NSManaged var address : String?
    @NSManaged var brief : String?
    @NSManaged var location : PFGeoPoint!
    @NSManaged var price : NSNumber!
    @NSManaged var status: NSNumber?
    @NSManaged var hidden: NSNumber?
    @NSManaged var subcategory: Subcategory?
    @NSManaged var createdBy: PFUser?
    @NSManaged var coverImageFile: PFFile?


    
    static func parseClassName() -> String {
        return "Offer"
    }
    
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
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
        
        self.coverImageFile = imageFile
        status = 1
        hidden = false
        
        saveInBackgroundWithBlock(completionBlock)
        
    }

    func downloadImageWithBlock(completionBlock: PFDataResultBlock ) {
        coverImageFile?.getDataInBackgroundWithBlock(completionBlock)
        
    }
    
    
    func downloadImage( imageView : UIImageView ) {
        coverImageFile?.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
            if let data = data {
                let image = UIImage(data: data, scale:1.0)!
                self.image = image
                imageView.image = image
            }
        }
    }
    
    func downloadUserImage (profileImageView : UIImageView) {
        
        let userPicture = createdBy?.objectForKey("image") as? PFFile
        userPicture?.getDataInBackgroundWithBlock({ (data : NSData?, error :NSError?) -> Void in
            profileImageView.image = UIImage(data: data!)!
        })
    }
}
