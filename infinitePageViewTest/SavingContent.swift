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
    
    static var diary : Diary?
    
    static var note : Note?
    
    static var image : Data?
    
    static var thumbnail : Data?
    
    static var comment : String?
    
    static var hashTag : [String]?
    
    static func resetSavingContent() {
        SavingContent.date = nil
        SavingContent.diary = nil
        SavingContent.note = nil
        SavingContent.image = nil
        SavingContent.thumbnail = nil
        SavingContent.comment = nil
        SavingContent.hashTag = nil
    }
}
