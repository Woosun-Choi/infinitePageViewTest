//
//  MainImageCollectionViewCell.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 21..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class NotePhotoCollectionViewCell: UICollectionViewCell {
    
    var note : Note? {
        didSet {
            if let image = note?.thumbnail {
                DispatchQueue.global(qos: .background).async {
                    let inputImage = UIImage(data: image)
                    DispatchQueue.main.async {
                        self.imageView.image = inputImage
                        UIView.animate(withDuration: 0.4, animations: {
                            self.imageView.alpha = 1
                        })
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
