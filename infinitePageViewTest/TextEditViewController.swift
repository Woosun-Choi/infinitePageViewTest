//
//  TextEditViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 7..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class TextEditViewController: UIViewController {
    
    var text : String?

    @IBOutlet weak var textField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

}
