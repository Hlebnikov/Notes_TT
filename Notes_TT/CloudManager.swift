//
//  CloudManager.swift
//  Notes_TT
//
//  Created by Александр on 27.03.16.
//  Copyright © 2016 Khlebnikov. All rights reserved.
//

import Foundation
import CloudKit
import UIKit
import SystemConfiguration

class CloudManager
{
    let container: CKContainer?
    let publicDB: CKDatabase?
    
    var isFinishLoaded = false
    
    
    var selectedRecord: CKRecord?
    
    
    
    init() {
        container = CKContainer.defaultContainer()
        publicDB = container!.publicCloudDatabase
    }
    
    func SaveNote(note: Note, complitionHandler : (error : NSError?)->() )
    {
        if !networkIsConnected() {
            return
        }
        
        let noteRecord = CKRecord(recordType: "Note")
        noteRecord.setValue(note.createDate, forKey: "createDate")
        noteRecord.setValue(note.editDate, forKey: "editDate")
        noteRecord.setValue(note.title, forKey: "title")
        noteRecord.setValue(note.text, forKey: "text")
        
        publicDB?.saveRecord(noteRecord, completionHandler: { (record, error) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                complitionHandler(error: error)
            })
        })
    }
    
    func loadAllNotes(complitionHandler : (error : NSError?)->()) -> [Note]
    {
        if !networkIsConnected() {
            return []
        }
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Note", predicate: predicate)
        var notes = [Note]()
        
        publicDB?.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
            if error != nil {
                print("Error: ", error?.localizedDescription)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    complitionHandler(error: error)
                })
            } else {
                
                for result in results! {
                    
                    let title = result.valueForKey("title") as! String
                    let text = result.valueForKey("text") as! String
                    let createDate = result.valueForKey("createDate") as! NSDate
                    let editDate = result.valueForKey("editDate") as! NSDate
                    
                    let note = Note(title: title, description: text, images: [])
                    note.createDate = createDate
                    note.editDate = editDate
                    notes.append(note)
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    complitionHandler(error: error)
                })
            }
        }
        return notes
    }
    
    func deleteNoteWithTitle(title: NSString, reloadDataMethod: () -> ())
    {
        if !networkIsConnected() {
            return
        }
        
        let predicate = NSPredicate(format: "title = %@", title)
        let query = CKQuery(recordType: "Note", predicate: predicate)
        
        publicDB?.performQuery(query, inZoneWithID: nil,
                               completionHandler: ({results, error in
                                
                                if error != nil
                                {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        print ("error: ", error!.localizedDescription)
                                    }
                                }
                                else
                                {
                                    if results!.count > 0 {
                                        
                                        let record = results![0]
                                        self.publicDB?.deleteRecordWithID(record.recordID, completionHandler: ({returnRecord, error in
                                            dispatch_async(dispatch_get_main_queue()) {
                                                reloadDataMethod()
                                            }
                                        }))
                                    }
                                    else
                                    {
                                        dispatch_async(dispatch_get_main_queue()) {
                                            reloadDataMethod()
                                        }
                                    }
                                }
                               }))
        
    }
    
    
    func networkIsConnected() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = flags == .Reachable
        let needsConnection = flags == .ConnectionRequired
        
        return isReachable && !needsConnection
    }
    
    
    
}