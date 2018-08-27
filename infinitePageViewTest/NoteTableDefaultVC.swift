//
//  NoteTableDefaultVC.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 28..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit

class NoteTableDefaultVC: UITableViewController {
    
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
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
