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
        
        if let controller = self.viewControllers?[0] as? ImageEditViewController {
            let vcIndex = viewControllerList.index(of: controller)
            let nextViewController = viewControllerList[vcIndex! + 1]
            self.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
            
        }
        
        if let controller = self.viewControllers?[0] as? TextEditViewController {
            
        }
    }
    
    func previousPage() {
        
        if let controller = self.viewControllers?[0] as? TextEditViewController {
            let vcIndex = viewControllerList.index(of: controller)
            let nextViewController = viewControllerList[vcIndex! - 1]
            self.setViewControllers([nextViewController], direction: .reverse, animated: true, completion: nil)
        }
    }
    
    
    
}
