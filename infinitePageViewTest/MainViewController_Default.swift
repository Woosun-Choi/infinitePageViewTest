//
//  MainViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 26..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class MainViewController_Default : UIViewController, PrepareForSavingNewData, SendSeletedNotePhotoData, HashTagDelegate {
    
    var mypageView : MainPageViewController!
    
    var visibleDiaryView : DiaryViewController {
        return (mypageView.visibleViewController as? DiaryViewController)!
    }
    
    var lastViewedDate : Date?
    
    @IBOutlet var maincontainerView: UIView!
    
    @IBOutlet var leftEdgeButton: UIButton!
    
    @IBOutlet var rightEdgeButton: UIButton!
    
    @IBOutlet var middleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonColorForState()
        changeButtonState(leftSelected: true, middleHidden: false, rightSelected: false)
        
        NoteEditMainViewController.noteEditDelegate = self
        NotePhotoCollectionViewController.photoCellectionDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        HashTagItemView.delegate = self
    }
    
    private func setButtonColorForState() {
        leftEdgeButton.setTitleColor(UIColor.gray, for: .normal)
        leftEdgeButton.setTitleColor(UIColor.white, for: .selected)
        rightEdgeButton.setTitleColor(UIColor.gray, for: .normal)
        rightEdgeButton.setTitleColor(UIColor.white, for: .selected)
        middleButton.setTitleColor(UIColor.white, for: .normal)
        middleButton.setTitleColor(UIColor.gray, for: .disabled)
    }
    
    private func changeButtonState(leftSelected leftButtonState: Bool?, middleHidden middleButtonState: Bool?, rightSelected rightButtonState: Bool?) {
        if leftButtonState != nil {
            leftEdgeButton.isSelected = leftButtonState!
        }
        if middleButtonState != nil {
            middleButton.isHidden = middleButtonState!
        }
        if rightButtonState != nil {
            rightEdgeButton.isSelected = rightButtonState!
        }
    }
    
    @IBAction func bottomButtonPressed(_ sender: UIButton) {
        switch sender.currentTitle {
        case "main":
            if mypageView.checkedCurrentViewType != .DiaryView {
                mypageView.toThePage(.Diary)
                if let lastDate = lastViewedDate {
                    visibleDiaryView.mypageView.setVisibleNoteTableViewWithRequestedDate(lastDate)
                    visibleDiaryView.mypageView.updateLoadedIndex(lastDate)
                }
                changeButtonState(leftSelected: true, middleHidden: false, rightSelected: false)
            }
        case "collection":
            if mypageView.checkedCurrentViewType != .PhotoCollection {
                lastViewedDate = visibleDiaryView.visibleNoteTableView.date
                mypageView.toThePage(.PhotoCollection)
                changeButtonState(leftSelected: false, middleHidden: true, rightSelected: true)
            }
        case "+":
            if mypageView.checkedCurrentViewType == .DiaryView {
                visibleDiaryView.visibleNoteTableView.selectedCellIndex = 0
                performSegue(withIdentifier: "ToCreateNote", sender: self)
//                if visibleDiaryView.dateModel.myDate == visibleDiaryView.visibleNoteTableView.date {
//                    visibleDiaryView.visibleNoteTableView.selectedCellIndex = 0
//                    performSegue(withIdentifier: "ToCreateNote", sender: self)
//                }
            }
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "MainPageView":
            if let loadedPageVC = segue.destination as? MainPageViewController {
                self.mypageView = loadedPageVC
                print("main pageview setted")
            }
        case "ToCreateNote":
            if let destinationVC = segue.destination as? NoteEditMainViewController {
                //SavingContent.resetSavingContent()
                guard let date = visibleDiaryView.visibleNoteTableView.date else { return }
                destinationVC.dateModel.myDate = date
                if let settedDiary = visibleDiaryView.visibleNoteTableView.diary {
                    destinationVC.diary = settedDiary
                }
            }
        case "ShowNotesInTag":
            if let destibationVC = segue.destination as? ShowNotesInHashTagViewController {
                destibationVC.nowTag = passingTag
            }
        default:
            break
        }
    }
    
    func saveNewData() {
        
        print("saving data confirmed")
        if SavingContent.image != nil {
            do {
                try Note.saveDataOrCeate()
                visibleDiaryView.visibleNoteTableView.loadData()
                let targetIndexPath = IndexPath(item: visibleDiaryView.visibleNoteTableView.selectedCellIndex, section: 0)
                visibleDiaryView.visibleNoteTableView.noteTableView.scrollToRow(at: targetIndexPath, at: .middle, animated: false)
            } catch { return }
            
        } else if SavingContent.image == nil {
            do {
                try Note.saveDataOrCeate()
                visibleDiaryView.visibleNoteTableView.loadData()
            } catch { return }
        }
        SavingContent.resetSavingContent()
    }
    
    func moveToDiaryWithSelectedNoteData(_ date: Date, note noteData: Note) {
        if let _ = mypageView.viewControllers![0] as? NotePhotoCollectionViewController {
            mypageView.toThePage(.Diary)
            visibleDiaryView.mypageView.setVisibleNoteTableViewWithRequestedDate(date)
            // -- update loaded index
            visibleDiaryView.mypageView.updateLoadedIndex(date)
            //
            if let targetIndex = visibleDiaryView.visibleNoteTableView.notes.index(of: noteData) {
                let indexPath = IndexPath(row: targetIndex, section: 0)
                visibleDiaryView.visibleNoteTableView.moveToTargetCell(indexPath)
            }
            changeButtonState(leftSelected: true, middleHidden: false, rightSelected: false)
        }
    }
    
    private var passingTag : String?
    
    func passingData(_ tag: String, editType type: requestedHashTagManagement) {
        if type == .fetch {
            passingTag = tag
            performSegue(withIdentifier: "ShowNotesInTag", sender: self)
        }
    }
    
}

//visibleDiaryView.view.alpha = 0
//visibleDiaryView.mypageView.loadingStatus = !visibleDiaryView.mypageView.loadingStatus
//visibleDiaryView.mypageView.requestViewUpdate()
//UIView.animate(withDuration: 1.5) {
//    self.visibleDiaryView.view.alpha = 1
//}
