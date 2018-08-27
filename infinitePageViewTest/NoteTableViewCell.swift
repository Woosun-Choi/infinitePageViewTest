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

protocol RequestActionForNote {
    func requestAction(_ note: Note, request requestAction: requestedActionCases)
}

class NoteTableViewCell: UITableViewCell {
    
    var delegate : RequestActionForNote?
    
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
    @IBOutlet var imageViewContainer: UIView!
    
    @IBOutlet var imageViewContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var commentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var commentViewBottomEdgeConstraint: NSLayoutConstraint!
    @IBOutlet var commentViewTopEdgeConstraint: NSLayoutConstraint!
    
    var heightConstraint : NSLayoutConstraint!
    
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
            let width = actualWidth - 30
            let height = width * ((image?.size.height)!/(image?.size.width)!)
            //            imageViewContainerHeightConstraint.constant = height
            //            print(imageViewContainerHeightConstraint.constant)
            let newImage = image?.resizedImage(newSize: CGSize(width: width, height: height))
            self.cell_ImageView.image = newImage
            UIView.animate(withDuration: 0.5, animations: {
                self.cell_ImageView.alpha = 1
            })
        }
    }
    
    func makeBlurView(_ view: UIView) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.9
        return blurEffectView
    }
    
    var blurView: UIVisualEffectView?
    
    func addBlurView(_ view: UIView) {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hashtagView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        hashtagView.isHidden = true
        topInnerView.backgroundColor = UIColor.white.withAlphaComponent(0)
        topInnerView.isHidden = true
        topInnerView.alpha = 0
    }
    
    var zeroHeight : NSLayoutConstraint!
    
    func selectedAction() {
        
        if self.topInnerView.isHidden {
            self.topInnerView.isHidden = false
            self.topInnerView.alpha = 1
            self.blurView = self.makeBlurView(self.topInnerView)
            self.cell_ImageView.addSubview(self.blurView!)
            //self.contentContainer.dropShadow(color: UIColor.black, opacity: 0.5, offSet: CGSize(width: 3, height: 3), radius: 5, scale: true)
        } else if !self.topInnerView.isHidden {
            self.topInnerView.isHidden = true
            self.topInnerView.alpha = 0
            self.blurView?.removeFromSuperview()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}







