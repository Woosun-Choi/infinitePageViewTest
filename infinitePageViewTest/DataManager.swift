//
//  DataManager.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 9. 19..
//  Copyright © 2018년 goya. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    class func deleteObject(object: NSManagedObject, completion: (() -> ())?) {
        let context = AppDelegate.viewContext
        context.delete(object)
        completion?()
    }
}
