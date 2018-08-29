//
//  MainViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 7..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit
import CoreData

class DiaryViewController: UIViewController, sendCurrentPagesDate {
    
    let dateModel = DateCoreModel()
    
    var mypageView : DiaryPageViewController!
    
    var visibleNoteTableView : NoteTableViewController {
        return (mypageView.viewControllers?[0] as? NoteTableViewController)!
    }
    
    var settedDate : Date? {
        didSet {
            dateModel.myDate = settedDate!
            checkLabelTextAndTransitionTo(weekdayLabel, text: dateModel.weekday_String)
            checkLabelTextAndTransitionTo(monthLabel, text: dateModel.month_String)
            checkLabelTextAndTransitionTo((dayLabel), text: dateModel.day_String)
        }
    }
    
    @IBOutlet var weekdayLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var topContainerView: UIView!
    @IBOutlet weak var pageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabGuestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backToCurrentDate))
        tabGuestureRecognizer.numberOfTapsRequired = 2
        topContainerView.addGestureRecognizer(tabGuestureRecognizer)
    }
    
    @objc func backToCurrentDate() {
        mypageView?.setVisibleNoteTableViewWithRequestedDate(dateModel.currentDate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "PageView":
            if let loadedPageVC = segue.destination as? DiaryPageViewController {
                loadedPageVC.pageviewDelegate = self
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
    
    func passedDate(_ date: Date) {
        settedDate = date
    }
    
}
