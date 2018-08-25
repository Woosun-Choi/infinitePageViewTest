//
//  Note.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 7..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit
import CoreData

class Note: NSManagedObject {
    
    static func fetchAllNoteData() throws -> [Note] {
        var notes = [Note]()
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        let context = AppDelegate.viewContext
        
        do {
            notes = try context.fetch(request)
            //result.sort(by: ({$0.createdDate! > $1.createdDate!}))
            
        } catch {
            
        }
        return notes
    }
    
    static func loadNoteFromDiary(_ diary: Diary) -> [Note] {
        var notes = [Note]()
        if let result = diary.notes as? Set<Note> {
            notes = result.reversed().sorted(by: ({$0.createdDate! > $1.createdDate!}))
        }
        return notes
    }
    
    class func loadDataFromDate(_ date: Date) throws -> [Note] {
        let request : NSFetchRequest<Diary> = Diary.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Diary.date), (date) as CVarArg)
        request.predicate = predicate
        let context = AppDelegate.viewContext
        var notes = [Note]()
        do {
            let diary = try context.fetch(request).first
            if let result = diary?.notes as? Set<Note> {
                notes = result.reversed().sorted(by: ({$0.createdDate! > $1.createdDate!}))
            }
        } catch {
            throw error
        }
        return notes
    }
    
    class func saveDataOrCeate(_ diary: Diary?, note noteData: Note?, image imageData: Data?, comment commentData: String?, date dateData: Date) throws {
        let context = AppDelegate.viewContext
        if diary == nil {
            let newNote = Note(context: context)
            if let image = imageData {
                newNote.image = image as Data
            }
            if let comment = commentData {
                newNote.comment = comment
            }
            newNote.createdDate = Date()
            let notesDiary = Diary(context: newNote.managedObjectContext!)
            newNote.diary = notesDiary
            newNote.diary?.date = dateData
        } else {
            if noteData == nil {
                let newNote = Note(context: context)
                if let image = imageData {
                    newNote.image = image
                }
                if let comment = commentData {
                    newNote.comment = comment
                }
                newNote.createdDate = Date()
                diary?.addToNotes(newNote)
            } else {
                if let image = imageData {
                    noteData?.image = image
                }
                if let comment = commentData {
                    noteData?.comment = comment
                }
            }
        }
        do {
            try context.save()
        } catch {
            throw error
        }
    }
    
}
