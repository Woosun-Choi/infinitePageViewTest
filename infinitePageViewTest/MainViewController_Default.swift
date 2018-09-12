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
        return (mypageView.viewControllers?[0] as? DiaryViewController)!
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
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
                }
                changeButtonState(leftSelected: true, middleHidden: false, rightSelected: false)
            }
        case "collection":
            if mypageView.checkedCurrentViewType != .PhotoCollection {
                lastViewedDate = visibleDiaryView.visibleNoteTableView.dateModel.myDate
                mypageView.toThePage(.PhotoCollection)
                changeButtonState(leftSelected: false, middleHidden: true, rightSelected: true)
            }
        case "+":
            if mypageView.checkedCurrentViewType == .DiaryView {
                if visibleDiaryView.dateModel.myDate == visibleDiaryView.visibleNoteTableView.dateModel.myDate {
                    visibleDiaryView.visibleNoteTableView.selectedCellIndex = 0
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
                //SavingContent.resetSavingContent()
                destinationVC.dateModel.myDate = visibleDiaryView.visibleNoteTableView.dateModel.myDate
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
                try Note.saveDataOrCeate(SavingContent.diary, note: SavingContent.note, image: SavingContent.image, thumbnail: SavingContent.thumbnail, comment: SavingContent.comment, date: SavingContent.date)
                visibleDiaryView.visibleNoteTableView.loadData()
                let targetIndexPath = IndexPath(item: visibleDiaryView.visibleNoteTableView.selectedCellIndex, section: 0)
                visibleDiaryView.visibleNoteTableView.noteTableView.scrollToRow(at: targetIndexPath, at: .middle, animated: false)
            } catch { return }
            
        } else if SavingContent.image == nil {
            do {
                try Note.saveDataOrCeate(SavingContent.diary, note: SavingContent.note, image: SavingContent.image, thumbnail: SavingContent.image, comment: SavingContent.comment, date: SavingContent.date)
                visibleDiaryView.visibleNoteTableView.loadData()
            } catch { return }
        }
        SavingContent.resetSavingContent()
    }
    
    func moveToDiaryWithSelectedNoteData(_ date: Date, note noteData: Note) {
        if let _ = mypageView.viewControllers![0] as? NotePhotoCollectionViewController {
            mypageView.toThePage(.Diary)
            visibleDiaryView.mypageView.setVisibleNoteTableViewWithRequestedDate(date)
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





//            var newImageData: Data! {
//                didSet {
//                    do {
//                        try Note.saveDataOrCeate(SavingContent.diary, note: SavingContent.note, image: newImageData, thumbnail: SavingContent.thumbnail, comment: SavingContent.comment, date: SavingContent.date)
//                        visibleDiaryView.visibleNoteTableView.loadData()
//                        let targetIndexPath = IndexPath(item: visibleDiaryView.visibleNoteTableView.selectedCellIndex, section: 0)
//                        visibleDiaryView.visibleNoteTableView.noteTableView.scrollToRow(at: targetIndexPath, at: .middle, animated: false)
//                    } catch { return }
//                }
//            }
//
//            func resizeImageForSave() {
//                let fullImage = UIImage(data: SavingContent.image!)
//                let newWidth = (visibleDiaryView.visibleNoteTableView.actualMaxWidthOfContentCell) - 30
//                let ratio = (fullImage?.size.height)!/(fullImage?.size.width)!
//                let newHeight = newWidth * ratio
//                let newImage = fullImage?.resizedImage(newSize:CGSize(width: newWidth, height: newHeight))
//                newImageData = UIImageJPEGRepresentation(newImage!, 1)
//            }
//
//            if SavingContent.note == nil {
//                print("note nil case called")
//                resizeImageForSave()
//            } else if SavingContent.note != nil, SavingContent.note?.image != SavingContent.image {
//                print("deferent image case called")
//                resizeImageForSave()
//            } else if SavingContent.note != nil, SavingContent.note?.image == SavingContent.image {
//                print("same image case called")
//                newImageData = SavingContent.image
//            }
