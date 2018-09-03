//
//  CollectionViewCell.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 22..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class ImageEditViewCollectionViewCell: UICollectionViewCell {
    
    var image : UIImage? {
        didSet {
            cell_ImageView.image = image
            UIView.animate(withDuration: 0.35) { [unowned self] in
                self.cell_ImageView.alpha = 1
            }
        }
    }
    
    @IBOutlet var cell_ImageView: UIImageView!
    
    override func awakeFromNib() {
        
    }
    
    override func prepareForReuse() {
        cell_ImageView.image = nil
        cell_ImageView.alpha = 0
    }
    
}
