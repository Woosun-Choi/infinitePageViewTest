//
//  MainImageCollectionViewCell.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 21..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class MainImageCollectionViewCell: UICollectionViewCell {
    
    var note : Note? {
        didSet {
            if let image = note?.image {
                let inputImage = UIImage(data: image)?.resizedImageWithinRect(rectSize: CGSize(width: 100, height: 100))
                imageView.image = inputImage
            }
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
