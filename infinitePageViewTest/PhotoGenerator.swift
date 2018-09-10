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
        requestOptions.resizeMode = .fast
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
    
    class func getOriginalImageWithImageFetchResultsArray(_ index: Int) -> Data? {
        
        var myImageData : Data!
        
        requestOptions.resizeMode = .exact
        requestOptions.isSynchronous = true
        requestOptions.isNetworkAccessAllowed = true
        //requestOptions.deliveryMode = .opportunistic
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        
        let fetchResault : PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if fetchResault.count > 0 {
            imgManager.requestImageData(for: fetchResault.object(at: index), options: requestOptions) {
                (data, string, orientation, hashable) in
                myImageData = data
            }
            return myImageData
        } else {
            return nil
        }
    }
    
    class func getOriginalImageWithSize(_ index: Int, size targetSize: CGFloat) -> Data? {
        
        var myImageData : Data!
        
        requestOptions.resizeMode = .exact
        requestOptions.isSynchronous = true
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.deliveryMode = .opportunistic
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        
        let fetchResault : PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if fetchResault.count > 0 {
            let asset = fetchResault.object(at: index)
            let ratio = CGFloat(Double(asset.pixelHeight)/Double(asset.pixelWidth))
            print("height: \(asset.pixelHeight) width: \(asset.pixelWidth)")
            print(ratio)
            let newWidth = targetSize
            let newHeight = newWidth * ratio
            let newSize = CGSize(width: newWidth, height: newHeight)
            imgManager.requestImage(for: asset, targetSize: newSize, contentMode: .aspectFill, options: requestOptions, resultHandler: {
                image, error in
                if let myImage = image {
                    myImageData = UIImageJPEGRepresentation(myImage, 1)
                    print(myImage.size.width)
                }
            })
            return myImageData
        } else {
            return nil
        }
    }
    
    class func resizeImageWithNewWidth(imageData data: Data, newWidth width: CGFloat) -> UIImage? {
        if let image = UIImage(data: data) {
            let newWidth = width
            let ratio = image.size.height/image.size.width
            let newHeight = width * ratio
            let newSize = CGSize(width: newWidth, height: newHeight)
            return image.resizedImage(newSize: newSize)
        }
        return nil
    }
    
}

//PHImageManagerMaximumSize
//asset.pixelWidth, asset.pixelHeight

//        if fetchResault.count > 0 {
//
//            let asset = fetchResault.object(at: index)
//
//            func newSize() -> CGSize {
//                let imageRatio = asset.pixelHeight / asset.pixelWidth
//                var newWidth: CGFloat!
//                var newHeight: CGFloat!
//                if imageRatio > 1 {
//                    newHeight = 1000
//                    newWidth = newHeight * CGFloat(imageRatio)
//                    print("ratio vertically setted")
//                } else if imageRatio <= 1 {
//                    newWidth = 1000
//                    newHeight = newWidth * CGFloat(imageRatio)
//                    print("ratio horigentally setted")
//                }
//                return CGSize(width: newWidth, height: newHeight)
//            }
//
//            imgManager.requestImage(for: asset, targetSize: newSize(), contentMode: .aspectFit, options: requestOptions) { (image, error) in
//                if let newImage = image {
//                    myImageData = UIImageJPEGRepresentation(newImage, 0.8)
//                    print(newImage.size.width)
//                    print(newImage.size.height)
//                }
//            }
//        }
