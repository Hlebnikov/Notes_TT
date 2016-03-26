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
        let alert = UIAlertController(title: "Delete note", message: "Do you really want delete this note?", preferredStyle: .Alert)
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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            return 45
        }
        
        if openedNote! == indexPath.row{
            return 284
        } else {
            return 45
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if openedNote != nil {
            if let prevCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: openedNote!, inSection: 0)) as? NoteCell {
                prevCell.hideButtons()
            }
        }
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! NoteCell
        cell.showButtons()
        openedNote = indexPath.row
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func showImages(images: [UIImage], startByNumber number: Int) {
        viewer.showImages(images, startForNumber: number)
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

