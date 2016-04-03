//
//  ViewController.swift
//  Notes_TT
//
//  Created by Admin on 21.03.16.
//  Copyright © 2016 Khlebnikov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NoteCellDelegate {

    @IBOutlet weak var tableNotes: UITableView!
    
    var openedNote: Int?
    @IBOutlet weak var viewer: Viewer!
    
    @IBAction func deleteNote(sender: AnyObject) {
        let alert = UIAlertController(title: "Delete note?", message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { (alertAction) in
            
            do {
                try Notes.sharedInstance.deleteNote(self.openedNote!)
                self.openedNote = nil
                self.tableNotes.reloadData()
            } catch {
                print("delete error")
            }
            
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewer.deleteButton.hidden = true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewer.close()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableNotes.reloadData()
        if openedNote != nil {
            let openedCell = tableNotes.cellForRowAtIndexPath(NSIndexPath(forItem: openedNote!, inSection: 0)) as! NoteCell
            openedCell.showButtons()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("noteCell", forIndexPath: indexPath) as! NoteCell
        cell.config(numberOfRow: indexPath.row)
        cell.delegate = self
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Notes.sharedInstance.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if openedNote == nil {
            return CLOSED_CELL_HEIGHT
        }
        
        if openedNote! == indexPath.row{
            return OPENED_CELL_HEIGHT
        } else {
            return CLOSED_CELL_HEIGHT
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if openedNote != nil {
            if openedNote == indexPath.row {return} // open only when cell not open
            if let prevCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: openedNote!, inSection: 0)) as? NoteCell {
                prevCell.hideButtons()
            }
        }
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! NoteCell
        cell.showButtons()
        openedNote = indexPath.row
        tableView.beginUpdates()
        // calling heightForRowAtIndexPath жуковского 115-54
        tableView.endUpdates()
        print(Notes.sharedInstance.getNote(indexPath.row).id)
    }
    
    func showImages(images: [UIImage], startByNumber number: Int) {
        viewer.showImages(images, startForNumber: number)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil {
            switch segue.identifier! {
            case "edit":
                let vc = segue.destinationViewController as! NewNoteViewController
                vc.editedNote = self.openedNote
                vc.view.backgroundColor = UIColor.pastelRainbowColor(withNumber: self.openedNote!)
            default:
                let vc = segue.destinationViewController as! NewNoteViewController
                vc.view.backgroundColor = UIColor.pastelRainbowColor(withNumber: Notes.sharedInstance.count)
            }
        }
    }
}

