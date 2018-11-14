//
//  HashTagEditorViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 9. 6..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class HashTagEditorViewController: UIViewController, UITextFieldDelegate, HashTagDelegate, UIScrollViewDelegate {
    
    @IBOutlet var hashTagTextField: UITextField!
    
    @IBOutlet var hashTagAddedSectionScrollView: HashTagScrollView!
    
    @IBOutlet var topLabelView: UIView!
    
    @IBOutlet var middleLabelView: UIView!
    
    @IBOutlet var hashTagCategorySectionScrollView: HashTagScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hashTagCategorySectionScrollView.delegate = self
        hashTagAddedSectionScrollView.delegate = self
        hashTagTextField.delegate = self
        HashTagItemView.delegate = self
        topLabelView.setShadow()
        middleLabelView.setShadow()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        hashTagAddedSectionScrollView.viewType = .addingType
        hashTagCategorySectionScrollView.viewType = .categoryType
        loadHashContents()
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        addHashToSavingContent(true)
    }
    
    func addHashToSavingContent(_ endEditing: Bool) {
        if endEditing == true {
            hashTagTextField.endEditing(endEditing)
        }
        if let newTag = hashTagTextField.text {
            if newTag != "" && newTag.first != " " {
                if SavingContent.hashTag == nil {
                    SavingContent.hashTag = [newTag]
                } else {
                    if SavingContent.hashTag?.index(of: newTag) == nil {
                        SavingContent.hashTag?.append(newTag)
                    }
                }
                hashTagTextField.text = ""
                DispatchQueue.main.async {
                    self.checkContentAndRedrawAddedView()
                }
            }
        }
    }
    
    private func loadHashContents() {
        hashTagCategorySectionScrollView.hashTagView.clearHashItem()
        if let selectableHashs = HashTag.fetchingAllHashTags() {
            var hashs = [String]()
            for hash in selectableHashs {
                if let tag = hash.hashtag {
                    hashs.append(tag)
                }
            }
            hashTagCategorySectionScrollView.createHashTagView(tag: hashs)
        }
        
        if SavingContent.hashTag != nil {
            checkContentAndRedrawAddedView()
        }
        
        hashTagCategorySectionScrollView.setNeedsLayout()
        hashTagCategorySectionScrollView.setNeedsDisplay()
        hashTagAddedSectionScrollView.setNeedsLayout()
        hashTagAddedSectionScrollView.setNeedsDisplay()
    }
    
    private func checkContentAndRedrawAddedView() {
        hashTagAddedSectionScrollView.hashTagView.clearHashItem()
        if let hashs = SavingContent.hashTag {
            hashTagAddedSectionScrollView.createHashTagView(tag: hashs)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addHashToSavingContent(true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            addHashToSavingContent(false)
            return false
        } else {
            return true
        }
    }
    
    func requestHashTagAction(_ tag: String, editType type: requestedHashTagManagement) {
        if type == .addToSavingContent {
            if SavingContent.hashTag == nil {
                SavingContent.hashTag = [tag]
                checkContentAndRedrawAddedView()
            } else {
                if SavingContent.hashTag?.index(of: tag) == nil {
                    SavingContent.hashTag?.append(tag)
                    checkContentAndRedrawAddedView()
                }
            }
        } else if type == .removeFromSavingContent {
            if NoteEditMainViewController.tags.count > 0 {
                for hash in NoteEditMainViewController.tags {
                    if hash.hashtag == tag {
                        if let index = SavingContent.hashTag?.index(of: tag) {
                            HashTag.deleteHashTagOrRemoveFromNote(tag, note: SavingContent.note)
                            SavingContent.hashTag?.remove(at: index)
                            checkContentAndRedrawAddedView()
                        }
                    }
                }
            }
            if let index = SavingContent.hashTag?.index(of: tag) {
                SavingContent.hashTag?.remove(at: index)
                checkContentAndRedrawAddedView()
            }
        }
    }
    
}
