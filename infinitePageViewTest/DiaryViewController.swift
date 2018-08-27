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
    
    var settedDate : Date? {
        didSet {
            dateModel.myDate = settedDate!
            if weekdayLabel.text != dateModel.weekday_String {
//                UIView.transition(with: weekdayLabel,duration: 0.2,options: [.transitionFlipFromTop,.curveLinear],
//                                  animations: {
//                                    self.weekdayLabel.text = self.dateModel.weekday_String
//                },completion: nil)}
            UIView.transition(with: weekdayLabel,duration: 0.2,options: [.transitionCrossDissolve,.curveEaseInOut],
                              animations: {
                                self.weekdayLabel.text = self.dateModel.weekday_String
            },completion: nil)}
            if monthLabel.text != dateModel.month_String {
                UIView.transition(with: monthLabel,duration: 0.2,options: [.transitionCrossDissolve,.curveEaseInOut],
                                  animations: {
                                    self.monthLabel.text = self.dateModel.month_String
                },completion: nil)}
            if dayLabel.text != dateModel.day_String {
                UIView.transition(with: dayLabel,duration: 0.2,options: [.transitionCrossDissolve,.curveEaseInOut],
                                  animations: {
                                    self.dayLabel.text = self.dateModel.day_String
                },completion: nil)}
        }
    }
    
    @IBOutlet var weekdayLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    
    @IBOutlet weak var pageView: UIView!
    var mypageView : DiaryPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("mianView didLoad")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "PageView":
            if let loadedPageVC = segue.destination as? DiaryPageViewController {
                loadedPageVC.pageviewDelegate = self
                self.mypageView = loadedPageVC
                print("pageview setted")
            }
        default:
            break
        }
    }
    
    func currentView() -> UIViewController? {
        var currentVC : UIViewController?
        
        if let currentViewController = mypageView?.viewControllers?[0] as? NoteTableViewController {
            print("called")
            currentVC = currentViewController
        }
        return currentVC
    }
    
    func passedDate(_ date: Date) {
        settedDate = date
    }
    
}
