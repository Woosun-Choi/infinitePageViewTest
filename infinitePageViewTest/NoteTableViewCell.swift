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
            if let image = note?.image {
                resizeImageAndImageView(image: image)
            }
            if let comment = note?.comment {
                tableViewCell_commentLabel.text = comment
            }
        }
    }
    
    @IBOutlet weak var tableViewCell_imageView: UIImageView!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet var imageViewContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var hashtagView: UIView!
    @IBOutlet weak var hastagViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewCell_commentLabel: UITextView!
    @IBOutlet weak var commentLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var contentContainer: UIView!
    
    @IBOutlet var bottumEdgeConstraint: NSLayoutConstraint!
    
    @IBOutlet var stackViewBottomEdgeConstraint: NSLayoutConstraint!
    
    
    fileprivate func resizingImageView(image imageData: UIImage?) {
//        bottumEdgeConstraint.isActive = false
//        stackViewBottomEdgeConstraint.isActive = false
        if let image = imageData {
            let height = (self.contentView.bounds.width) * ((image.size.height)/(image.size.width))
            //tableViewCell_imageView.bounds.size.height = height
            imageViewContainerHeight.constant = height
            print(imageViewContainerHeight.constant)
            print("resized")
        }
    }
    
    fileprivate func resizeImageAndImageView(image imageData: Data) {
        let inputImage = UIImage(data: imageData)
        resizingImageView(image: inputImage)
//        bottumEdgeConstraint.isActive = true
//        stackViewBottomEdgeConstraint.isActive = true
        print(self.contentView.bounds.width)
        print(self.contentView.bounds.height)
        DispatchQueue.global(qos: .background).async {
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







