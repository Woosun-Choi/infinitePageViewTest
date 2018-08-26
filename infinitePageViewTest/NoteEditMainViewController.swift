//
//  NoteEditMainViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 21..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

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
    
    private struct SavingContent {
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
    
    @IBOutlet var leftButtonItem: UIButton!
    @IBOutlet var rightButtonItem: UIButton!
    
    var currentPageView : NoteEditPageViewController?
    
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
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        switch sender.currentTitle {
        case "Cancel":
            self.dismiss(animated: true, completion: nil)
        case "Next":
            if checkCurrentViewControllerType() == .ImageEditView {
                leftButtonItem.setTitle("Back", for: .normal)
                rightButtonItem.setTitle("Done", for: .normal)
                currentPageView?.nextPage()
                barTitle.text = "write a comment"
            }
        case "Back":
            if checkCurrentViewControllerType() == .TextEditView {
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
            rightButtonItem.isEnabled = true
        }
        if let comment = commentData {
            SavingContent.comment = comment
        }
    }
    
}
