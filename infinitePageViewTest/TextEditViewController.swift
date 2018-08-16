//
//  TextEditViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 7..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

protocol textEditDelegate {
    func updateEditedText(_ text: String)
}

class TextEditViewController: UIViewController {
    
    var text : String?
    
    var delegte : textEditDelegate?

    @IBOutlet weak var textField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        textField.text = text
    }

    @IBAction func donePressed(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegte?.updateEditedText(self.textField.text)
        }
    }

}
