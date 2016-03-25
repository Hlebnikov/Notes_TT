//
//  ViewController.swift
//  Notes_TT
//
//  Created by Admin on 21.03.16.
//  Copyright © 2016 Khlebnikov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableNotes: UITableView!
    
    var openedNote: Int?
    
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
        openedNote = nil
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableNotes.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("noteCell", forIndexPath: indexPath) as! NoteCell
        cell.config(numberOfRow: indexPath.row)
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
            let prevCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: openedNote!, inSection: 0)) as! NoteCell
            prevCell.hideButtons()
        }
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! NoteCell
        cell.showButtons()
        openedNote = indexPath.row
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "edit" {
            let vc = segue.destinationViewController as! NewNoteViewController
            vc.editedNote = self.openedNote
        }
    }

}

