//
//  NoteEditPageViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 21..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class NoteEditPageViewController: UIPageViewController {
    
    lazy var viewControllerList : [UIViewController] = {
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "ImageEditView") as! ImageEditViewController
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "TextEditView") as! TextEditViewController
        let vc3 = self.storyboard?.instantiateViewController(withIdentifier: "HashTagEditView") as! HashTagEditorViewController
        return [vc1, vc2, vc3]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func nextPage() {
        
        if checkCurrentViewControllerType() == .ImageEditView {
            let vcIndex = viewControllerList.index(of: currentVC() as! ImageEditViewController)
            let nextViewController = viewControllerList[vcIndex! + 1]
            self.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        } else if checkCurrentViewControllerType() == .TextEditView {
            let vcIndex = viewControllerList.index(of: currentVC() as! TextEditViewController)
            let nextViewController = viewControllerList[vcIndex! + 1]
            self.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func previousPage() {
        
        if checkCurrentViewControllerType() == .TextEditView {
            let vcIndex = viewControllerList.index(of: currentVC() as! TextEditViewController)
            let nextViewController = viewControllerList[vcIndex! - 1]
            self.setViewControllers([nextViewController], direction: .reverse, animated: true, completion: nil)
        } else if checkCurrentViewControllerType() == .HashTagEditView {
            let vcIndex = viewControllerList.index(of: currentVC() as! HashTagEditorViewController)
            let nextViewController = viewControllerList[vcIndex! - 1]
            self.setViewControllers([nextViewController], direction: .reverse, animated: true, completion: nil)
        }
    }
    
    private enum currnetVCType {
        case none
        case TextEditView
        case ImageEditView
        case HashTagEditView
    }
    
    private func currentVC() -> UIViewController {
        return self.viewControllers![0]
    }
    
    private func checkCurrentViewControllerType() -> currnetVCType {
        let vc = currentVC()
        var vcType : currnetVCType = .none
        if vc is TextEditViewController { vcType = .TextEditView; return vcType }
        if vc is ImageEditViewController { vcType = .ImageEditView; return vcType }
        if vc is HashTagEditorViewController { vcType = .HashTagEditView; return vcType }
        return vcType
    }
    
    
    
}
