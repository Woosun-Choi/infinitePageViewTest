//
//  makesubviewSampleCodes.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 29..
//  Copyright © 2018년 goya. All rights reserved.
//

import Foundation

//func makeBlurView(_ view: UIView) -> UIVisualEffectView {
//    let blurEffect = UIBlurEffect(style: .regular)
//    let blurEffectView = UIVisualEffectView(effect: blurEffect)
//    blurEffectView.frame = view.bounds
//    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//    blurEffectView.alpha = 0.9
//    return blurEffectView
//}
//
//var blurView: UIVisualEffectView?
//
//func addBlurView(_ view: UIView) {
//    let blurEffect = UIBlurEffect(style: .light)
//    let blurEffectView = UIVisualEffectView(effect: blurEffect)
//    blurEffectView.frame = view.bounds
//    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//    view.addSubview(blurEffectView)
//}

//MARK: add shadow with cornerradius
//        let shadowLayer = CAShapeLayer()
//        contentContainer.layer.shadowColor = UIColor.white.cgColor
//        contentContainer.layer.shadowOpacity = 1
//        contentContainer.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
//        contentContainer.layer.shadowRadius = 3
//
//        shadowLayer.path = UIBezierPath(roundedRect: contentContainer.bounds, cornerRadius: 0).cgPath
//        shadowLayer.fillColor = UIColor.clear.cgColor
//        shadowLayer.shadowColor = UIColor.white.cgColor
//        shadowLayer.shadowPath = shadowLayer.path
//        shadowLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
//        shadowLayer.shadowOpacity = 0.5
//        shadowLayer.shadowRadius = 5
//
//        contentContainer.layer.insertSublayer(shadowLayer, at: 0)
