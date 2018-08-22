//
//  ViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 2..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class FrameViewController: UIViewController {
    
    let dateModel = DateCoreModel()
    //let noteManager = NoteDataManager()
    
    var date : Date? {
        didSet {
            print("Date Setted")
            dateModel.myDate = date!
        }
    }
    
    var note : Note? {
        didSet {
            print("Note setted")
            if note?.image != nil {
                if let image = note?.image {
                    DispatchQueue.global(qos: .background).async {
                        let inputImage = UIImage(data: image)?.resizedImageWithinRect(rectSize: CGSize(width: 300, height: 300))
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 0.5, animations: {
                                self.imageView.alpha = 1
                            })
                            self.imageView.image = inputImage
                        }
                    }
                }
            }
            if note?.comment != nil {
                commentLabel.text = note?.comment
            }
        }
    }
    
    @IBOutlet weak var dayLabel: UILabel! {
        didSet {
            if date != nil {
                dayLabel.text = dateModel.performDateTransformTo(type: .day_String, from: dateModel.myDate) as? String
            }
        }
    }
    
    @IBOutlet weak var monthLabel: UILabel! {
        didSet {
            if date != nil {
                monthLabel.text = dateModel.performDateTransformTo(type: .month_String, from: dateModel.myDate) as? String
            }
        }
    }
    
    @IBOutlet weak var weekdayLabel: UILabel! {
        didSet {
            print("weekday setted")
            if date != nil {
                weekdayLabel.text = dateModel.performDateTransformTo(type: .weekday_String, from: dateModel.myDate) as? String
            }
        }
    }
    
    @IBOutlet weak var commentLabel: UITextView!
    @IBOutlet private weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.alpha = 0
        print("frameView didLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("frameView willappear")
        loadData()
    }
    
    func loadData() {
        do {
            //try note = Note.loadDataFromDate(dateModel.myDate)
        } catch {
            let alert = UIAlertController(title: "Loading Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
            let alertActionDissmiss = UIAlertAction(title: "dismiss", style: .cancel) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(alertActionDissmiss)
            self.present(alert, animated: true)
        }
    }
}

