//
//  NoteTableViewCell.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 16..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    var note : Note?
    {
        didSet {
            print("Note setted")
            if note?.image != nil {
                if let image = note?.image {
                    print(tableViewCell_imageView.bounds.width)
                    print(self.contentView.bounds.width)
                    resizeImageAndImageView(image: image, size: 300)
                }
            }
            if note?.comment != nil {
                tableViewCell_commentLabel.text = note?.comment
            }
        }
    }
    
    @IBOutlet weak var tableViewCell_imageView: UIImageView!
    @IBOutlet weak var hashtagView: UIView!
    @IBOutlet weak var tableViewCell_commentLabel: UITextView!
    @IBOutlet weak var imageViewContainer: UIView!
    
    var imageViewHeightAnchor : NSLayoutConstraint!
    var imageViewWidthAnchor : NSLayoutConstraint!
    
    func resizingImageView(image imageData: Data) {
        if let image = UIImage(data: imageData) {
            let width = self.contentView.bounds.width//imageViewWidthAnchor.constant
            let height = (width) * ((image.size.height)/(image.size.width))
            imageViewHeightAnchor = imageViewContainer.heightAnchor.constraint(equalToConstant: height)
            imageViewHeightAnchor.isActive = true
            print("resizing")
        }
    }
    
    private func resizeImageAndImageView(image imageData: Data, size sizeWithRect: CGFloat) {
        resizingImageView(image: imageData)
        DispatchQueue.global(qos: .background).async {
            let newImage = UIImage(data: imageData)
            let inputImage = newImage
            DispatchQueue.main.async {
                self.tableViewCell_imageView.image = inputImage
                UIView.animate(withDuration: 0.5, animations: {
                    self.tableViewCell_imageView.alpha = 1
                })
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

fileprivate extension UIImage {
    
    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        var myImage : UIImage?
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
//        if let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
//            UIGraphicsEndImageContext()
//            myImage = newImage
//        }
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        myImage = newImage
        return myImage!
    }
    
    /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
    /// Note that the new image size is not rectSize, but within it.
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height
        
        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }
        
        let newSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
        let resized = resizedImage(newSize: newSize)
        return resized
    }
}







