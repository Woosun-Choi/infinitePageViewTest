//
//  NoteTableViewCell.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 16..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    var note : Note? {
        didSet {
            print("Note setted")
            if note?.image != nil {
                if let image = note?.image {
                    DispatchQueue.global(qos: .background).async {
                        let inputImage = UIImage(data: image)?.resizedImageWithinRect(rectSize: CGSize(width: 300, height: 300))
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 0.5, animations: {
                                self.tableViewCell_imageView.alpha = 1
                            })
                            self.tableViewCell_imageView.image = inputImage
                        }
                    }
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableViewCell_imageView.alpha = 0
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension UIImage {
    
    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        var myImage : UIImage?
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        if let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            myImage = newImage
        }
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
