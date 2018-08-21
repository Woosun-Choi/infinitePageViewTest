//
//  PageViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 2..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class NotePageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    let dateModel = DateCoreModel()
    
    fileprivate struct dateDistance {
        static let aDay = 1
        static let aWeek = 7
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        let controllers = [generateTableViewWithDate(dateModel.currentDate)]
        //let controllers = [generateFrameViewWithDate(dateModel.currentDate)]
        setViewControllers(controllers as? [UIViewController], direction: .reverse, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
//        if let dateInFocusedPage = (viewController as! FrameViewController).date {
//            if let result = generateFrameViewWithDate(dateModel.setNewDateWithDistanceFromDate(direction: .present, from: dateInFocusedPage, distance: dateDistance.aDay)!) {
//                return result
//            }
//        }
        
        if let dateInFocusedPage = (viewController as! NoteTableStyleViewController).date {
            if let result = generateTableViewWithDate(dateModel.setNewDateWithDistanceFromDate(direction: .present, from: dateInFocusedPage, distance: dateDistance.aDay)!) {
                return result
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
//        if let dateInFocusedPage = (viewController as! FrameViewController).date {
//            if dateInFocusedPage < dateModel.currentDate {
//                if let result = generateFrameViewWithDate(dateModel.setNewDateWithDistanceFromDate(direction: .after, from: dateInFocusedPage, distance: dateDistance.aDay)!) {
//                    return result
//                }
//            }
//        }
        
        if let dateInFocusedPage = (viewController as! NoteTableStyleViewController).date {
            if dateInFocusedPage < dateModel.currentDate {
                if let result = generateTableViewWithDate(dateModel.setNewDateWithDistanceFromDate(direction: .after, from: dateInFocusedPage, distance: dateDistance.aDay)!) {
                    return result
                }
            }
        }
        return nil
    }
    
    func generateFrameViewWithDate(_ date: Date) -> FrameViewController? {
        let frameViewController = self.storyboard?.instantiateViewController(withIdentifier: "FrameViewController") as? FrameViewController
        frameViewController?.date = date
        return frameViewController
    }
    
    func generateTableViewWithDate(_ date: Date) -> NoteTableStyleViewController? {
        let tableViewController = self.storyboard?.instantiateViewController(withIdentifier: "NoteTableView") as? NoteTableStyleViewController
        tableViewController?.date = date
        return tableViewController
    }
}
