//
//  PageViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 2..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

protocol sendCurrentPagesDate {
    func passedDate(_ date: Date)
}

class DiaryPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let dateModel = DateCoreModel()
    
    var pageviewDelegate : sendCurrentPagesDate?
    
    fileprivate struct dateDistance {
        static let aDay = 1
        static let aWeek = 7
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
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
        dataSource = nil
        let controllers = [generateTableViewWithDate(date)]
        pageviewDelegate?.passedDate(date)
        setViewControllers(controllers as? [UIViewController], direction: .reverse, animated: true, completion: nil)
        dataSource = self
        
    }
    
    func generateTableViewWithDate(_ date: Date) -> NoteTableViewController? {
        let tableViewController = self.storyboard?.instantiateViewController(withIdentifier: "NoteTableView") as? NoteTableViewController
        tableViewController?.date = date
        return tableViewController
    }
    
}
