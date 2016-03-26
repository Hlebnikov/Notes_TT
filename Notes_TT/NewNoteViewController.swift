//
//  NewNoteViewController.swift
//  Notes_TT
//
//  Created by Admin on 22.03.16.
//  Copyright © 2016 Khlebnikov. All rights reserved.
//

import UIKit

class NewNoteViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var viewer: Viewer!
    
    var selectedImages = [UIImage]()
    var imagePicker = UIImagePickerController()
    
    var editedNote: Int?
    
    @IBOutlet weak var titleOfView: UINavigationItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var attachedImagesCollectionView: UICollectionView!
    
    @IBAction func chooseImage(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if editedNote != nil {
            titleOfView.title = "Edit note"
            let note = Notes.sharedInstance.getNote(editedNote!)
            titleTextField.text = note.title
            descriptionTextField.text = note.text
            selectedImages = note.images
        }
        
        view.backgroundColor = UIColor.pastelRainbowColor(withNumber: 9)
        viewer.setDelAction { 
            self.selectedImages.removeAtIndex(self.viewer.currentImageNumber)
            self.attachedImagesCollectionView.reloadData()
            self.viewer.close()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveNewNote(sender: AnyObject) {
        let title = titleTextField.text!
        let description = descriptionTextField.text!
        
        let note = Note(title: title, description: description, images: selectedImages)
        if editedNote == nil {
            Notes.sharedInstance.addNote(note)
        } else {
            Notes.sharedInstance.replaceNote(note, inPosition: editedNote!)
        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.attachedImagesCollectionView.reloadData()
        })
        selectedImages.append(image)
        print(selectedImages)
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellImage", forIndexPath: indexPath) as! ImageCollectionCell
        cell.preview?.image = selectedImages[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return CGSize(width: 196, height: 196)
        } else {
            return CGSize(width: 96, height: 96)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        viewer.showImages(selectedImages, startForNumber: indexPath.row)
    }

}
