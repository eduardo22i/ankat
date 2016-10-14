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
        
        self.icon = imageFile
        
        saveInBackground(block: completionBlock)
        
    }

    
    func downloadImage( _ imageView : UIImageView ) {
        icon?.getDataInBackground { (data: Data?, error: Error?) -> Void in
            if let data = data {
                let image = UIImage(data: data, scale:1.0)!
                self.image = image
                imageView.image = image
            }
        }
    }
    
}
