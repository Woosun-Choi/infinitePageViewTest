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
    
    class func loadDataFromDate(_ date: Date) throws -> [Note] {
        let request : NSFetchRequest<Diary> = Diary.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Diary.date), (date) as CVarArg)
        request.predicate = predicate
        let context = AppDelegate.viewContext
        var notes = [Note]()
        do {
            let diary = try context.fetch(request).first
            if let result = diary?.notes as? Set<Note> {
                notes = result.reversed()
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
            let notesDiary = Diary(context: newNote.managedObjectContext!)
            newNote.diary = notesDiary
            newNote.diary?.date = dateData
        } else {
            let newNote = Note(context: context)
            if let image = imageData {
                newNote.image = image as Data
            }
            if let comment = commentData {
                newNote.comment = comment
            }
            diary?.addToNotes(newNote)
        }
        do {
            try context.save()
        } catch {
            throw error
        }
        
    }
    
    class func saveDataOrCreateNewNote(_ note: Note?, image imageData: NSData?, comment commentData: String?, date dateData: Date) throws {
        let context = AppDelegate.viewContext
        if note == nil {
            let newNote = Note(context: context)
            if let image = imageData {
                newNote.image = image as Data
            }
            if let comment = commentData {
                newNote.comment = comment
            }
            newNote.diary?.date = dateData
        } else {
            if let image = imageData {
                note?.image = image as Data
            }
            if let comment = commentData {
                note?.comment = comment
            }
        }
        do {
            try context.save()
        } catch {
            throw error
        }
    }
    
    
}
