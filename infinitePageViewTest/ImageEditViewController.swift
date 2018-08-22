//
//  ImageEditViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 21..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class ImageEditViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    static var delegate: sendSavingData?
    
    var seledtedImage : Data? {
        didSet {
            imageView.image = UIImage(data: seledtedImage!)
            ImageEditViewController.delegate?.sendSavingData(image: seledtedImage!, comment: nil)
        }
    }
    
    var images = [UIImage]()

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        DispatchQueue.global(qos: .background).async {
            let imageArray = PhotoGenerator.getImageArrayWithThumbnails(200)
            DispatchQueue.main.async {
                self.images = imageArray
                self.imageCollectionView.reloadData()
            }
        }
        //images = PhotoGenerator.getImageArrayWithThumbnails(200)

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageEditViewCollectionViewCell
        cell.cell_ImageView.alpha = 0
        cell.image = images[indexPath.row]
        //cell.cell_ImageView.image = images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.global(qos: .background).async {
        let result = 
            PhotoGenerator.getOriginalImageWithImageFetchResultsArray(indexPath.row)
            DispatchQueue.main.async {
                self.seledtedImage = result
            }
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
        return UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
    }
    //Cell layout end
}
