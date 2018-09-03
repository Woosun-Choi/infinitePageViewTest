//
//  MainViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 29..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class MainViewController: MainViewController_Default {
    
    override func moveToDiaryWithSelectedNoteData(_ date: Date, note noteData: Note) {
        if let _ = mypageView.viewControllers![0] as? NotePhotoCollectionViewController {
            mypageView.toThePage(0)
            visibleDiaryView.mypageView.setVisibleNoteTableViewWithRequestedDate(date)
            if let targetIndex = visibleDiaryView.visibleNoteTableView.notes.index(of: noteData) {
                let indexPath = IndexPath(row: targetIndex, section: 0)
                visibleDiaryView.visibleNoteTableView.moveToTargetCell(indexPath)
            }
            leftEdgeButton.isSelected = true
            rightEdgeButton.isSelected = false
        }
    }

}
