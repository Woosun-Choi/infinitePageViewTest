//
//  NoteTableStyleViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 16..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class NoteTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RequestActionForNote {
    
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
                reloadTableView()
            }
        }
    }
    
    @IBOutlet weak var noteTableView: UITableView! {
        didSet {
            print("tableview has set")
        }
    }
    
    @IBOutlet var tableViewContainer: UIView!
    
    @IBOutlet var placeHolderTextLabel: UILabel!
    
    lazy var actualMaxWidthOfContentCell = {
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
    
    override func viewDidAppear(_ animated: Bool) {
        checkNotesAndPresentPlaceHolder()
    }
    
    func loadData() {
        do {
            diary = try Diary.loadDiaryFromDate(dateModel.myDate)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func reloadTableView() {
        noteTableView.reloadData()
        checkNotesAndPresentPlaceHolder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell
        generateCell(actualWidth: actualMaxWidthOfContentCell, noteData: notes[indexPath.row], targetCell: cell)
        return cell
    }
    
    var noteForEditing: Note!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ToEditNote":
            if let destinationVC = segue.destination as? NoteEditMainViewController {
                SavingContent.resetSavingContent()
                destinationVC.note = noteForEditing
                destinationVC.diary = diary
            }
        default:
            break
        }
    }
    
    //MARK: Tip -  if wants to change cell or table views layout just call this method
    //    mytableView.beginUpdates()
    //    mytableView.endUpdates()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? NoteTableViewCell {
            cell.selectedAction()
            noteTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    func requestAction(_ note: Note, request requestAction: requestedActionCases) {
        switch requestAction {
        case .delete:
            let alert = UIAlertController(title: "Remove this moment", message: "are you sure to remove this moment in your memory?", preferredStyle: .alert)
            let noButton = UIAlertAction(title: "NO", style: .cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            let okButton = UIAlertAction(title: "YES", style: .default, handler: {(action) in
                let index = self.notes.index(of: note)
                Note.deleteNote(note)
                self.notes.remove(at: index!)
                self.reloadTableView()
                if self.notes.count != 0 {
                    DispatchQueue.main.async {
                        self.noteTableView.scrollToRow(at: [0,0], at: .middle, animated: true)
                    }
                }
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(noButton)
            alert.addAction(okButton)
            super.present(alert, animated: true)
        case .edit:
            noteForEditing = note
            performSegue(withIdentifier: "ToEditNote", sender: self)
        }
    }
    
    fileprivate func generateCell(actualWidth width: CGFloat, noteData note: Note, targetCell cell: NoteTableViewCell) {
        
        func resetCell(cell targetCell: NoteTableViewCell) {
            targetCell.blurView?.removeFromSuperview()
            targetCell.delegate = self
            targetCell.cell_CommentLabel.text = nil
            targetCell.commentViewBottomEdgeConstraint.constant = 0
            targetCell.commentViewTopEdgeConstraint.constant = 0
            targetCell.cell_ImageView.alpha = 0
            targetCell.topInnerView.isHidden = true
            targetCell.topInnerView.alpha = 0
        }
        
        resetCell(cell: cell)
        cell.actualWidth = width
        cell.note = note
    }
    
    func moveToTargetCell(_ index: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.noteTableView.scrollToRow(at: index, at: .middle, animated: true)
        }
    }
    
    //MARK : placeholdersettings
    
    var placeHolderExist : Bool = false
    
    func checkNotesAndPresentPlaceHolder() {
        if notes.count == 0, !placeHolderExist {
            placeHolderTextLabel.isHidden = false
            placeHolderExist = true
        } else if notes.count > 0 {
            placeHolderTextLabel.isHidden = true
            placeHolderExist = false
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
