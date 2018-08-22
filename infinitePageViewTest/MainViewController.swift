//
//  MainViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 7..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    let imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var pageView: UIView!
    private var mypageView : NotePageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("mianView didLoad")
        imagePickerController.delegate = self
    }
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        switch sender.tag {
        case 1:
            performSegue(withIdentifier: "ToTextEdit", sender: self)
        case 2:
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true)
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "PageView":
            if let loadedPageVC = segue.destination as? NotePageViewController {
                self.mypageView = loadedPageVC
                print("pageview setted")
            }
        default:
            break
        }
    }
    
    private func currentView() -> UIViewController? {
        var currentVC : UIViewController?
        
        if let currentViewController = mypageView?.viewControllers?[0] as? FrameViewController {
            print("called")
            currentVC = currentViewController
        }
        
        if let currentViewController = mypageView?.viewControllers?[0] as? NoteTableStyleViewController {
            print("called")
            currentVC = currentViewController
        }
        return currentVC
    }
    
    func updateEditedText(_ text: String) {
//        if let selectedContext = currentView() as? FrameViewController {
//            do {
//                try Note.saveDataOrCreateNewNote(selectedContext.note, image: nil, comment: text, date: selectedContext.dateModel.myDate)
//            } catch {
//                print("saveing comment error")
//            }
//            selectedContext.loadData()
//        }
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let originalData = UIImageJPEGRepresentation(pickedImage, 0.7) {
                let imageData = originalData
                if let selectedContext = currentView() as? NoteTableStyleViewController {
                    do {
                        print("save method called")
                        try Note.saveDataOrCeate(selectedContext.diary, note: nil, image: imageData, comment: nil, date: selectedContext.dateModel.myDate)
                    } catch {
                        print("error")
                    }
                    selectedContext.loadData()
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
