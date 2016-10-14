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
    
    func uploadPost(_ completionBlock: @escaping PFBooleanResultBlock) {
        // 1
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        let imageFile = PFFile(name: "image.jpg", data: imageData!)
        
        photoUploadTask = UIApplication.shared.beginBackgroundTask (expirationHandler: { () -> Void in
            UIApplication.shared.endBackgroundTask(self.photoUploadTask!)
        })
        
        
        // 2
        imageFile.saveInBackground { (success: Bool, error: Error?) -> Void in
            // 3
            UIApplication.shared.endBackgroundTask(self.photoUploadTask!)
        }
        
        self.coverImageFile = imageFile
        status = 1
        hidden = false
        
        saveInBackground(block: completionBlock)
        
    }

    func downloadImageWithBlock(_ completionBlock: @escaping PFDataResultBlock ) {
        coverImageFile?.getDataInBackground(block: completionBlock)
        
    }
    
    
    func downloadImage( _ imageView : UIImageView ) {
        coverImageFile?.getDataInBackground { (data: Data?, error: Error?) -> Void in
            if let data = data {
                let image = UIImage(data: data, scale:1.0)!
                self.image = image
                imageView.image = image
            }
        }
    }
    
    func downloadUserImage (_ profileImageView : UIImageView) {
        
        let userPicture = createdBy?.object(forKey: "image") as? PFFile
        userPicture?.getDataInBackground(block: { (data : Data?, error : Error?) -> Void in
            profileImageView.image = UIImage(data: data!)!
        })
    }
}
