//
//  MainViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 7..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit
import CoreData

class NoteMainViewController: UIViewController {
    
    @IBOutlet weak var pageView: UIView!
    var mypageView : NotePageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("mianView didLoad")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "PageView":
            if let loadedPageVC = segue.destination as? NotePageViewController {
                self.mypageView = loadedPageVC
                print("pageview setted")
            }
        default:
            break
        }
    }
    
    func currentView() -> UIViewController? {
        var currentVC : UIViewController?
        
        if let currentViewController = mypageView?.viewControllers?[0] as? NoteTableStyleViewController {
            print("called")
            currentVC = currentViewController
        }
        return currentVC
    }
}
