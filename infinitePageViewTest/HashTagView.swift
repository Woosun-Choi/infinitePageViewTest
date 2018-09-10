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
        get { return targetWidth }
        set { targetWidth = newValue } //targetView.bounds.width
    }
    
    fileprivate struct generatorSettings {
        static var verticalEdgeMargin : CGFloat = 5
        static var horizontalEdgeMargin : CGFloat = 8
        static var itemVerticalSpace : CGFloat = 4
        static var itemHorizontalSpace : CGFloat = 4
    }
    
    var viewHeight: CGFloat {
        return nowY
    }
    
    private var nowX : CGFloat = generatorSettings.horizontalEdgeMargin
    private var nowY : CGFloat = generatorSettings.verticalEdgeMargin
    
    func clearHashItem() {
        nowX = generatorSettings.horizontalEdgeMargin
        nowY = generatorSettings.verticalEdgeMargin
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func addHashItem(text: String, touchType type: requestedHashTagManagement = .fetch) {
        let hash = HashTagItemView()
        hash.touchType = type
        let width = hash.setValueAndReturnSelfSize(text).width
        let height = hash.setValueAndReturnSelfSize(text).height
        let fullWidth = areaWidth ?? self.bounds.width
        
        if nowX + width + (generatorSettings.horizontalEdgeMargin * 2) > fullWidth {
            nowY = height + generatorSettings.verticalEdgeMargin + nowY
            nowX = generatorSettings.horizontalEdgeMargin
        }
        
        hash.frame = CGRect(x: nowX, y: nowY, width: width + (generatorSettings.itemHorizontalSpace / 2), height: height + (generatorSettings.itemVerticalSpace * 2))
        nowX += width + generatorSettings.itemHorizontalSpace
        self.addSubview(hash)
    }
    
    func initializingHashView(areaWidth with: CGFloat, verticalEdgeMargin VEMargin: CGFloat, horizontalEdgeMargin HEMargin: CGFloat, itemVerticalMargin IVMargin: CGFloat, itemHorizontalMargin IHMargin: CGFloat) {
        areaWidth = with
        generatorSettings.verticalEdgeMargin = VEMargin
        generatorSettings.horizontalEdgeMargin = HEMargin
        generatorSettings.itemVerticalSpace = IVMargin
        generatorSettings.itemHorizontalSpace = IHMargin
    }

}
