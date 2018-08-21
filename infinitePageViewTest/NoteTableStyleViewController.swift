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
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
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
    
    override func viewDidAppear(_ animated: Bool) {
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
        cellLayoutInit(cell)
        cell.note = notes[indexPath.row]
        //setCellLayouts(cell)
        return cell
    }
    
    //MARK: Tip -  if wants to change cell or table views layout just call this method
    //    mytableView.beginUpdates()
    //    mytableView.endUpdates()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    fileprivate func setCellLayouts(_ cell: NoteTableViewCell) {
        inputData(cell)
    }
    
    fileprivate func inputData(_ cell: NoteTableViewCell) {
        cellLayoutInit(cell)
        resizeImageAndImageView(image: (cell.note?.image)!, cell: cell)
    }
    
    fileprivate func cellLayoutInit(_ cell: NoteTableViewCell) {
        cell.contentView.bounds.size.width = noteTableView.bounds.width
        cell.imageViewHeightAnchor?.isActive = false
        cell.tableViewCell_imageView.image = UIImage()
        cell.tableViewCell_imageView.alpha = 0
    }
    
    fileprivate func resizingImageView(image imageData: UIImage?, cell settedCell: NoteTableViewCell) {
        if let image = imageData {
            let width = settedCell.contentView.bounds.width//imageViewWidthAnchor.constant
            let height = (width) * ((image.size.height)/(image.size.width))
            settedCell.imageViewHeightAnchor = settedCell.imageViewContainer.heightAnchor.constraint(equalToConstant: height)
            settedCell.imageViewHeightAnchor.isActive = true
            //            let width = settedCell.contentView.bounds.width
            //            settedCell.imageViewContainer.frame.size.height = width * (image.size.height/image.size.width)
        }
    }
    
    fileprivate func resizeImageAndImageView(image imageData: Data, cell settedCell: NoteTableViewCell) {
        let inputImage = UIImage(data: imageData)
        resizingImageView(image: inputImage, cell: settedCell)
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
