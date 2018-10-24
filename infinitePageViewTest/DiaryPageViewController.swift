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
    
    enum requestedStatus {
        case showAll
        case showNoteExistOnly
    }
    
    var loadingStatus : requestedStatus = .showNoteExistOnly
    
    let dateModel = DateCoreModel()
    
    weak var pageviewDelegate : sendCurrentPagesDate?
    
    fileprivate struct dateDistance {
        static let aDay = 1
        static let aWeek = 7
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        requestViewUpdate()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if loadingStatus == .showNoteExistOnly {
            guard let nowIndex = lastIndex else { return nil }
            
            let targetIndex = nowIndex - 1
            if targetIndex >= 0 {
                return generateTableViewWithDate(notedDates[targetIndex])
            } else {
                return nil
            }
        } else {
            guard let dateOfCurrentPage = (viewController as! NoteTableViewController).date else { return nil }
            guard let newPage = generateTableViewWithDate(dateModel.setNewDateWithDistanceFromDate(direction: .present, from: dateOfCurrentPage, distance: dateDistance.aDay)!) else { return nil }
            return newPage
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if loadingStatus == .showNoteExistOnly {
            guard let nowIndex = lastIndex else { return nil }
            
            let targetIndex = nowIndex + 1
            if targetIndex < notedDates.count {
                return generateTableViewWithDate(notedDates[targetIndex])
            } else {
                return nil
            }
        } else {
            guard let dateOfCurrentPage = (viewController as! NoteTableViewController).date else { return nil }
            if dateOfCurrentPage < dateModel.currentDate {
                guard let newPage = generateTableViewWithDate(dateModel.setNewDateWithDistanceFromDate(direction: .after, from: dateOfCurrentPage, distance: dateDistance.aDay)!) else { return nil }
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
            return
        } else {
            if let currentPage = pageViewController.viewControllers![0] as? NoteTableViewController {
                guard let date = currentPage.date else { return }
                updateLoadedIndex(date)
                pageviewDelegate?.passedDate(date)
            }
        }
    }
    
    func updateLoadedIndex(_ date: Date) {
        if loadingStatus == .showNoteExistOnly {
            if let index = notedDates.index(of: date) {
                lastIndex = index
            }
        } else {
            return
        }
    }
    
    func requestViewUpdate() {
        if loadingStatus == .showNoteExistOnly {
            getDateFromDiary()
            lastIndex = (notedDates.count - 1)
            setVisibleNoteTableViewWithRequestedDate(notedDates.last!)
        } else {
            setVisibleNoteTableViewWithRequestedDate(dateModel.currentDate)
        }
    }
    
    func setVisibleNoteTableViewWithRequestedDate(_ date: Date) {
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
    
    var notedDates = [Date]()
    
    var lastIndex : Int?
    
    func getDateFromDiary() {
        notedDates = [Date]()
        if let diarys = try? Diary.loadAllDiary() {
            for diary in diarys {
                if let date = diary.date {
                    notedDates.append(date)
                }
            }
            notedDates.sort(){$0 < $1}
            if notedDates.last != dateModel.currentDate {
                notedDates.append(dateModel.currentDate)
            }
            print(notedDates)
        }
    }
    
}
