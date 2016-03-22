//
//  NewNoteViewController.swift
//  Notes_TT
//
//  Created by Admin on 22.03.16.
//  Copyright © 2016 Khlebnikov. All rights reserved.
//

import UIKit

class NewNoteViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveNewNote(sender: AnyObject) {
        let title = titleTextField.text!
        let description = descriptionTextField.text!
        Notes.sharedInstance.addNote(title, description: description)
        
        self.navigationController?.popToRootViewControllerAnimated(true)
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
