//
//  NoteEditProtocols.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 24..
//  Copyright © 2018년 goya. All rights reserved.
//

import Foundation

protocol PrepareForSavingNewData {
    func saveNewData(diary diaryData: Diary?, note noteData: Note?, image imageData: Data?, thumbnail thumbnailData: Data?, comment commentData: String?, date dateData: Date?)
}

protocol SetSavingData {
    func setSavingData(diary diaryData: Diary?, note noteData: Note?, image imageData: Data?, thumbnail thumbnailData: Data?, comment commentData: String?)
}
