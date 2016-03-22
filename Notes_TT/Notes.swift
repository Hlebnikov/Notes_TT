//
//  Notes.swift
//  Notes_TT
//
//  Created by Admin on 22.03.16.
//  Copyright © 2016 Khlebnikov. All rights reserved.
//

import Foundation

class Note : NSObject{
    var title = ""
    var text = ""
    
    init(title : String, description : String){
        self.title = title
        self.text = description
    }
    
    required init(coder aDecoder : NSCoder){
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.text = aDecoder.decodeObjectForKey("text") as! String
    }

    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(text, forKey: "text")
    }
}

class Notes {
    
    var notes : [Note]?
    
    static let sharedInstance = Notes()
    
    private init(){
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "Notes") // for test like a first run
        
        let notesData = NSUserDefaults.standardUserDefaults().objectForKey("Notes") as? NSData
        if notesData != nil {
            notes = NSKeyedUnarchiver.unarchiveObjectWithData(notesData!) as? [Note]
        }
    }
    
    func addNote(title : String, description : String){
        
        if notes != nil {
            notes!.append(Note(title: title, description: description))
        } else {
            notes = [Note(title: title, description: description)]
        }
        let notesData = NSKeyedArchiver.archivedDataWithRootObject(notes!)
        NSUserDefaults.standardUserDefaults().setObject(notesData, forKey: "Notes")
    }
    
}
