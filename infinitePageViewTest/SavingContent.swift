//
//  SavingContent.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 24..
//  Copyright © 2018년 goya. All rights reserved.
//

import Foundation

class SavingContent {
    static var image : Data? {
        didSet {
            print("image data setted")
        }
    }
    static var comment : String? {
        didSet {
            print("comment setted")
        }
    }
    
    static func resetSavingContent() {
        SavingContent.image = nil
        SavingContent.comment = nil
    }
}
