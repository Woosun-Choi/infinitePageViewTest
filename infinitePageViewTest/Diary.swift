//
//  Diary.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 16..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit
import CoreData

class Diary: NSManagedObject {
    
    class func checkEmptyStatus(_ diary: Diary) {
        if diary.notes == nil || diary.notes?.count == 0 {
            let context = AppDelegate.viewContext
            context.delete(diary)
        }
    }
    
    class func loadAllDiary() throws -> [Diary] {
        let request : NSFetchRequest<Diary> = Diary.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        let context = AppDelegate.viewContext
        do {
            return try context.fetch(request)
        } catch let error {
            throw error
        }
    }
    
    class func loadDiaryFromDate(_ date: Date) throws -> Diary? {
        let request : NSFetchRequest<Diary> = Diary.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Diary.date), (date) as CVarArg)
        request.predicate = predicate
        do {
            let context = AppDelegate.viewContext
            let diaries = try context.fetch(request)
            return diaries.first
        } catch {
            throw error
        }
    }

}
