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
        guard let width = hash.itemSize?.width else { return }
        guard let height = hash.itemSize?.height else { return }
        
        if nowX + width > widthLimit + generalSettings.horizontalEdgeMargin {
            nowY = height + generalSettings.verticalEdgeMargin + nowY
            nowX = generalSettings.horizontalEdgeMargin
        }
        
        hash.frame = CGRect(x: nowX, y: nowY, width: width + (generalSettings.itemHorizontalSpace / 2), height: height + (generalSettings.itemVerticalSpace * 2))
        nowX += width + generalSettings.itemHorizontalSpace
        self.addSubview(hash)
        estimateHeight = nowY + height + generalSettings.verticalEdgeMargin
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
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
