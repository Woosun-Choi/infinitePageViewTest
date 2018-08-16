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
    
    class func loadDataFromDate(_ date: Date) throws -> Note? {
        let context = AppDelegate.viewContext
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Note.date), (date) as CVarArg)
        request.predicate = predicate
        do {
            let notes = try context.fetch(request)
            return notes.first
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
            newNote.date = dateData
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
