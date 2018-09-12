//
//  sampleCodesForCoreDataFetch.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 25..
//  Copyright © 2018년 goya. All rights reserved.
//

import Foundation
import CoreData


//MARK: fetching with fetchresultcontroller

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

//MARK: Left aligned collectionview flowlayout

//import UIKit
//
//class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
//
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let attributes = super.layoutAttributesForElements(in: rect)
//
//        var leftMargin = sectionInset.left
//        var maxY: CGFloat = -1.0
//        attributes?.forEach { layoutAttribute in
//            if layoutAttribute.frame.origin.y >= maxY {
//                leftMargin = sectionInset.left
//            }
//
//            layoutAttribute.frame.origin.x = leftMargin
//
//            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
//            maxY = max(layoutAttribute.frame.maxY , maxY)
//        }
//
//        return attributes
//    }
//}

//MARK: Multi predicate sample
//let converstationKeyPredicate = NSPredicate(format: "conversationKey = %@", conversationKey)
//let messageKeyPredicate = NSPredicate(format: "messageKey = %@", messageKey)
//let andPredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [converstationKeyPredicate, messageKeyPredicate])
//request.predicate = andPredicate
