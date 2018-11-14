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
    func requestHashTagAction(_ tag: String, editType type: requestedHashTagManagement)
}

class HashTagItemView: UIView {
    
    static weak var delegate : HashTagDelegate?
    
    var tagItem = UILabel()
    
    var widthLimit : CGFloat?
    
    var tagString : String?
    
    var _touchType : requestedHashTagManagement!
    
    private func addGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(returnTagString))
        self.addGestureRecognizer(gesture)
    }
    
    @objc private func returnTagString() {
        if let tag = tagString {
            HashTagItemView.delegate?.requestHashTagAction(tag, editType: _touchType)
        }
    }
    
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.systemFont(ofSize: fontSize)
        font = UIFontMetrics(forTextStyle:.body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle,.font: font])
    }
    
    private func setLabel() {
        tagItem.font = UIFont.systemFont(ofSize: generalSettings.fontSize, weight: .medium)
        tagItem.textAlignment = .center
        tagItem.textColor = generalSettings.textColor
        addSubview(tagItem)
    }
    
    func createTagItem(_ tag: String) {
        
//        let targetTag = "# " + tag
//        let targetString = centeredAttributedString(targetTag, fontSize: generalSettings.fontSize)
//        let targetSize = targetString.size()
        
        setLabel()
        
        let tagItemString = NSString(string: "# " + tag)
        let size = tagItemString.size(withAttributes: [NSAttributedString.Key.font : tagItem.font])
        
        var width: CGFloat {
            guard let limit = widthLimit else { return 0 }
            let expectedSize = size.width
            if expectedSize + (generalSettings.leftAndRightMargins * 2) >= limit {
                return limit - (generalSettings.leftAndRightMargins * 2)
            } else {
                return expectedSize
            }
        }
        let height = size.height
        
        let itemSize = CGSize(width: width, height: height)
        
        //tagItem.attributedText = targetString
        tagItem.text = tagItemString as String
        tagItem.frame = CGRect(origin: generalSettings.itemOrigin, size: itemSize)
    }
    
    var viewSize: CGSize {
        let width = tagItem.frame.width + (generalSettings.leftAndRightMargins * 2)
        let height = tagItem.frame.height + (generalSettings.topAndBottomMargins * 2)
        return CGSize(width: width, height: height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame.size = viewSize
        self.backgroundColor = UIColor.clear
        self.isOpaque = false
        addGesture()
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height * generalSettings.cornerRadiusRatio)
        path.addClip()
        UIColor.lightGray.setFill()
        path.fill()
    }
}

extension HashTagItemView {
    
    fileprivate struct generalSettings {
        static var fontSize : CGFloat = 11
        static var textColor = UIColor.white
        static var textBackground = UIColor.lightGray.cgColor
        static var leftAndRightMargins : CGFloat = 8
        static var topAndBottomMargins : CGFloat = 5
        static var cornerRadiusRatio : CGFloat = 1
        static var itemOrigin : CGPoint {
            return CGPoint(x: leftAndRightMargins, y: topAndBottomMargins)
        }
    }
    
    convenience init(limitWidth width: CGFloat, tag: String, touchType: requestedHashTagManagement) {
        self.init()
        widthLimit = width
        tagString = tag
        _touchType = touchType
        
        guard let tag = tagString else { return }
        createTagItem(tag)
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    convenience init(limitWidth width: CGFloat, tag: String, fontSize: CGFloat = 11, textColor: UIColor = UIColor.white, backgroundColor: CGColor = UIColor.lightGray.cgColor, leftAndRightMargins: CGFloat = 8, topAndBottomMargins: CGFloat = 5, cornerRadiusRatio: CGFloat = 100) {
        self.init()
        widthLimit = width
        tagString = tag
        generalSettings.fontSize = fontSize
        generalSettings.textColor = textColor
        generalSettings.textBackground = backgroundColor
        generalSettings.leftAndRightMargins = leftAndRightMargins
        generalSettings.topAndBottomMargins = topAndBottomMargins
        generalSettings.cornerRadiusRatio = cornerRadiusRatio
        
        guard let tag = tagString else { return }
        createTagItem(tag)
        setNeedsDisplay()
        setNeedsLayout()
    }
}
