//
//  TextEditViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 7..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class TextEditViewController: UIViewController, UITextViewDelegate {
    
    static weak var delegate : SetSavingData?
    
    var text : String?

    @IBOutlet weak var textField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkData()
    }
    
    func checkData() {
        if SavingContent.comment != nil {
            textField.text = SavingContent.comment
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("text did changed")
        SavingContent.comment = textField.text
    }

}
