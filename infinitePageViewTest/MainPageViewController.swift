//
//  MainPageViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 26..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class MainPageViewController: UIPageViewController {
    
    var viewControllerList : [UIViewController] {
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "NoteMainViewController") as! DiaryViewController
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "MainCollectionViewController") as! NotePhotoCollectionViewController
        return [vc1, vc2]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    enum vcTypes {
        case Diary
        case PhotoCollection
    }
    
    var vcTypeChecker : Dictionary<vcTypes,Int> = [
        .Diary : 0,
        .PhotoCollection : 1
    ]
    
    var loadedVCIndex = 0
    
    func toThePage(_ index : vcTypes) {
        if loadedVCIndex < vcTypeChecker[index]! {
            let newViewController = viewControllerList[vcTypeChecker[index]!]
            setViewControllers([newViewController], direction: .forward, animated: true, completion: nil)
            loadedVCIndex = vcTypeChecker[index]!
        } else if loadedVCIndex > vcTypeChecker[index]! {
            let newViewController = viewControllerList[vcTypeChecker[index]!]
            setViewControllers([newViewController], direction: .reverse, animated: true, completion: nil)
            loadedVCIndex = vcTypeChecker[index]!
        }
    }
    
    enum currnetVCType {
        case none
        case DiaryView
        case PhotoCollection
    }
    
    private var currentView : UIViewController {
        return self.viewControllers![0]
    }
    
    var checkedCurrentViewType : currnetVCType {
        if currentView is DiaryViewController { return .DiaryView }
        if currentView is NotePhotoCollectionViewController { return .PhotoCollection }
        return .none
    }
    
}
