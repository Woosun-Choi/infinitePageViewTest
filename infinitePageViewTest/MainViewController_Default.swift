//
//  MainViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 26..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class MainViewController_Default : UIViewController, PrepareForSavingNewData, SendSeletedNotePhotoData {
    
    var mypageView : MainPageViewController!
    
    var visibleDiaryView : DiaryViewController {
        return (mypageView.viewControllers?[0] as? DiaryViewController)!
    }
    
    @IBOutlet var maincontainerView: UIView!
    
    @IBOutlet var leftEdgeButton: UIButton!
    
    @IBOutlet var rightEdgeButton: UIButton!
    
    @IBOutlet var middleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonColorForState()
        changeButtonState(left: true, middle: false, right: false)
        
        NoteEditMainViewController.noteEditDelegate = self
        NotePhotoCollectionViewController.photoCellectionDelegate = self
        
        // Do any additional setup after loading the view.
    }
    
    private func setButtonColorForState() {
        leftEdgeButton.setTitleColor(UIColor.gray, for: .normal)
        leftEdgeButton.setTitleColor(UIColor.white, for: .selected)
        rightEdgeButton.setTitleColor(UIColor.gray, for: .normal)
        rightEdgeButton.setTitleColor(UIColor.white, for: .selected)
        middleButton.setTitleColor(UIColor.white, for: .normal)
        middleButton.setTitleColor(UIColor.gray, for: .disabled)
    }
    
    private func changeButtonState(left leftButtonState: Bool?, middle middleButtonState: Bool?, right rightButtonState: Bool?) {
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
            if mypageView.checkCurrentViewControllerType() != .NoteMainViewController {
                mypageView?.toThePage(0)
                changeButtonState(left: true, middle: false, right: false)
            }
        case "collection":
            if mypageView.checkCurrentViewControllerType() != .MainCollectionViewController {
                mypageView?.toThePage(1)
                changeButtonState(left: false, middle: true, right: true)
            }
        case "+":
            if mypageView.checkCurrentViewControllerType() == .NoteMainViewController {
                if visibleDiaryView.dateModel.myDate == visibleDiaryView.visibleNoteTableView.dateModel.myDate {
                    performSegue(withIdentifier: "ToCreateNote", sender: self)
                }
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
                SavingContent.resetSavingContent()
                destinationVC.dateModel.myDate = visibleDiaryView.visibleNoteTableView.dateModel.myDate
                if let settedDiary = visibleDiaryView.visibleNoteTableView.diary {
                    destinationVC.diary = settedDiary
                }
            }
        default:
            break
        }
    }
    
    func saveNewData(diary diaryData: Diary?, note noteData: Note?, image imageData: Data?, thumbnail thumbnailData: Data?, comment commentData: String?, date dateData: Date?) {
        
        print("saving data confirmed")
        if imageData != nil {
            var newImageData: Data! {
                didSet {
                    do {
                        try Note.saveDataOrCeate(diaryData, note: noteData, image: newImageData, thumbnail: thumbnailData, comment: commentData, date: dateData!)
                        visibleDiaryView.visibleNoteTableView.loadData()
                    } catch { return }
                }
            }
            
            func resizeImageForSave() {
                let fullImage = UIImage(data: imageData!)
                let newWidth = (visibleDiaryView.visibleNoteTableView.actualMaxWidthOfContentCell) - 30
                let newHeight = newWidth * ((fullImage?.size.height)!/(fullImage?.size.width)!)
                let newImage = fullImage?.resizedImage(newSize:CGSize(width: newWidth, height: newHeight))
                newImageData = UIImageJPEGRepresentation(newImage!, 1)
            }
            
            if noteData == nil {
                print("note nil case called")
                resizeImageForSave()
            } else if noteData != nil, noteData?.image != imageData {
                print("deferent image case called")
                resizeImageForSave()
            } else if noteData != nil, noteData?.image == imageData {
                print("same image case called")
                newImageData = imageData
            }
            
        } else if imageData == nil {
            do {
                try Note.saveDataOrCeate(diaryData, note: noteData, image: imageData, thumbnail: thumbnailData, comment: commentData, date: dateData!)
                visibleDiaryView.visibleNoteTableView.loadData()
            } catch { return }
        }
        
    }
    
    func moveToDiaryWithSelectedNoteData(_ date: Date, note noteData: Note) {
        if let _ = mypageView.viewControllers![0] as? NotePhotoCollectionViewController {
            mypageView.toThePage(0)
            visibleDiaryView.mypageView?.setVisibleNoteTableViewWithRequestedDate(date)
            if let targetIndex = visibleDiaryView.visibleNoteTableView.notes.index(of: noteData) {
                let indexPath = IndexPath(row: targetIndex, section: 0)
                visibleDiaryView.visibleNoteTableView.moveToTargetCell(indexPath)
            }
            leftEdgeButton.isSelected = true
            rightEdgeButton.isSelected = false
        }
    }
}
