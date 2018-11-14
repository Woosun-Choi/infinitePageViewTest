//
//  MainViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 7..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit
import CoreData

class DiaryViewController: UIViewController {
    
    var mypageView : DiaryPageViewController!
    
    var visibleNoteTableView : NoteTableViewController {
        return (mypageView.visibleViewController as? NoteTableViewController)!
    }
    
    @IBOutlet weak var pageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
    }
    
    private func addGesture() {
        let tabGuestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backToCurrentDate))
        tabGuestureRecognizer.numberOfTapsRequired = 2
        pageView.addGestureRecognizer(tabGuestureRecognizer)
    }
    
    @objc func backToCurrentDate() {
        if LoadManager.loadingStatus == .showAll {
            LoadManager.loadingStatus = .showNoteExistOnly
        } else {
            LoadManager.loadingStatus = .showAll
        }
        mypageView?.requestViewUpdate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "PageView":
            if let loadedPageVC = segue.destination as? DiaryPageViewController {
                self.mypageView = loadedPageVC
                print("diary pageview setted")
            }
        default:
            break
        }
    }
    
    private func checkLabelTextAndTransitionTo(_ label: UILabel, text textData: String) {
        if label.text != textData {
            labelTextTransition(label, text: textData)
        }
    }
    
    private func labelTextTransition(_ label: UILabel, text textData: String) {
        UIView.transition(with: label,duration: 0.2,
                          options: [.transitionCrossDissolve,.curveEaseInOut],
                          animations: {
                            label.text = textData},
                          completion: nil)
    }
    
}
