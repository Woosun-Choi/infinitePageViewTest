//
//  HashTagScrollView.swift
//  infinitePageViewTest
//
//  Created by goya on 14/11/2018.
//  Copyright © 2018 goya. All rights reserved.
//

import UIKit

enum hashTagScrollViewCase {
    case addingType
    case categoryType
}

class HashTagScrollView: UIScrollView {
    
    var viewType : hashTagScrollViewCase = .addingType
    
    @IBInspectable var hashTagView = HashTagView()
    
    var viewSize : CGSize {
        return CGSize(width: self.frame.width, height: hashTagView.frame.height + (generalSettings.topAndBottomMargins * 2))
    }
    
    private var offSetMargin :CGPoint{
        return CGPoint(x: generalSettings.leftAndRightMargins, y: generalSettings.topAndBottomMargins)
    }
    
    func createHashTagView(tag : [String]) {
        addSubview(hashTagView)
        hashTagView.autoResize = true
        hashTagView.backgroundColor = UIColor.clear
        hashTagView.frame.origin = offSetMargin
        hashTagView.frame.size.width = self.frame.width - (generalSettings.leftAndRightMargins * 2)
        
        var requestType: requestedHashTagManagement = .removeFromSavingContent
        if viewType == .categoryType {
            requestType = .addToSavingContent
        }
        
        for item in tag {
            hashTagView.addHashItem(text: item, touchType: requestType)
        }
        
        hashTagView.layoutSubviews()
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentSize = viewSize
        print("viewsize Width: \(viewSize.width) Height: \(viewSize.height)")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
}

extension HashTagScrollView {
    struct generalSettings {
        static var leftAndRightMargins : CGFloat = 8
        static var topAndBottomMargins : CGFloat = 8
    }
    
    convenience init(viewType: hashTagScrollViewCase) {
        self.init()
        self.viewType = viewType
    }
}
