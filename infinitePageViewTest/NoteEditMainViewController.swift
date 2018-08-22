//
//  NoteEditMainViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 21..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class SavingContent {
    var image : Data? {
        didSet {
            print("image data setted")
        }
    }
    var comment : String?
}

protocol CallUpDateTableView {
    func updateTableView()
}

protocol sendSavingData {
    func sendSavingData(image imageData: Data?, comment commentData: String?)
}

class NoteEditMainViewController: UIViewController, sendSavingData {
    
    let dateModel = DateCoreModel()
    
    var delegate : CallUpDateTableView?
    
    var savingContent = SavingContent()
    
    var diary : Diary?
    
    var note : Note? {
        didSet {
            if let image = note?.image {
                savingContent.image = image
            }
        }
    }
    
    @IBOutlet var leftButtonItem: UIButton!
    @IBOutlet var rightButtonItem: UIButton!
    
    var currentPageView : NoteEditPageViewController?
    
    @IBOutlet var barTitle: UILabel! {
        didSet {
            barTitle.text = "Add a moment"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageEditViewController.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        switch sender.currentTitle {
        case "Cancel":
            self.dismiss(animated: true, completion: nil)
        case "Next":
            if let _ = currentPageView?.viewControllers![0] as? ImageEditViewController {
                leftButtonItem.setTitle("Back", for: .normal)
                if savingContent.image != nil {
                    rightButtonItem.setTitle("Done", for: .normal)
                } else if savingContent.image == nil {
                    rightButtonItem.setTitle("Done", for: .normal)
                    rightButtonItem.isEnabled = false
                }
            }
            currentPageView?.nextPage()
        case "Back":
            if let _ = currentPageView?.viewControllers![0] as? TextEditViewController {
                if !rightButtonItem.isEnabled {
                    rightButtonItem.isEnabled = true
                }
                leftButtonItem.setTitle("Cancel", for: .normal)
                rightButtonItem.setTitle("Next", for: .normal)
            }
            currentPageView?.previousPage()
        case "Done":
            if let textView = currentPageView?.viewControllers![0] as? TextEditViewController {
                savingContent.comment = textView.textField.text
            }
            do {
                try Note.saveDataOrCeate(diary, note: note, image: savingContent.image, comment: savingContent.comment, date: dateModel.myDate)
                delegate?.updateTableView()
            } catch {
                
            }
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
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
    
    func sendSavingData(image imageData: Data?, comment commentData: String?) {
        if let image = imageData {
            savingContent.image = image
        }
        if let comment = commentData {
            savingContent.comment = comment
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
