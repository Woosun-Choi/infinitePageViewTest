//
//  PhotoGenerator.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 22..
//  Copyright © 2018년 goya. All rights reserved.
//

import Foundation
import Photos

class PhotoGenerator {
    
    private static var imgManager : PHImageManager = PHImageManager.default()
    private static var requestOptions : PHImageRequestOptions = PHImageRequestOptions()
    private static var fetchOptions : PHFetchOptions = PHFetchOptions()
    
    class func getImageArrayWithThumbnails(_ size: CGFloat) -> [UIImage] {
        
        var myThumbnials = [UIImage]()
        
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .fastFormat
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        
        let fetchResault : PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if fetchResault.count > 0 {
            for i in 0..<fetchResault.count {
                imgManager.requestImage(for: fetchResault.object(at: i), targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: requestOptions, resultHandler: {
                    image, error in myThumbnials.append(image!)
                })
            }
        } else {
            print("You got no photos")
        }
        return myThumbnials
    }
    
    class func getOriginalImageWithImageFetchResultsArray(_ index: Int) -> Data {
        
        var myImageData : Data!
        
        requestOptions.isSynchronous = true
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.deliveryMode = .opportunistic
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        
        let fetchResault : PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if fetchResault.count > 0 {
            imgManager.requestImageData(for: fetchResault.object(at: index), options: requestOptions) {
                (data, string, orientation, hashable) in
                myImageData = data
            }
        } else {
            print("You got no photos")
        }
        return myImageData
    }
    
}

//PHImageManagerMaximumSize
//asset.pixelWidth, asset.pixelHeight
