//
//  CoreDataManagement.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 10..
//  Copyright © 2018년 goya. All rights reserved.
//

import Foundation
import CoreData
// I dont use this in this time but soon it can be needed
class NoteDataManager: Note {
    
    let context = AppDelegate.viewContext
    
    func saveData() {
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func loadDiaryFromDate(_ date: Date) throws -> Diary? {
        let request : NSFetchRequest<Diary> = Diary.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Diary.date), (date) as CVarArg)
        request.predicate = predicate
        do {
            let diaries = try self.context.fetch(request)
            return diaries.first
        } catch {
            throw error
        }
    }
    
    func loadNoteFromDiary(_ diary: Diary) -> [Note] {
        var notes = [Note]()
        if let result = diary.notes as? Set<Note> {
            notes = result.reversed().sorted(by: ({$0.createdDate! > $1.createdDate!}))
        }
        return notes
    }
}
