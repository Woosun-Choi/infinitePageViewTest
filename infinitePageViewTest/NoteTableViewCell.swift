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
            setData()
        }
    }
    
    var actualWidth : CGFloat!
    
    @IBOutlet var contentContainer: UIView!
    @IBOutlet weak var cell_ImageView: UIImageView!
    @IBOutlet weak var hashtagView: UIView!
    @IBOutlet weak var cell_CommentLabel: UILabel!
    @IBOutlet var topInnerView: UIView!
    
    @IBOutlet var imageViewContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var commentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var commentViewBottomEdgeConstraint: NSLayoutConstraint!
    @IBOutlet var commentViewTopEdgeConstraint: NSLayoutConstraint!
    
    var heightConstraint : NSLayoutConstraint!
    
    func setData() {
        if let _ = note?.image {
            setImageAndResizingImageView(actualWidth)
        }
        if let comment = note?.comment {
            commentViewTopEdgeConstraint.constant = 8
            commentViewBottomEdgeConstraint.constant = 10
            cell_CommentLabel.text = comment
        }
        if note?.comment == nil {
            commentViewHeightConstraint.constant = 0
        }
    }
    
    func setImageAndResizingImageView(_ actualWidth: CGFloat) {
        if let imageData = note?.image {
            let image = UIImage(data: imageData)
            let width = actualWidth - 20
            let height = width * ((image?.size.height)!/(image?.size.width)!)
            imageViewContainerHeightConstraint.constant = height
            DispatchQueue.global(qos: .background).async {
                let newImage = image
                DispatchQueue.main.async {
                    self.cell_ImageView.image = newImage
                    UIView.animate(withDuration: 0.5, animations: {
                        self.cell_ImageView.alpha = 1
                    })
                }
            }
        }
        self.contentContainer.layer.borderWidth = 0.5
        self.contentContainer.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hashtagView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        topInnerView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}







