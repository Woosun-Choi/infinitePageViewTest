//
//  CustomExtentions.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 21..
//  Copyright © 2018년 goya. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        var myImage : UIImage?
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        if let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            myImage = newImage
        }
        return myImage!
    }
    
    /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
    /// Note that the new image size is not rectSize, but within it.
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height
        
        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }
        
        let newSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
        let resized = resizedImage(newSize: newSize)
        return resized
    }
}

extension UIView {
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func setShadow() {
        self.layoutIfNeeded() ; self.layoutSubviews()
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowRadius = 1
    }
}

extension Date {
    
    func dateWithDateComponents() -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        let date = calendar.date(from: dateComponents)
        return date!
    }
    
    private struct datecomponentsForTransform {
        static func transformToIntCase(_ com: Calendar.Component, from date: Date) -> DateComponents {
            let calendar = Calendar.current
            return calendar.dateComponents([com], from: date)
        }
        static func transformToStringCase(dateformat format: String, from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter.string(from: date)
        }
    }
    
    enum requestedDateData {
        case day
        case weekday
        case month
        case year
    }
    
    func requestStringFromDate(data: requestedDateData) -> String? {
        switch data {
        case .day: return datecomponentsForTransform.transformToStringCase(dateformat: "dd", from: self)
        case .weekday: return datecomponentsForTransform.transformToStringCase(dateformat: "EEEE", from: self)
        case .month: return datecomponentsForTransform.transformToStringCase(dateformat: "MMM", from: self)
        case .year: return datecomponentsForTransform.transformToStringCase(dateformat: "YYYY", from: self)
        }
    }
    
    func requestIntFromDate(data: requestedDateData) -> Int? {
        switch data {
        case .day: return datecomponentsForTransform.transformToIntCase(.day, from: self).day
        case .weekday: return nil
        case .month: return datecomponentsForTransform.transformToIntCase(.month, from: self).month
        case .year: return datecomponentsForTransform.transformToIntCase(.year, from: self).year
        }
    }
}
