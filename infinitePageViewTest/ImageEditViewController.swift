//
//  ImageEditViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 21..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit
import Photos

class ImageEditViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    static weak var delegate: SetSavingData?
    
    var thumbnail : Data? {
        didSet {
            
        }
    }
    
    var seledtedImage : Data? {
        didSet {
            imageView.image = UIImage(data: seledtedImage!)
            ImageEditViewController.delegate?.setSavingData(diary: nil, note: nil, image: seledtedImage!,thumbnail: thumbnail, comment: nil)
        }
    }
    
    var images = [UIImage]()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinnerContainer.isHidden = true
        spinnerContainer.backgroundColor = UIColor.init(red: 243/255, green: 243/255, blue: 243/255, alpha: 0.45)
        spinnerContainer.layer.cornerRadius = 8
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageView.layer.backgroundColor = UIColor.white.withAlphaComponent(0).cgColor
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor(red: 50/255, green: 51/255, blue: 51/255, alpha: 0.7).cgColor
        
        authorizeChecker()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkData()
    }
    
    func checkData() {
        if SavingContent.image != nil {
            seledtedImage = SavingContent.image
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageEditViewCollectionViewCell
        cell.image = images[indexPath.row]
        return cell
    }
    
    //MARK: Loading Block settings
    
    var nowLoading = false
    
    @IBOutlet var spinnerContainer: UIView!
    
    @IBOutlet var loadingSpinner: UIActivityIndicatorView!
    
    func starSpinner() {
        nowLoading = true
        spinnerContainer.isHidden = false
        loadingSpinner.startAnimating()
    }
    
    func endSpinner() {
        nowLoading = false
        spinnerContainer.isHidden = true
        loadingSpinner.stopAnimating()
    }
    
    // Loading block ended
    
    private var selectedIndex : Int?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageEditViewCollectionViewCell {
            if nowLoading == false && selectedIndex != indexPath.row {
                starSpinner()
                thumbnail = cell.cell_ImageView.image!.jpegData(compressionQuality: 1)
                DispatchQueue.global(qos: .background).async {
                    let result =
                        PhotoGenerator.getOriginalImageWithSize(indexPath.row, size: 600)
                    DispatchQueue.main.async {
                        self.seledtedImage = result
                        self.endSpinner()
                    }
                }
                selectedIndex = indexPath.row
            }
        }
    }
    
    func authorizeChecker() {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
            DispatchQueue.global(qos: .background).async {
                let imageArray = PhotoGenerator.getImageArrayWithThumbnails(100)
                DispatchQueue.main.async {
                    self.images = imageArray
                    self.imageCollectionView.reloadData()
                }
            }
        } else if (status == PHAuthorizationStatus.denied) {
            // Access has been denied.
        } else if (status == PHAuthorizationStatus.notDetermined) {
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    DispatchQueue.global(qos: .background).async {
                        let imageArray = PhotoGenerator.getImageArrayWithThumbnails(100)
                        DispatchQueue.main.async {
                            self.images = imageArray
                            self.imageCollectionView.reloadData()
                        }
                    }
                } else {  }
            })
        }
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
        }
    }
    
    
}

extension ImageEditViewController: UICollectionViewDelegateFlowLayout {
    
    //MARK: Cell layout settings
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 4 - 7.5
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    }
    //Cell layout end
}
