//
//  Notes.swift
//  Notes_TT
//
//  Created by Admin on 22.03.16.
//  Copyright © 2016 Khlebnikov. All rights reserved.
//

import Foundation
import UIKit

enum NotesError : ErrorType{
    case OutOfRange
}

class Notes {
    
    private var notes : [Note]
    
    var count: Int {
        return notes.count
    }
    
    static let sharedInstance = Notes()
    
    private init(){
//        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "Notes") // for test like a first run
        
        let notesData = NSUserDefaults.standardUserDefaults().objectForKey("Notes") as? NSData
        if notesData != nil {
            notes = NSKeyedUnarchiver.unarchiveObjectWithData(notesData!) as! [Note]
        } else {
            notes = []
        }
    }
    
    func addNote(note: Note){
        notes.append(note)
        saveChanges()
    }
    
    func replaceNote(note: Note, inPosition number: Int) {
        notes[number] = note
        saveChanges()
    }
    
    func getNote(number: Int) -> Note {
        return self.notes[number]
    }
    
    func deleteNote(number: Int) throws {
        guard number >= 0 && number < notes.count else {
            throw NotesError.OutOfRange
        }
        
        notes.removeAtIndex(number)
        saveChanges()
    }
    
    func deleteAll(){
        notes = []
        saveChanges()
    }
    
    func saveChanges(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let notesData = NSKeyedArchiver.archivedDataWithRootObject(self.notes)
            NSUserDefaults.standardUserDefaults().setObject(notesData, forKey: "Notes")
        }
    }
    
}
