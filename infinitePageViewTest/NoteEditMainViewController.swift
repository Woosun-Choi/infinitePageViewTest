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
    
    static var tags = [HashTag]()
    
    var note : Note? {
        didSet {
            SavingContent.note = note
            if let image = note?.noteImage?.originalImage {
                SavingContent.image = image
            }
            if let thumbnail = note?.noteImage?.thumbnailImage {
                SavingContent.thumbnail = thumbnail
            }
            if let comment = note?.comment {
                SavingContent.comment = comment
            }
            if let hashs = note?.hashtags {
                if hashs.count > 0 {
                    NoteEditMainViewController.tags = Note.allHashsFromNote(note!)
                    for hash in NoteEditMainViewController.tags {
                        if SavingContent.hashTag == nil {
                            SavingContent.hashTag = [hash.hashtag] as? [String]
                        } else {
                            SavingContent.hashTag?.append(hash.hashtag!)
                        }
                    }
                }
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
            self.dismiss(animated: true, completion: {
                SavingContent.resetSavingContent()
                NoteEditMainViewController.tags = [HashTag]()
            })
        case "Next":
            myPageView.nextPage()
            if checkedCurrentViewType == .TextEditView {
                leftButtonItem.setTitle("Back", for: .normal)
                barTitle.text = "write a comment"
            }
            if checkedCurrentViewType == .HashTagEditView {
                leftButtonItem.setTitle("Back", for: .normal)
                rightButtonItem.setTitle("Done", for: .normal)
                barTitle.text = "add tags"
            }
        case "Back":
            myPageView.previousPage()
            if checkedCurrentViewType == .TextEditView {
                leftButtonItem.setTitle("Back", for: .normal)
                rightButtonItem.setTitle("Next", for: .normal)
                barTitle.text = "write a comment"
            }
            if checkedCurrentViewType == .ImageEditView {
                leftButtonItem.setTitle("Cancel", for: .normal)
                barTitle.text = "choose a moment"
            }
        case "Done":
            if checkedCurrentViewType == .HashTagEditView {
                SavingContent.date = dateModel.myDate
                NoteEditMainViewController.noteEditDelegate?.saveNewData()
                self.dismiss(animated: true, completion: nil)
                NoteEditMainViewController.tags = [HashTag]()
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
        case HashTagEditView
    }
    
    private var currentView : UIViewController {
        return (myPageView?.viewControllers![0])!
    }
    
    private var checkedCurrentViewType : currnetVCType {
        if currentView is TextEditViewController { return .TextEditView }
        if currentView is ImageEditViewController { return .ImageEditView}
        if currentView is HashTagEditorViewController { return .HashTagEditView}
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
