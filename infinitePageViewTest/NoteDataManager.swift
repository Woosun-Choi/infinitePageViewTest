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
class NoteDataManager {
    
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
            notes = result.reversed()
        }
        return notes
    }
    
    //    func loadDataFromDate(_ date: Date) throws -> Note? {
    //
    //        let request : NSFetchRequest<Note> = Note.fetchRequest()
    //        let predicate = NSPredicate(format: "%K == %@", #keyPath(Note.date), (date) as CVarArg)
    //        request.predicate = predicate
    //
    //        do {
    //            let notes = try self.context.fetch(request)
    //            return notes.first
    //        } catch {
    //            throw error
    //        }
    //    }
}
