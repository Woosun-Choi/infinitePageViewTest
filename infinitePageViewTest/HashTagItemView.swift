//
//  HashTagView.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 9. 7..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

enum requestedHashTagManagement {
    case delete
    case removeFromNote
    case fetch
    case addToSavingContent
    case removeFromSavingContent
}

protocol HashTagDelegate : class {
    func passingData(_ tag: String, editType type: requestedHashTagManagement)
}

class HashTagItemView: UIView {
    
    let tagItem = UILabel()
    
    static weak var delegate : HashTagDelegate?
    
    var widthLimit : CGFloat?
    
    var tagString : String?
    
    var itemSize : CGSize?
    
    var touchType : requestedHashTagManagement!
    
    var fontSize : CGFloat = 11
    var textColor = UIColor.white
    var textBackground = UIColor.lightGray.cgColor
    var leftAndRightMargins : CGFloat = 8
    var topAndBottomMargins : CGFloat = 5
    var cornerRadiusRatio : CGFloat = 100
    
    private func addGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(returnTagString))
        self.addGestureRecognizer(gesture)
    }
    
    @objc private func returnTagString() {
        if let tag = tagString {
            HashTagItemView.delegate?.passingData(tag, editType: touchType)
        }
    }
    
    private func designItem() {
        tagItem.layer.backgroundColor = textBackground
        tagItem.textColor = textColor
        tagItem.font = UIFont.systemFont(ofSize: fontSize)
        tagItem.textAlignment = .center
        
        self.addSubview(tagItem)
    }
    
    func setValueAndReturnSelfSize(_ tag: String) -> CGSize {
        designItem()
        addGesture()
        let str = NSString(string: "# " + tag)
        let itemSize = str.size(withAttributes: [NSAttributedString.Key.font : tagItem.font])
        
        var width: CGFloat {
            if let limit = widthLimit {
                let expectedSize = itemSize.width + (leftAndRightMargins * 2)
                if expectedSize > limit - (leftAndRightMargins * 2) {
                    return limit
                } else {
                    return expectedSize
                }
            } else {
                return 0
            }
        }
        
        tagItem.text = str as String
        tagItem.frame = CGRect(x: 0, y: 0, width: width, height: itemSize.height + (topAndBottomMargins * 2))
        let requieredRatio = cornerRadiusRatio / 100
        tagItem.layer.cornerRadius = (itemSize.height + topAndBottomMargins) / (2 * requieredRatio)
        
        return tagItem.frame.size
    }
}

extension HashTagItemView {
    
    convenience init(limitWidth width: CGFloat, tag tagStr: String, touchType type: requestedHashTagManagement) {
        self.init()
        widthLimit = width
        tagString = tagStr
        touchType = type
        
        guard let tag = tagString else { return }
        itemSize = setValueAndReturnSelfSize(tag)
    }
    
    convenience init(limitWidth width: CGFloat, tag tagStr: String, fontSize size: CGFloat = 11, textColor TXColor: UIColor = UIColor.white, textBackground TBColor: CGColor = UIColor.lightGray.cgColor, leftAndRightMargins LRMargin: CGFloat = 8, topAndBottomMargins TBMargin: CGFloat = 5, cornerRadiusRatio ratio: CGFloat = 100) {
        self.init()
        widthLimit = width
        tagString = tagStr
        fontSize = size
        textColor = TXColor
        textBackground = TBColor
        leftAndRightMargins = LRMargin
        topAndBottomMargins = TBMargin
        cornerRadiusRatio = ratio
        
        guard let tag = tagString else { return }
        itemSize = setValueAndReturnSelfSize(tag)
    }
}
