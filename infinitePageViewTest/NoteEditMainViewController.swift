//
//  NoteEditMainViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 21..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class NoteEditMainViewController: UIViewController, SetSavingData {
    
    static weak var noteEditDelegate : PrepareForSavingNewData?
    
    let dateModel = DateCoreModel()
    
    private var myPageView : NoteEditPageViewController!
    
    var diary : Diary? {
        didSet {
            if let settedDiary = diary {
                SavingContent.diary = settedDiary
            }
        }
    }
    
    var note : Note? {
        didSet {
            SavingContent.note = note
            if let image = note?.image {
                SavingContent.image = image
            }
            if let comment = note?.comment {
                SavingContent.comment = comment
            }
            if let thumbnail = note?.thumbnail {
                SavingContent.thumbnail = thumbnail
            }
        }
    }
    
    @IBOutlet var leftButtonItem: UIButton!
    @IBOutlet var rightButtonItem: UIButton!
    @IBOutlet var barTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barTitle.text = "choose a moment"
        leftButtonItem.setTitleColor(UIColor.gray, for: .disabled)
        rightButtonItem.setTitleColor(UIColor.gray, for: .disabled)
        rightButtonItem.isEnabled = false
        ImageEditViewController.delegate = self
        TextEditViewController.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkData()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        switch sender.currentTitle {
        case "Cancel":
            self.dismiss(animated: true, completion: nil)
        case "Next":
            if checkedCurrentViewType == .ImageEditView {
                leftButtonItem.setTitle("Back", for: .normal)
                rightButtonItem.setTitle("Done", for: .normal)
                myPageView.nextPage()
                barTitle.text = "write a comment"
            }
        case "Back":
            if checkedCurrentViewType == .TextEditView {
                leftButtonItem.setTitle("Cancel", for: .normal)
                rightButtonItem.setTitle("Next", for: .normal)
                myPageView.previousPage()
                barTitle.text = "choose a moment"
            }
        case "Done":
            if checkedCurrentViewType == .TextEditView {
                SavingContent.date = dateModel.myDate
                NoteEditMainViewController.noteEditDelegate?.saveNewData(diary: SavingContent.diary, note: SavingContent.note, image: SavingContent.image, thumbnail: SavingContent.thumbnail, comment: SavingContent.comment, date: SavingContent.date)
                self.dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    func checkData() {
        if SavingContent.image != nil {
            rightButtonItem.isEnabled = true
        }
    }
    
    private enum currnetVCType {
        case none
        case TextEditView
        case ImageEditView
    }
    
    private var currentView : UIViewController {
        return (myPageView?.viewControllers![0])!
    }
    
    private var checkedCurrentViewType : currnetVCType {
        if currentView is TextEditViewController { return .TextEditView }
        if currentView is ImageEditViewController { return .ImageEditView}
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "NoteEditPageView":
            if let loadedVC = segue.destination as? NoteEditPageViewController {
                myPageView = loadedVC
            }
        default:
            break
        }
    }
    
    func setSavingData(diary diaryData: Diary?, note noteData: Note?, image imageData: Data?, thumbnail thumbnailData: Data?, comment commentData: String?) {
        if let diary = diaryData {
            SavingContent.diary = diary
        }
        if let note = noteData {
            SavingContent.note = note
        }
        if let image = imageData {
            SavingContent.image = image
        }
        if let thumbnail = thumbnailData {
            SavingContent.thumbnail = thumbnail
        }
        if let comment = commentData {
            SavingContent.comment = comment
        }
        checkData()
    }
    
}
