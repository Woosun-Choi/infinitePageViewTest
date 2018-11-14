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
    
    weak var pageviewDelegate : sendCurrentPagesDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        requestViewUpdate()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if LoadManager.loadingStatus == .showNoteExistOnly {
            let index = LoadManager.notedDates.index(before: LoadManager.currentIndex)
            if index >= 0 {
                return generateTableViewWithDate(LoadManager.notedDates[index])
            } else {
                return nil
            }
        } else {
            guard (viewController as! NoteTableViewController).date != nil else { return nil }
            guard let newPage = generateTableViewWithDate(LoadManager.presentDate) else { return nil }
            return newPage
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if LoadManager.loadingStatus == .showNoteExistOnly {
            let index = LoadManager.notedDates.index(after: LoadManager.currentIndex)
            if index < LoadManager.notedDates.count {
                return generateTableViewWithDate(LoadManager.notedDates[index])
            } else { return nil }
        } else {
            guard let dateOfCurrentPage = (viewController as! NoteTableViewController).date else { return nil }
            if dateOfCurrentPage < LoadManager.currentDate {
                guard let newPage = generateTableViewWithDate(LoadManager.afterDate) else { return nil }
                return newPage
            } else {
                return nil
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if (!completed)
        {
        } else {
            if let currentPage = pageViewController.viewControllers![0] as? NoteTableViewController {
                guard let date = currentPage.date else { return }
                LoadManager.lastLoadedDate = date
            }
        }
    }
    
    func requestViewUpdate() {
        if LoadManager.loadingStatus == .showNoteExistOnly {
            LoadManager.getDateFromDiary()
            setVisibleNoteTableViewWithRequestedDate(findLastLoadedDateExist())
        } else {
            setVisibleNoteTableViewWithRequestedDate(findLastLoadedDateExist())
        }
    }
    
    private func findLastLoadedDateExist() -> Date {
        if LoadManager.notedDates.index(of: LoadManager.lastLoadedDate) != nil {
            return LoadManager.lastLoadedDate
        } else {
            return LoadManager.currentDate
        }
    }
    
    func setVisibleNoteTableViewWithRequestedDate(_ date: Date) {
        self.dataSource = nil
        self.dataSource = self
        LoadManager.lastLoadedDate = date
        let controllers = [generateTableViewWithDate(date)]
        setViewControllers(controllers as? [UIViewController], direction: .reverse, animated: false, completion: nil)
        
        pageviewDelegate?.passedDate(date)
    }
    
    func generateTableViewWithDate(_ date: Date) -> NoteTableViewController? {
        let tableViewController = self.storyboard?.instantiateViewController(withIdentifier: "NoteTableView") as? NoteTableViewController
        tableViewController?.date = date
        return tableViewController
    }
    
}
