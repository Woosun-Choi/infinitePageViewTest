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
    
    @IBOutlet weak var tableViewCell_imageView: UIImageView!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var imageViewContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var hashtagView: UIView!
    @IBOutlet weak var hastagViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewCell_commentLabel: UITextView!
    @IBOutlet weak var commentLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bottumEdgeConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}







