//
//  NoteTableStyleViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 16..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class NoteTableStyleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SaveNewData {
    
    let dateModel = DateCoreModel()
    
    var notes = [Note]()
    
    var date : Date? {
        didSet {
            dateModel.myDate = date!
        }
    }
    
    var diary : Diary? {
        didSet {
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
    
    fileprivate lazy var actualMaxWidthOfContentCell = {
        noteTableView.bounds.width
    }()
    
    override func viewDidLoad() {
        print("tableview viewdid laoded")
        super.viewDidLoad()
        noteTableView.delegate = self
        noteTableView.dataSource = self
        noteTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteCell")
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
        generateCell(actualWidth: actualMaxWidthOfContentCell, noteData: notes[indexPath.row], targetCell: cell)
        return cell
    }
    
    //MARK: Tip -  if wants to change cell or table views layout just call this method
    //    mytableView.beginUpdates()
    //    mytableView.endUpdates()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? NoteTableViewCell {
            cell.selectedAction()
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ToEditNote":
            if let destinationVC = segue.destination as? NoteEditMainViewController {
                destinationVC.dateModel.myDate = dateModel.myDate
                if let settedDiary = diary {
                    destinationVC.diary = settedDiary
                }
                destinationVC.delegate = self
            }
        default:
            break
        }
    }
    
    func saveNewData(image imageData: Data?, comment commentData: String?) {
        var newImageData: Data! {
            didSet {
                do {
                    try Note.saveDataOrCeate(diary, note: nil, image: newImageData, comment: commentData, date: dateModel.myDate)
                    loadData()
                } catch {
                }
            }
        }
        
        let fullImage = UIImage(data: imageData!)
        let newWidth = actualMaxWidthOfContentCell - 30
        let newHeight = newWidth * ((fullImage?.size.height)!/(fullImage?.size.width)!)
        let newImage = fullImage?.resizedImage(newSize:CGSize(width: newWidth, height: newHeight))
        newImageData = UIImageJPEGRepresentation(newImage!, 1)
    }
    
    fileprivate func generateCell(actualWidth width: CGFloat, noteData note: Note, targetCell cell: NoteTableViewCell) {
        
        func resetCell(cell targetCell: NoteTableViewCell) {
            targetCell.cell_CommentLabel.text = nil
            targetCell.commentViewBottomEdgeConstraint.constant = 0
            targetCell.commentViewTopEdgeConstraint.constant = 0
            targetCell.cell_ImageView.alpha = 0
        }
        
        resetCell(cell: cell)
        cell.actualWidth = width
        cell.note = note
    }
    
    func moveToTargetCell(_ index: IndexPath) {
        DispatchQueue.main.async {
            self.noteTableView.scrollToRow(at: index, at: .middle, animated: true)
        }
        
    }
    
    //MARK : Cell layout settings
    
    func setData(_ cell:NoteTableViewCell) {
        
        func setImageAndResizingImageView(_ actualWidth: CGFloat) {
            if let imageData = cell.note?.image {
                let image = UIImage(data: imageData)
                let width = actualWidth
                let height = width * ((image?.size.height)!/(image?.size.width)!)
                cell.imageViewContainerHeightConstraint.constant = height
                DispatchQueue.global(qos: .background).async {
                    let newImage = image?.resizedImage(newSize: CGSize(width: width, height: height))
                    DispatchQueue.main.async {
                        cell.cell_ImageView.image = newImage
                        UIView.animate(withDuration: 0.5, animations: {
                            cell.cell_ImageView.alpha = 1
                        })
                    }
                }
            }
        }
        
        if let _ = cell.note?.image {
            setImageAndResizingImageView(actualMaxWidthOfContentCell)
        }
        if let comment = cell.note?.comment {
            cell.commentViewTopEdgeConstraint.constant = 8
            cell.commentViewBottomEdgeConstraint.constant = 10
            cell.cell_CommentLabel.text = comment
        }
        if cell.note?.comment == nil {
            cell.commentViewHeightConstraint.constant = 0
        }
    }
    
}

//MARK: Cell layout in tableview queue

//func setCell(note noteData: Note, cell targetCell: NoteTableViewCell) {
//    targetCell.note = noteData
//    resizingView(actualMaxWidthOfContentCell, cell: targetCell)
//}
//
//func initalizingCell(cell targetCell: NoteTableViewCell) {
//    targetCell.cell_ImageView.alpha = 0
//    targetCell.cell_ImageView.image = UIImage()
//}
//
//func resizingView(_ actualWidth: CGFloat, cell targetCell: NoteTableViewCell) {
//    initalizingCell(cell: targetCell)
//    if let imageData = targetCell.note?.image {
//        targetCell.needsUpdateConstraints()
//        let image = UIImage(data: imageData)
//        let width = actualWidth - 20
//        let height = width * ((image?.size.height)!/(image?.size.width)!)
//        targetCell.imageViewContainerHeightConstraint.constant = height
//        DispatchQueue.global(qos: .background).async {
//            let newImage = image
//            DispatchQueue.main.async {
//                targetCell.cell_ImageView.image = newImage
//                UIView.animate(withDuration: 0.5, animations: {
//                    targetCell.cell_ImageView.alpha = 1
//                })
//            }
//        }
//    }
//
//    if let commentData = targetCell.note?.comment {
//        targetCell.cell_CommentLabel.text = commentData
//    }
//
//    targetCell.contentContainer.layer.borderWidth = 0.5
//    targetCell.contentContainer.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
//}

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
