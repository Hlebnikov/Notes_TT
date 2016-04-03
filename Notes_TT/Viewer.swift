//
//  Viewer.swift
//  Notes_TT
//
//  Created by Александр on 25.03.16.
//  Copyright © 2016 Khlebnikov. All rights reserved.
//

import UIKit

protocol ViewerDelegate {
    func clickedDeleteButton()
}

class Viewer: UIView {

    @IBOutlet weak var imageView: UIImageView!
    
    var images = [UIImage]()
    var currentImageNumber = 0
    
    var delegate : ViewerDelegate?
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBAction func closeButtonClick(sender: AnyObject) {
        close()
    }
    
    var view: UIView!
    
    @IBAction func deleteButtonClick(sender: AnyObject) {
        delegate?.clickedDeleteButton()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(Viewer.nextImage))
        swipeLeft.direction = .Left
        self.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(Viewer.prevImage))
        swipeRight.direction = .Right
        self.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(Viewer.close))
        swipeUp.direction = .Up
        self.addGestureRecognizer(swipeUp)
    }
    
    func nextImage(){
        currentImageNumber = (currentImageNumber + 1)%images.count
        imageView.image = images[currentImageNumber]
    }
    
    func prevImage(){
        currentImageNumber = (currentImageNumber + images.count - 1)%images.count
        imageView.image = images[currentImageNumber]
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "Viewer", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func show(){
        UIView.animateWithDuration(0.4) { 
            self.alpha = 1
        }
    }
    
    func close(){
        UIView.animateWithDuration(0.4) {
            self.alpha = 0
        }
    }
    
    func showImages(images: [UIImage], startForNumber number: Int){
        self.images = images
        currentImageNumber = number
        imageView.image = images[currentImageNumber]
        show()
    }

}
