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
                visibleDiaryViewsPageView.setVisibleNoteTableViewWithRequestedDate(LoadManager.lastLoadedDate)
                changeButtonState(leftSelected: true, middleHidden: false, rightSelected: false)
            }
        case "collection":
            if mypageView.checkedCurrentViewType != .PhotoCollection {
                mypageView.toThePage(.PhotoCollection)
                changeButtonState(leftSelected: false, middleHidden: true, rightSelected: true)
            }
        case "+":
            if mypageView.checkedCurrentViewType == .DiaryView {
                visibleNoteTabelView.selectedCellIndex = 0
                performSegue(withIdentifier: "ToCreateNote", sender: self)
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
                guard let date = visibleNoteTabelView.date else { return }
                destinationVC.dateModel.myDate = date
                if let settedDiary = visibleNoteTabelView.diary {
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
        if SavingContent.image != nil {
            do {
                try Note.saveDataOrCeate()
                visibleNoteTabelView.loadData()
                let targetIndexPath = IndexPath(item: visibleDiaryView.visibleNoteTableView.selectedCellIndex, section: 0)
                visibleNoteTabelView.noteTableView.scrollToRow(at: targetIndexPath, at: .middle, animated: false)
            } catch { return }
            
        } else if SavingContent.image == nil {
            do {
                try Note.saveDataOrCeate()
                visibleNoteTabelView.loadData()
            } catch { return }
        }
        SavingContent.resetSavingContent()
    }
    
    func moveToDiaryWithSelectedNoteData(_ date: Date, note noteData: Note) {
        if mypageView.viewControllers![0] is NotePhotoCollectionViewController {
            mypageView.toThePage(.Diary)
            visibleDiaryViewsPageView.setVisibleNoteTableViewWithRequestedDate(date)
            if let targetIndex = visibleNoteTabelView.notes.index(of: noteData) {
                let indexPath = IndexPath(row: targetIndex, section: 0)
                visibleNoteTabelView.moveToTargetCell(indexPath)
            }
            changeButtonState(leftSelected: true, middleHidden: false, rightSelected: false)
        }
    }
    
    private var passingTag : String?
    
    func requestHashTagAction(_ tag: String, editType type: requestedHashTagManagement) {
        if type == .fetch {
            passingTag = tag
            performSegue(withIdentifier: "ShowNotesInTag", sender: self)
        }
    }
}

extension MainViewController_Default {
    var visibleDiaryView : DiaryViewController {
        return mypageView.visibleViewController as! DiaryViewController
    }
    
    var visibleDiaryViewsPageView : DiaryPageViewController {
        return visibleDiaryView.mypageView
    }
    
    var visibleNoteTabelView : NoteTableViewController {
        return visibleDiaryView.visibleNoteTableView
    }
}

//visibleDiaryView.view.alpha = 0
//visibleDiaryView.mypageView.loadingStatus = !visibleDiaryView.mypageView.loadingStatus
//visibleDiaryView.mypageView.requestViewUpdate()
//UIView.animate(withDuration: 1.5) {
//    self.visibleDiaryView.view.alpha = 1
//}
