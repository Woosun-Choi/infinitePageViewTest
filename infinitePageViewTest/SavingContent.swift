//
//  SavingContent.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 26..
//  Copyright © 2018년 goya. All rights reserved.
//

import Foundation

struct SavingContent {
    
    static var date : Date?
    
    static var diary : Diary? {
        didSet {
            
        }
    }
    
    static var note : Note? {
        didSet {
            
        }
    }
    
    static var image : Data? {
        didSet {
            print("image data setted")
        }
    }
    
    static var thumbnail : Data? {
        didSet {
            
        }
    }
    
    static var comment : String? {
        didSet {
            print("comment setted")
        }
    }
    
    static func resetSavingContent() {
        SavingContent.date = nil
        SavingContent.diary = nil
        SavingContent.note = nil
        SavingContent.image = nil
        SavingContent.thumbnail = nil
        SavingContent.comment = nil
    }
}
