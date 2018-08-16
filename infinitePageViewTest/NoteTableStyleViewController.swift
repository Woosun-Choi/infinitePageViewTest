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
    let noteManager = NoteDataManager()
    
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
            if diary != nil {
                notes = noteManager.loadNoteFromDiary(diary!)
                self.noteTableView.reloadData()
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
    
    @IBOutlet weak var dayLabel: UILabel! {
        didSet {
            if date != nil {
                dayLabel.text = dateModel.performDateTransformTo(type: .day_String, from: dateModel.myDate) as? String
            }
        }
    }
    
    @IBOutlet weak var weekdayLabel: UILabel! {
        didSet {
            if date != nil {
                weekdayLabel.text = dateModel.performDateTransformTo(type: .weekday_String, from: dateModel.myDate) as? String
            }
        }
    }
    
    @IBOutlet weak var noteTableView: UITableView! {
        didSet {
            print("tableview has set")
            noteTableView.delegate = self
            noteTableView.dataSource = self
            noteTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteCell")
            noteTableView.rowHeight = UITableViewAutomaticDimension
            
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        do {
            diary = try noteManager.loadDiaryFromDate(dateModel.myDate)
            //notes = try Note.loadDataFromDate(dateModel.myDate)
        } catch {
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") as! NoteTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell
        cell.note = notes[indexPath.row]
        return cell
    }
    
}
