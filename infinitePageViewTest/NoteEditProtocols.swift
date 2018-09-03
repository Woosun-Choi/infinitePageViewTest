//
//  NoteEditProtocols.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 24..
//  Copyright © 2018년 goya. All rights reserved.
//

import Foundation

protocol PrepareForSavingNewData: class {
    func saveNewData()
}

protocol SetSavingData: class {
    func setSavingData(diary diaryData: Diary?, note noteData: Note?, image imageData: Data?, thumbnail thumbnailData: Data?, comment commentData: String?)
}
