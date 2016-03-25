//
//  SettingsViewController.swift
//  Notes_TT
//
//  Created by Александр on 25.03.16.
//  Copyright © 2016 Khlebnikov. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBAction func deleteAll(sender: AnyObject) {
        let alert = UIAlertController(title: "Delete all notes?", message: "This action is uncancelable", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { (alertAction) in
            Notes.sharedInstance.deleteAll()
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
