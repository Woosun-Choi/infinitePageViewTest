//
//  MainViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 29..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class MainViewController: MainViewController_Default {

    override func saveNewData(diary diaryData: Diary?, note noteData: Note?, image imageData: Data?, thumbnail thumbnailData: Data?, comment commentData: String?, date dateData: Date?) {
        // can do deferent things with same data -- inheritance from motherview
    }
    
    override func moveToDiaryWithSelectedNoteData(_ date: Date, note noteData: Note) {
        // can do deferent things with same data -- inheritance from motherview
    }

}
