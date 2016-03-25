//
//  Note.swift
//  Notes_TT
//
//  Created by Александр on 24.03.16.
//  Copyright © 2016 Khlebnikov. All rights reserved.
//

import GLKit

class Note : NSObject {
    var title = ""
    var text = ""
    var createDate = NSDate()
    var editDate = NSDate()
    var images = [UIImage]()
    
    init(title : String, description : String, images: [UIImage]){
        self.title = title
        self.text = description
        self.images = images
    }
    
    required init(coder aDecoder : NSCoder){
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.text = aDecoder.decodeObjectForKey("text") as! String
        self.images = aDecoder.decodeObjectForKey("images") as! [UIImage]
        self.createDate = aDecoder.decodeObjectForKey("createDate") as! NSDate
        self.editDate = aDecoder.decodeObjectForKey("editDate") as! NSDate
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(text, forKey: "text")
        aCoder.encodeObject(images, forKey: "images")
        aCoder.encodeObject(createDate, forKey: "createDate")
        aCoder.encodeObject(editDate, forKey: "editDate")
    }
}