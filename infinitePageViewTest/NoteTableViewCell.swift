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
    
    weak var note : Note?{ didSet {setData {self.updateLayingouts()} } }
    
    var actualWidth : CGFloat!
    
    var hashs : [HashTag]? {
        didSet {
            if hashs?.count != 0 {
                hashtagView.areaWidth = actualWidth - 16
                for hash in hashs! {
                    hashtagView.addHashItem(text: hash.hashtag!)
                }
                hashTagViewHeightConstraint.constant = hashtagView.viewHeight
            }
        }
    }
    
    var hasTagCollectionViewLayout : UICollectionViewFlowLayout?
    
    @IBOutlet weak var cell_ImageView: UIImageView!
    
    @IBOutlet weak var hashtagView: HashTagView!
    
    @IBOutlet weak var cell_CommentLabel: UILabel!
    
    @IBOutlet var contentContainer: UIView!
    
    @IBOutlet var imageViewContainer: UIView!
    
    @IBOutlet var topBlurView: UIVisualEffectView!
    
    @IBOutlet var imageViewContainerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var commentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var commentViewBottomEdgeConstraint: NSLayoutConstraint!
    
    @IBOutlet var commentViewTopEdgeConstraint: NSLayoutConstraint!
    
    @IBOutlet var hashTagViewHeightConstraint: NSLayoutConstraint!
    
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
    
    func updateLayingouts() {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    func setData(completion:(() -> Void)?) {
        setImageAndResizingImageView(actualWidth, completion: nil)
        if note?.comment == nil {
            commentViewHeightConstraint.constant = 0
        } else {
            guard let comment = note?.comment else {return}
            commentViewTopEdgeConstraint.constant = 8
            commentViewBottomEdgeConstraint.constant = 8
            cell_CommentLabel.text = comment
        }
        if note?.hashtags?.count != 0 {
            if let newNote = note {
                hashs = Note.allHashsFromNote(newNote)
            }
        }
        completion?()
    }
    
    func setImageAndResizingImageView(_ actualWidth: CGFloat, completion: (() -> Void)?) {
        guard let data = self.note?.noteImage?.originalImage else { imageViewContainerHeightConstraint.constant = 0; return }
        guard let image = UIImage(data: data) else { return }
        
        let width = actualWidth - 16
        let ratio = image.size.height/image.size.width
        let height = width * ratio
        
        imageViewContainerHeightConstraint.constant = height
        
        DispatchQueue.main.async {
            self.cell_ImageView.image = image.resizedImage(newSize: CGSize(width: width, height: height))
            UIView.animate(withDuration: 0.5, animations: {
                self.cell_ImageView.alpha = 1
                completion?()
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topBlurView.isHidden = true
        hashtagView.autoResize = false
        hashTagViewHeightConstraint.constant = 0
    }
    
    func selectedAction() {
        if self.topBlurView.isHidden {
            self.topBlurView.isHidden = false
        } else if !self.topBlurView.isHidden {
            self.topBlurView.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentContainer.setShadow()
    }
    
    override func prepareForReuse() {
        resetCellData()
        resetCellLayout()
    }
    
    func resetCellData() {
        note = nil
        cell_ImageView.image = nil
        cell_CommentLabel.text = nil
        hashs = [HashTag]()
    }
    
    func resetCellLayout() {
        hashTagViewHeightConstraint.constant = 0
        hashtagView?.clearHashItem()
        commentViewBottomEdgeConstraint.constant = 0
        commentViewTopEdgeConstraint.constant = 0
        cell_ImageView.alpha = 0
        topBlurView.isHidden = true
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    
}

extension NoteTableViewCell {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return cell_ImageView
    }
}






