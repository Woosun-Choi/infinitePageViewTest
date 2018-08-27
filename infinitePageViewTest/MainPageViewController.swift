//
//  MainPageViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 26..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class MainPageViewController: UIPageViewController {
    
    lazy var viewControllerList : [UIViewController] = {
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "NoteMainViewController") as! DiaryViewController
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "MainCollectionViewController") as! NotePhotoCollectionViewController
        
        return [vc1, vc2]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    var loadedVCIndex = 0
    
    func toThePage(_ index : Int) {
        if loadedVCIndex < index {
            let newViewController = viewControllerList[index]
            setViewControllers([newViewController], direction: .forward, animated: true, completion: nil)
            loadedVCIndex = index
        } else if loadedVCIndex > index {
            let newViewController = viewControllerList[index]
            setViewControllers([newViewController], direction: .reverse, animated: true, completion: nil)
            loadedVCIndex = index
        }
    }
    
    enum currnetVCType {
        case none
        case NoteMainViewController
        case MainCollectionViewController
    }
    
    private func currentVC() -> UIViewController {
        return self.viewControllers![0]
    }
    
    func checkCurrentViewControllerType() -> currnetVCType {
        let vc = currentVC()
        var vcType : currnetVCType = .none
        if vc is DiaryViewController { vcType = .NoteMainViewController; return vcType }
        if vc is NotePhotoCollectionViewController { vcType = .MainCollectionViewController; return vcType }
        return vcType
    }
    
}
