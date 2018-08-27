//
//  PageViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 2..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

protocol sendCurrentPagesDate: class {
    func passedDate(_ date: Date)
}

class DiaryPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let dateModel = DateCoreModel()
    
    weak var pageviewDelegate : sendCurrentPagesDate?
    
    fileprivate struct dateDistance {
        static let aDay = 1
        static let aWeek = 7
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        loadFisrtViewController(dateModel.currentDate)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let dateInFocusedPage = (viewController as! NoteTableViewController).date {
            if let result = generateTableViewWithDate(dateModel.setNewDateWithDistanceFromDate(direction: .present, from: dateInFocusedPage, distance: dateDistance.aDay)!) {
                return result
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let dateInFocusedPage = (viewController as! NoteTableViewController).date {
            if dateInFocusedPage < dateModel.currentDate {
                if let result = generateTableViewWithDate(dateModel.setNewDateWithDistanceFromDate(direction: .after, from: dateInFocusedPage, distance: dateDistance.aDay)!) {
                    return result
                }
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if (!completed)
        {
            return
        }
        if let currentPage = pageViewController.viewControllers![0] as? NoteTableViewController {
            pageviewDelegate?.passedDate(currentPage.dateModel.myDate)
        }
    }
    
    func loadFisrtViewController(_ date: Date) {
        print("loadFisrtViewController function called")
        self.dataSource = nil
        let controllers = [generateTableViewWithDate(date)]
        setViewControllers(controllers as? [UIViewController], direction: .reverse, animated: false, completion: nil)
        self.dataSource = self
        pageviewDelegate?.passedDate(date)
    }
    
    func generateTableViewWithDate(_ date: Date) -> NoteTableViewController? {
        print("new note table page generated")
        let tableViewController = self.storyboard?.instantiateViewController(withIdentifier: "NoteTableView") as? NoteTableViewController
        tableViewController?.date = date
        return tableViewController
    }
    
}
