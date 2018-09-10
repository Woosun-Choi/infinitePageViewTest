//
//  HashTag.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 16..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit
import CoreData

class HashTag: NSManagedObject {
    
    class func fetchingAllHashTags() -> [HashTag]? {
        let request : NSFetchRequest<HashTag> = HashTag.fetchRequest()
        let sort = NSSortDescriptor(key: "hashtag", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            let context = AppDelegate.viewContext
            return try context.fetch(request)
        } catch {
            return nil
        }
    }
    
    class func fetchNoteTagWithString(_ tag: String) -> [Note]? {
        let request : NSFetchRequest<HashTag> = HashTag.fetchRequest()
        let predicate = NSPredicate(format: "hashtag == %@", tag)
        request.predicate = predicate
        do {
            let context = AppDelegate.viewContext
            let result = try context.fetch(request).first
            if let notes = result?.notes as? Set<Note> {
                return notes.reversed().sorted(by: ({
                    $0.createdDate! > $1.createdDate!
                }))
            } else {
                return nil
            }
        } catch { return nil }
    }
    
    class func deleteHashTagOrRemoveFromNote(_ tag: String, note noteData: Note?) {
        let request : NSFetchRequest<HashTag> = HashTag.fetchRequest()
        let predicate = NSPredicate(format: "hashtag == %@", tag)
        request.predicate = predicate
        do {
            let context = AppDelegate.viewContext
            if let target = try context.fetch(request).first {
                if (target.notes?.count)! >= 1 && noteData != nil {
                    target.removeFromNotes(noteData!)
                    try context.save()
                } else {
                    context.delete(target)
                }
            }
        } catch { return }
    }
    
    class func deleteHashTag(_ tag: HashTag) {
        let context = AppDelegate.viewContext
        context.delete(tag)
    }
    
}
