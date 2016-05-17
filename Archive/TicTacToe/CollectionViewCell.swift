//
//  CollectionViewCell.swift
//  TicTacToe
//
//  Created by admin on 3/4/16.
//  Copyright © 2016 Hen&Amit All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell{
    var isFlipped = false
    var imageView: UIImageView!
    var backImageView: UIImageView!
    private var image: UIImage?
    
    
    @IBOutlet weak var cellLabel: UILabel!
    
    func setBackImage() {
        if(backImageView==nil) {
            backImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            backImageView.contentMode = UIViewContentMode.ScaleToFill
            backImageView.image = UIImage(named: "card.png")
            contentView.addSubview(backImageView)
        }
        
    }
    func setFrontImage(im: UIImage) {
        image = im
        if(imageView == nil) {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
        }
        
        imageView.image = image
    }
    
    func setImage(im: UIImage) {
        image = im
        if(imageView == nil) {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            contentView.addSubview(imageView)
            
        }
        
        imageView.image = image
    }
    
    func getImage()->UIImage{
        return image!
    }
    
    func drawRect() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.blueColor().CGColor
    }
    
    func disableRect(){
        self.layer.borderWidth = 0
    }
    
    func flipCard() {
        if (!isFlipped) {
            UIView.transitionFromView(backImageView, toView: imageView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        } else {
            UIView.transitionFromView(imageView, toView: backImageView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
        }
        isFlipped = !isFlipped
    }
    
    
}
