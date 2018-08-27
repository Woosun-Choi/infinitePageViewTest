//
//  MainViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 26..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, PrepareForSavingNewData, SendSeletedNotePhotoData {
    
    @IBOutlet var maincontainerView: UIView!
    
    var mypageView : MainPageViewController?
    
    @IBOutlet var leftEdgeButton: UIButton!
    
    @IBOutlet var rightEdgeButton: UIButton!
    
    @IBOutlet var middleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonColorForState()
        leftEdgeButton.isSelected = true
        
        NoteEditMainViewController.noteEditDelegate = self
        NotePhotoCollectionViewController.photoCellectionDelegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func setButtonColorForState() {
        leftEdgeButton.setTitleColor(UIColor.gray, for: .normal)
        leftEdgeButton.setTitleColor(UIColor.white, for: .selected)
        rightEdgeButton.setTitleColor(UIColor.gray, for: .normal)
        rightEdgeButton.setTitleColor(UIColor.white, for: .selected)
        middleButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func bottomButtonPressed(_ sender: UIButton) {
        switch sender.currentTitle {
        case "main":
            if mypageView?.checkCurrentViewControllerType() != .NoteMainViewController {
                mypageView?.toThePage(0)
                leftEdgeButton.isSelected = true
                rightEdgeButton.isSelected = false
            }
        case "collection":
            if mypageView?.checkCurrentViewControllerType() != .MainCollectionViewController {
                mypageView?.toThePage(1)
                leftEdgeButton.isSelected = false
                rightEdgeButton.isSelected = true
            }
        case "+":
            if mypageView?.checkCurrentViewControllerType() == .NoteMainViewController {
                if let checkVC = currentView() as? DiaryViewController {
                    if checkVC.dateModel.myDate == grabNoteTableStyleVC()?.dateModel.myDate {
                        performSegue(withIdentifier: "ToCreateNote", sender: self)
                    }
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
                if let noteTableVC = grabNoteTableStyleVC() {
                    destinationVC.dateModel.myDate = noteTableVC.dateModel.myDate
                    if let settedDiary = noteTableVC.diary {
                        destinationVC.diary = settedDiary
                    }
                }
            }
        default:
            break
        }
    }
    
    private func currentView() -> UIViewController? {
        var currentVC : UIViewController?
        if let currentViewController = mypageView?.viewControllers?[0] as? DiaryViewController {
            currentVC = currentViewController
        }
        return currentVC
    }
    
    private func grabNoteTableStyleVC() -> NoteTableViewController? {
        var result : NoteTableViewController?
        if let noteMainView = currentView() as? DiaryViewController {
            if let noteTableView = noteMainView.currentView() as? NoteTableViewController {
                result = noteTableView
            }
        }
        return result
    }
    
    func saveNewData(diary diaryData: Diary?, note noteData: Note?, image imageData: Data?, thumbnail thumbnailData: Data?, comment commentData: String?, date dateData: Date?) {
        print("saving data confirmed")
        if imageData != nil {
            var newImageData: Data! {
                didSet {
                    do {
                        try Note.saveDataOrCeate(diaryData, note: noteData, image: newImageData, thumbnail: thumbnailData, comment: commentData, date: dateData!)
                        grabNoteTableStyleVC()?.loadData()
                    } catch { return }
                }
            }
            
            func resizeImageForSave() {
                let fullImage = UIImage(data: imageData!)
                let newWidth = (grabNoteTableStyleVC()?.actualMaxWidthOfContentCell)! - 30
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
                grabNoteTableStyleVC()?.loadData()
            } catch { return }
        }
    }
    
    func moveToDiaryWithSelectedNoteData(_ date: Date, note noteData: Note) {
        if let _ = mypageView?.viewControllers![0] as? NotePhotoCollectionViewController {
            mypageView?.toThePage(0)
            if let targetView = mypageView?.viewControllers![0] as? DiaryViewController {
                targetView.mypageView?.loadFisrtViewController(date)
                if let targetInnerView = targetView.currentView() as? NoteTableViewController {
                    if let targetIndex = targetInnerView.notes.index(of: noteData) {
                        let indexPath = IndexPath(row: targetIndex, section: 0)
                        targetInnerView.moveToTargetCell(indexPath)
                        leftEdgeButton.isSelected = true
                        rightEdgeButton.isSelected = false
                    }
                }
            }
        }
    }
    
}
