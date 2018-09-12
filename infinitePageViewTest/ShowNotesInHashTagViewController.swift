//
//  ShowNotesInHashTagViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 9. 13..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class ShowNotesInHashTagViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HashTagDelegate {
    
    var nowTag : String?
    
    var notes = [Note]()
    
    lazy var actualMaxWidthOfContentCell = {
        noteTableView.bounds.width
    }()
    
    @IBOutlet var tagLabel: UILabel!
    
    @IBOutlet var noteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTableView.delegate = self
        noteTableView.dataSource = self
        noteTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteCell")
        noteTableView.rowHeight = UITableViewAutomaticDimension
        
        HashTagItemView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadNotesWithTag(nowTag)
    }
    
    private func loadNotesWithTag(_ tag: String?) {
        if let tag = tag {
            tagLabel.text = "# \(tag)"
            if let myNotes = HashTag.fetchNoteTagWithString(tag) {
                notes = myNotes
                noteTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell
        generateCell(actualWidth: actualMaxWidthOfContentCell, noteData: notes[indexPath.row], targetCell: cell)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    fileprivate func generateCell(actualWidth width: CGFloat, noteData note: Note, targetCell cell: NoteTableViewCell) {
        cell.actualWidth = width
        cell.note = note
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func moveToTop() {
        let index = IndexPath(item: 0, section: 0)
        noteTableView.scrollToRow(at: index, at: .middle, animated: false)
    }
    
    func passingData(_ tag: String, editType type: requestedHashTagManagement) {
        if type == .fetch {
            nowTag = tag
            loadNotesWithTag(nowTag)
            moveToTop()
        }
    }
    
}
