//
//  NoteEditMainViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 21..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class SavingContent {
    static var image : Data? {
        didSet {
            print("image data setted")
        }
    }
    static var comment : String? {
        didSet {
            print("comment setted")
        }
    }
    
    static func resetSavingContent() {
        SavingContent.image = nil
        SavingContent.comment = nil
    }
}

protocol SaveNewData {
    func saveNewData(image imageData: Data?, comment commentData: String?)
}

protocol SetSavingData {
    func setSavingData(image imageData: Data?, comment commentData: String?)
}

class NoteEditMainViewController: UIViewController, SetSavingData {
    
    let dateModel = DateCoreModel()
    
    var delegate : SaveNewData?
    
    var diary : Diary?
    
    var note : Note? {
        didSet {
            if let image = note?.image {
                SavingContent.image = image
            }
        }
    }
    
    @IBOutlet var leftButtonItem: UIButton!
    @IBOutlet var rightButtonItem: UIButton!
    
    var currentPageView : NoteEditPageViewController?
    
    @IBOutlet var barTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barTitle.text = "choose a moment"
        SavingContent.resetSavingContent()
        ImageEditViewController.delegate = self
        TextEditViewController.delegate = self
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        switch sender.currentTitle {
        case "Cancel":
            self.dismiss(animated: true, completion: nil)
        case "Next":
            if checkCurrentViewControllerType() == .ImageEditView {
                leftButtonItem.setTitle("Back", for: .normal)
                if SavingContent.image != nil {
                    rightButtonItem.setTitle("Done", for: .normal)
                } else if SavingContent.image == nil {
                    rightButtonItem.setTitle("Done", for: .normal)
                    rightButtonItem.isEnabled = false
                }
                currentPageView?.nextPage()
                barTitle.text = "write a comment"
            }
        case "Back":
            if checkCurrentViewControllerType() == .TextEditView {
                if !rightButtonItem.isEnabled {
                    rightButtonItem.isEnabled = true
                }
                leftButtonItem.setTitle("Cancel", for: .normal)
                rightButtonItem.setTitle("Next", for: .normal)
                currentPageView?.previousPage()
                barTitle.text = "choose a moment"
            }
        case "Done":
            if checkCurrentViewControllerType() == .TextEditView {
                delegate?.saveNewData(image: SavingContent.image, comment: SavingContent.comment)
                self.dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    private enum currnetVCType {
        case none
        case TextEditView
        case ImageEditView
    }
    
    private func currentVC() -> UIViewController {
        return (currentPageView?.viewControllers![0])!
    }
    
    private func checkCurrentViewControllerType() -> currnetVCType {
        let vc = currentVC()
        var vcType : currnetVCType = .none
        if vc is TextEditViewController { vcType = .TextEditView; return vcType }
        if vc is ImageEditViewController { vcType = .ImageEditView; return vcType }
        return vcType
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "NoteEditPageView":
            if let loadedVC = segue.destination as? NoteEditPageViewController {
                currentPageView = loadedVC
            }
        default:
            break
        }
    }
    
    func setSavingData(image imageData: Data?, comment commentData: String?) {
        if let image = imageData {
            SavingContent.image = image
        }
        if let comment = commentData {
            SavingContent.comment = comment
        }
    }
    
}
