//
//  NoteEditPageViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 21..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class NoteEditPageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageEditView") as? ImageEditViewController
        let controllers = [imageViewController]
        setViewControllers(controllers as? [UIViewController], direction: .forward, animated: true, completion: nil)
        
        //dataSource = self
        

        // Do any additional setup after loading the view.
    }
    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        return nil
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        return nil
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
