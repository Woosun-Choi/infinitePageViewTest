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
            print("SavingContent_ diary data setted")
        }
    }
    
    static var note : Note? {
        didSet {
            print("SavingContent_ note data setted")
        }
    }
    
    static var image : Data? {
        didSet {
            print("SavingContent_ image data setted")
        }
    }
    
    static var thumbnail : Data? {
        didSet {
            print("SavingContent_ thumbnail data setted")
        }
    }
    
    static var comment : String? {
        didSet {
            print("SavingContent_ comment setted")
        }
    }
    
    static var hasTag : [String]? {
        didSet {
            print("SavingContent_ hastag setted")
        }
    }
    
    static func resetSavingContent() {
        SavingContent.date = nil
        SavingContent.diary = nil
        SavingContent.note = nil
        SavingContent.image = nil
        SavingContent.thumbnail = nil
        SavingContent.comment = nil
        SavingContent.hasTag = nil
    }
}
