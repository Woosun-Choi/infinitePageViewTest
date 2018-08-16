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
    @IBOutlet weak var imageView: UIImageView!
    
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

//extension UIImage {
//    
//    /// Returns a image that fills in newSize
//    func resizedImage(newSize: CGSize) -> UIImage {
//        // Guard newSize is different
//        guard self.size != newSize else { return self }
//        
//        var myImage : UIImage?
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
//        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
//        if let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
//            UIGraphicsEndImageContext()
//            myImage = newImage
//        }
//        return myImage!
//    }
//    
//    /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
//    /// Note that the new image size is not rectSize, but within it.
//    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
//        let widthFactor = size.width / rectSize.width
//        let heightFactor = size.height / rectSize.height
//        
//        var resizeFactor = widthFactor
//        if size.height > size.width {
//            resizeFactor = heightFactor
//        }
//        
//        let newSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
//        let resized = resizedImage(newSize: newSize)
//        return resized
//    }
//}

