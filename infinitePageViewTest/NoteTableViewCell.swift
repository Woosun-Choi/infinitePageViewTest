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
    
    var hashs : [HashTag]? {
        didSet {
            if hashs?.count != 0 {
                hashtagView.areaWidth = actualWidth - 30
                hashtagView.clearHashItem()
                for hash in hashs! {
                    hashtagView.addHashItem(text: hash.hashtag!)
                }
                hashTagViewHeightConstraint.constant = hashtagView.viewHeight + 30
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
        if note?.hashtags?.count != 0 {
            if let myNote = note {
                hashs = Note.allHashsFromNote(myNote)
            }
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
        topBlurView.isHidden = true
        hashTagViewHeightConstraint.constant = 0
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
        hashTagViewHeightConstraint.constant = 0
        //generator?.clearHashItem()
        hashtagView?.clearHashItem()
        hashs = [HashTag]()
        cell_ImageView.image = nil
        cell_CommentLabel.text = nil
        imageViewContainerHeightConstraint.constant = 0
        commentViewBottomEdgeConstraint.constant = 0
        commentViewTopEdgeConstraint.constant = 0
        cell_ImageView.alpha = 0
        topBlurView.isHidden = true
    }
    
}

//extension NoteTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return hashs?.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashTagCell", for: indexPath) as! NoteTableViewCell_CollectionViewCell
//        //cell.contentView.translatesAutoresizingMaskIntoConstraints = false
//        cell.cell_Label.text = String("# \(hashs![indexPath.row].hashtag!)")
//        return cell
//    }
//
//}

//var nowX : CGFloat = 8.0
//var nowY : CGFloat = 5.0
//
//func clearHashItem() {
//    nowX = 8
//    nowY = 5
//    for subview in hashtagView.subviews {
//        subview.removeFromSuperview()
//    }
//}
//
//func addHashItem(text: String) {
//    let hash = HashTagItemView()
//    let width = hash.setValueAndReturnSelfSize(text).width
//    let height = hash.setValueAndReturnSelfSize(text).height
//
//    if nowX + width + 10 > actualWidth - 30 {
//        nowY = height + 8 + nowY
//        nowX = 8.0
//    }
//
//    hash.frame = CGRect(x: nowX, y: nowY, width: width + 2.0, height: height + 4)
//    nowX += width + 4.0
//    hashtagView.addSubview(hash)
//}

extension NoteTableViewCell {
    
}






