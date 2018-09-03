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
    
    class func deleteHashTagWithString(_ tag: String, note noteData: Note?) {
        let request : NSFetchRequest<HashTag> = HashTag.fetchRequest()
        let predicate = NSPredicate(format: "Hashtag.hashtag == %@", tag)
        request.predicate = predicate
        do {
            let context = AppDelegate.viewContext
            if let target = try context.fetch(request).first {
                if (target.notes?.count)! > 1 && noteData != nil {
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
