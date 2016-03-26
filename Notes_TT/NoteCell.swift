//
//  NoteCell.swift
//  Notes_TT
//
//  Created by Admin on 21.03.16.
//  Copyright © 2016 Khlebnikov. All rights reserved.
//

import UIKit

protocol NoteCellDelegate {
    func showImages(images: [UIImage], startByNumber number: Int)
}

class NoteCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var titleOfNote: UILabel!
    @IBOutlet weak var descriptionArea: UITextView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var delButton: UIButton!

    private var images = [UIImage]()
    
    var delegate : NoteCellDelegate?
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! ImageCollectionCell
        cell.preview?.image = images[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return CGSize(width: 223, height: 223)
        } else {
            return CGSize(width: 93, height: 93)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("click")
        delegate?.showImages(images, startByNumber: indexPath.item)
    }
    
    func setImages(images: [UIImage]){
        self.images = images
        self.imagesCollectionView.reloadData()
    }
    
    func config(numberOfRow number: Int){
        self.backgroundColor = UIColor.pastelRainbowColor(withNumber: number)
        let note = Notes.sharedInstance.getNote(number)
        setImages(note.images)
        titleOfNote.text = note.title
        descriptionArea.text = note.text
        descriptionArea.contentOffset = CGPoint.zero
        hideButtons()
    }
    
    func showButtons(){
        editButton.alpha = 1
        delButton.alpha = 1
    }
    
    func hideButtons(){
        editButton.alpha = 0
        delButton.alpha = 0
    }
    
}
