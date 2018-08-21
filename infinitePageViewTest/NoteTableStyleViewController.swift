//
//  NoteTableStyleViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 16..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class NoteTableStyleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let dateModel = DateCoreModel()
    
    var notes = [Note]()
    
    var date : Date? {
        didSet {
            print("Date Setted")
            dateModel.myDate = date!
        }
    }
    
    var diary : Diary? {
        didSet {
            print("diary setted")
            if let currentDiary = diary {
                notes = Note.loadNoteFromDiary(currentDiary)
                self.noteTableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var monthLabel: UILabel! {
        didSet {
            if date != nil {
                monthLabel.text = dateModel.month_String
            }
        }
    }
    
    @IBOutlet weak var dayLabel: UILabel! {
        didSet {
            if date != nil {
                dayLabel.text = dateModel.day_String
            }
        }
    }
    
    @IBOutlet weak var weekdayLabel: UILabel! {
        didSet {
            if date != nil {
                weekdayLabel.text = dateModel.weekday_String
            }
        }
    }
    
    @IBOutlet weak var noteTableView: UITableView! {
        didSet {
            print("tableview has set")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTableView.delegate = self
        noteTableView.dataSource = self
        noteTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteCell")
        noteTableView.cellLayoutMarginsFollowReadableWidth = true
        noteTableView.rowHeight = UITableViewAutomaticDimension
        
        loadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 1: performSegue(withIdentifier: "ToEditNote", sender: self)
        default:
            break
        }
    }
    
    func loadData() {
        do {
            diary = try Diary.loadDiaryFromDate(dateModel.myDate)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell
        print("cell setted")
        cell.note = notes[indexPath.row]
        setCellLayouts(cell)
        return cell
    }
    
    //MARK: Tip -  if wants to change cell or table views layout just call this method
    //    mytableView.beginUpdates()
    //    mytableView.endUpdates()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        if let cell = tableView.cellForRow(at: indexPath) as? NoteTableViewCell {
        //            resizingImageView(image: cell.tableViewCell_imageView.image, cell: cell)
        //            tableView.beginUpdates()
        //            tableView.endUpdates()
        //        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        var height : CGFloat!
    //        if let cell = tableView.cellForRow(at: indexPath) as? NoteTableViewCell {
    //            height = cell.contentView.bounds.height
    //        }
    //        return height
    //    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ToEditNote":
            if let destinationVC = segue.destination as? NoteEditMainViewController {
                destinationVC.dateModel.myDate = dateModel.myDate
                if let settedDiary = diary {
                    destinationVC.diary = settedDiary
                }
            }
        default:
            break
        }
    }
    
    //MARK: Cell layout in tableview queue
    
    lazy var actualWidthOfContentCell = {
        noteTableView.bounds.width
    }()
    
    
    fileprivate func setCellLayouts(_ cell: NoteTableViewCell) {
        inputData(cell)
    }
    
    fileprivate func inputData(_ cell: NoteTableViewCell) {
        //cellLayoutInit(cell)
        resizeImageAndImageView(image: (cell.note?.image)!, cell: cell)
    }
    
    fileprivate func cellLayoutInit(_ cell: NoteTableViewCell) {
        //cell.contentView.bounds.size.width = noteTableView.bounds.width
        //        cell.bottumEdgeConstraint.isActive = false
        cell.tableViewCell_imageView.image = UIImage()
        cell.tableViewCell_imageView.alpha = 0
    }
    
    fileprivate func resizingImageView(image imageData: UIImage?, cell settedCell: NoteTableViewCell) {
        cellLayoutInit(settedCell)
        if let image = imageData {
            let height = (actualWidthOfContentCell) * ((image.size.height)/(image.size.width))
            settedCell.imageViewContainerHeight.constant = height
        }
    }
    
    fileprivate func resizeImageAndImageView(image imageData: Data, cell settedCell: NoteTableViewCell) {
        let inputImage = UIImage(data: imageData)
        resizingImageView(image: inputImage, cell: settedCell)
        //        settedCell.bottumEdgeConstraint = NSLayoutConstraint(item: settedCell.contentContainer, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: settedCell.contentView, attribute: .bottom, multiplier: 1, constant: -20)
        //        settedCell.bottumEdgeConstraint?.isActive = true
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                settedCell.tableViewCell_imageView.image = inputImage
                UIView.animate(withDuration: 0.5, animations: {
                    settedCell.tableViewCell_imageView.alpha = 1
                })
            }
        }
    }
    
}

fileprivate extension UIImage {
    
    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        var myImage : UIImage?
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        if let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            myImage = newImage
        }
        return myImage!
    }
    
    /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
    /// Note that the new image size is not rectSize, but within it.
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height
        
        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }
        
        let newSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
        let resized = resizedImage(newSize: newSize)
        return resized
    }
}

//MARK: focused cell test

//    var focusedIndexPath : IndexPath?
//
//    override func viewDidLayoutSubviews() {
//        trakingCellIndexPath()
//    }
//
//    func trakingCellIndexPath() {
//        if let indexPath = noteTableView.indexPathForRow(at: CGPoint(x: noteTableView.center.x, y: noteTableView.contentOffset.y + view.bounds.height/2)) {
//            focusedIndexPath = indexPath
//            if let selectedItem = noteTableView.cellForRow(at: focusedIndexPath!) as? NoteTableViewCell {
//                UIView.animate(withDuration: 0.5) {
//                    selectedItem.tableViewCell_imageView.alpha = 1
//                }
//            }
//        }
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        trakingCellIndexPath()
//        print(focusedIndexPath)
//    }
