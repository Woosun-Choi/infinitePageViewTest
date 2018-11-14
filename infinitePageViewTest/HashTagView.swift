//
//  HashTagView.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 9. 9..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class HashTagView: UIView {
    
    private var targetWidth : CGFloat?
    
    var areaWidth : CGFloat? {
        get {
            if targetWidth == nil {
                return self.bounds.width
            } else {
                return targetWidth
            }
        }
        set { targetWidth = newValue } //targetView.bounds.width
    }
    
    fileprivate struct generalSettings {
        static var verticalEdgeMargin : CGFloat = 5
        static var horizontalEdgeMargin : CGFloat = 8
        static var itemVerticalSpace : CGFloat = 4
        static var itemHorizontalSpace : CGFloat = 4
    }
    
    var viewHeight: CGFloat {
        return estimateHeight
    }
    
    private var estimateHeight : CGFloat = 0
    
    private var nowX : CGFloat = generalSettings.horizontalEdgeMargin
    private var nowY : CGFloat = generalSettings.verticalEdgeMargin
    
    var nowOffSet : CGPoint {
        return CGPoint(x: nowX, y: nowY)
    }
    
    func clearHashItem() {
        nowX = generalSettings.horizontalEdgeMargin
        nowY = generalSettings.verticalEdgeMargin
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    lazy var widthLimit : CGFloat = {
        return areaWidth! - (generalSettings.horizontalEdgeMargin*2)
    }()
    
    func addHashItem(text: String, touchType type: requestedHashTagManagement = .fetch) {
        let hash = HashTagItemView(limitWidth: widthLimit, tag: text, touchType: type)
//        let width = hash.tagItem.frame.width
//        let height = hash.tagItem.frame.height
        let width = hash.viewSize.width
        let height = hash.viewSize.height
        
        if nowX + width > widthLimit + generalSettings.horizontalEdgeMargin {
            nowY = height + generalSettings.verticalEdgeMargin + nowY
            nowX = generalSettings.horizontalEdgeMargin
        }
        
        hash.frame = CGRect(x: nowOffSet.x, y: nowOffSet.y, width: width, height: height)
        nowX += (width + generalSettings.itemHorizontalSpace)
        estimateHeight = nowY + height + generalSettings.verticalEdgeMargin
        self.addSubview(hash)
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    var viewHeightAnchor : NSLayoutConstraint!
    var autoResize = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        if autoResize {
//            viewHeightAnchor?.isActive = false
//            viewHeightAnchor = heightAnchor.constraint(equalToConstant: estimateHeight)
//            viewHeightAnchor.isActive = true
//        }
        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: self.frame.width, height: estimateHeight))
        //        frame.size.width = self.frame.width
        //        frame.size.height = estimateHeight
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(rect: CGRect(origin: self.frame.origin, size: bounds.size))
        path.addClip()
        UIColor.clear.setFill()
        path.fill()
    }
}

extension HashTagView {
    convenience init(areaWidth with: CGFloat, verticalEdgeMargin VEMargin: CGFloat, horizontalEdgeMargin HEMargin: CGFloat, itemVerticalMargin IVMargin: CGFloat, itemHorizontalMargin IHMargin: CGFloat) {
        self.init()
        areaWidth = with
        generalSettings.verticalEdgeMargin = VEMargin
        generalSettings.horizontalEdgeMargin = HEMargin
        generalSettings.itemVerticalSpace = IVMargin
        generalSettings.itemHorizontalSpace = IHMargin
    }
}
