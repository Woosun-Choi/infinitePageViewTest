//
//  NoteTableViewCell.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 16..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

enum requestedActionCases {
    case delete
    case edit
}

protocol RequestActionForNote: class {
    func requestAction(_ note: Note, request requestAction: requestedActionCases)
}

class NoteTableViewCell: UITableViewCell {
    
    weak var delegate : RequestActionForNote?
    
    weak var note : Note?
        {
        didSet {
            setData()
        }
    }
    
    var actualWidth : CGFloat!
    
    @IBOutlet weak var cell_ImageView: UIImageView!
    
    @IBOutlet weak var hashtagView: UIView!
    
    @IBOutlet weak var cell_CommentLabel: UILabel!
    
    @IBOutlet var contentContainer: UIView!
    
    @IBOutlet var imageViewContainer: UIView!
    
    @IBOutlet var topBlurView: UIVisualEffectView!
    
    @IBOutlet var imageViewContainerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var commentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var commentViewBottomEdgeConstraint: NSLayoutConstraint!
    
    @IBOutlet var commentViewTopEdgeConstraint: NSLayoutConstraint!
    
    var heightAnk : NSLayoutConstraint!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        switch sender.currentTitle {
        case "remove":
            delegate?.requestAction(note!, request: .delete)
        case "edit" :
            delegate?.requestAction(note!, request: .edit)
        default:
            break
        }
    }
    
    func setData() {
        if let _ = note?.noteImage?.originalImage {
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
        if let imageData = self.note?.noteImage?.originalImage {
            if let image = UIImage(data: imageData) {
                let width = actualWidth - 30 // table view - sum of margins
                let ratio = image.size.height/image.size.width
                let height = width * ratio
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
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hashtagView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        hashtagView.isHidden = true
        topBlurView.isHidden = true
    }
    
    var zeroHeight : NSLayoutConstraint!
    
    func selectedAction() {
        
        if self.topBlurView.isHidden {
            self.topBlurView.isHidden = false
        } else if !self.topBlurView.isHidden {
            self.topBlurView.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        note = nil
        cell_ImageView.image = nil
        cell_CommentLabel.text = nil
        imageViewContainerHeightConstraint.constant = 0
        commentViewBottomEdgeConstraint.constant = 0
        commentViewTopEdgeConstraint.constant = 0
        cell_ImageView.alpha = 0
        topBlurView.isHidden = true
        hashtagView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        hashtagView.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}







