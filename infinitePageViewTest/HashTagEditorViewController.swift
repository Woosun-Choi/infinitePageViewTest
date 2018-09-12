//
//  HashTagEditorViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 9. 6..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class HashTagEditorViewController: UIViewController, UITextFieldDelegate, HashTagDelegate {
    
    @IBOutlet var hashTagTextField: UITextField!
    
    @IBOutlet var addedView: HashTagView!
    
    @IBOutlet var addedViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var categoryViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var categoryView: HashTagView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hashTagTextField.delegate = self
        HashTagItemView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectableHashs = HashTag.fetchingAllHashTags() {
            for hash in selectableHashs {
                if let tag = hash.hashtag {
                    categoryView.addHashItem(text: tag, touchType: .addToSavingContent)
                }
            }
            categoryViewHeightConstraint.constant = categoryView.viewHeight + 30
        }
        
        if SavingContent.hashTag != nil {
            checkContentAndRedrawAddedView()
        }
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
                    print("reloaded")
                }
            }
        }
    }
    
    func checkContentAndRedrawAddedView() {
        addedView.clearHashItem()
        if let hashs = SavingContent.hashTag {
            for hash in hashs {
                self.addedView.addHashItem(text: hash, touchType: .removeFromSavingContent)
            }
            self.addedViewHeightConstraint.constant = self.addedView.viewHeight + 30
        }
        addedView.setNeedsLayout()
        addedView.layoutIfNeeded()
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
    
    func passingData(_ tag: String, editType type: requestedHashTagManagement) {
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
