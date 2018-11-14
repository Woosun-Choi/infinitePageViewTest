//
//  NoteDetailView.swift
//  infinitePageViewTest
//
//  Created by goya on 07/11/2018.
//  Copyright © 2018 goya. All rights reserved.
//

import UIKit

class NoteDetailView: UIView {
    
    var _imageData : Data?
    var _comment : String?
    var _hashtags : [String]?
    
    struct generalSettings {
        static let leftAndRightMargin : CGFloat = 0
        static let topAndBottomMargin : CGFloat = 0
        static let contentVerticalMargin : CGFloat = 8
    }
    
    private var estimateViewWidth: CGFloat {
        return self.bounds.width - nowX
    }
    
    private var nowX : CGFloat = generalSettings.leftAndRightMargin
    private var nowY : CGFloat = generalSettings.topAndBottomMargin
    
    private func updateNowOffSet(_ byX: CGFloat = generalSettings.leftAndRightMargin, byY:CGFloat) {
        nowX += byX
        nowY += (byY + generalSettings.contentVerticalMargin)
    }
    
    var nowOffSet : CGPoint {
        return CGPoint(x: nowX, y: nowY)
    }
    
    private func createImageView() -> UIImageView {
        let view = UIImageView()
        view.frame = CGRect.zero
        self.addSubview(view)
        return view
    }
    
    private func configureImageView(_ imageView: UIImageView) {
        guard let data = _imageData else { return }
        guard let image = UIImage(data: data) else { return }
        let ratio = calculateImageRatio(image)
        let viewSize = CGSize(width: estimateViewWidth, height: estimateViewWidth * ratio)
        imageView.frame = CGRect(origin: nowOffSet, size: viewSize)
        imageView.image = image.resizedImage(newSize: viewSize)
        
        updateNowOffSet(byY: viewSize.height)
    }
    
    private func calculateImageRatio(_ image: UIImage) -> CGFloat {
        return image.size.height/image.size.width
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.numberOfLines = 0
        label.textColor = UIColor.lightGray
        label.frame = CGRect.zero
        return label
    }
    
    private func configureLabel(_ label: UILabel) {
        guard let comment = _comment else { return }
        label.text = comment
        label.frame.origin = nowOffSet
        updateNowOffSet(byY: label.frame.height)
    }
    
    private func configureHashTagView() {
        guard let hashs = _hashtags else {return}
            let hashtagView = HashTagView()
            hashtagView.areaWidth = self.frame.width
            for hash in hashs {
                hashtagView.addHashItem(text: hash, touchType: .fetch)
            }
            hashtagView.frame.origin = nowOffSet
            self.addSubview(hashtagView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if _imageData != nil {
            configureImageView(createImageView())
            if _comment != nil {
                configureLabel(createLabel())
            }
            configureHashTagView()
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
    }
    
    convenience init(_ data: Data?, comment: String?, hashtags: [String]?) {
        self.init()
        _imageData = data
        _comment = comment
        _hashtags = hashtags
    }
    
    
}
