//
//  MyFetchedResultsController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 25..
//  Copyright © 2018년 goya. All rights reserved.
//

import CoreData

class MyFetchedResultsControllerModel {
    
    static func NoteFetchedResultController() -> NSFetchedResultsController<Note> {
        let fetchRequest : NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
        let context = AppDelegate.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
    

}
