//
//  MainImageCollectionViewCell.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 21..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class NotePhotoCollectionViewCell: UICollectionViewCell {
    
    weak var note : Note? {
        didSet {
            if let image = note?.thumbnail {
                let inputImage = UIImage(data: image)
                imageView.image = inputImage
                UIView.animate(withDuration: 0.5, animations: { [unowned self] in
                    self.imageView.alpha = 1
                })
            }
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
