//
//  NoteEditPageViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 21..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class NoteEditPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    lazy var viewControllerList : [UIViewController] = {
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "ImageEditView") as! ImageEditViewController
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "TextEditView") as! TextEditViewController
        
        return [vc1, vc2]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func nextPage() {
        
        if checkCurrentViewControllerType() == .ImageEditView {
            let vcIndex = viewControllerList.index(of: currentVC() as! ImageEditViewController)
            let nextViewController = viewControllerList[vcIndex! + 1]
            self.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
        
        if checkCurrentViewControllerType() == .TextEditView {
            
        }
    }
    
    func previousPage() {
        
        if checkCurrentViewControllerType() == .TextEditView {
            let vcIndex = viewControllerList.index(of: currentVC() as! TextEditViewController)
            let nextViewController = viewControllerList[vcIndex! - 1]
            self.setViewControllers([nextViewController], direction: .reverse, animated: true, completion: nil)
        }
    }
    
    private enum currnetVCType {
        case none
        case TextEditView
        case ImageEditView
    }
    
    private func currentVC() -> UIViewController {
        return self.viewControllers![0]
    }
    
    private func checkCurrentViewControllerType() -> currnetVCType {
        let vc = currentVC()
        var vcType : currnetVCType = .none
        if vc is TextEditViewController { vcType = .TextEditView; return vcType }
        if vc is ImageEditViewController { vcType = .ImageEditView; return vcType }
        return vcType
    }
    
    
    
}
