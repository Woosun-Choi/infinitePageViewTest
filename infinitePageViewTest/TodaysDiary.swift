//
//  TodaysDiary.swift
//  infinitePageViewTest
//
//  Created by goya on 12/11/2018.
//  Copyright © 2018 goya. All rights reserved.
//

import Foundation

struct TodaysDiary {
    
    var date : Date?
    var diary : Diary?
    
    init(date: Date, diary: Diary?) {
        self.date = date
        self.diary = diary
    }
}
