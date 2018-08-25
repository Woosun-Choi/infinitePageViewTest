//
//  sampleCodesForCoreDataFetch.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 25..
//  Copyright © 2018년 goya. All rights reserved.
//

import Foundation
import CoreData

//lazy var fetchingController : NSFetchedResultsController = { () -> NSFetchedResultsController<Note> in
//    let fetchRequest : NSFetchRequest<Note> = Note.fetchRequest()
//    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
//    let context = AppDelegate.viewContext
//    let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//    frc.delegate = self
//    return frc
//}()

//var fetchResultController : NSFetchedResultsController<NSFetchRequestResult>!
//Notice : on the viewdidload section
//let fetchingrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
//fetchingrequest.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
//let context = AppDelegate.viewContext
//
//fetchResultController = NSFetchedResultsController(fetchRequest: fetchingrequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//fetchResultController.delegate = self
