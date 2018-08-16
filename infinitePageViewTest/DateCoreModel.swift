//
//  dateCoreModel.swift
//  dateAppTest
//
//  Created by goya on 2018. 7. 24..
//  Copyright © 2018년 goya. All rights reserved.
//

import Foundation

class DateCoreModel: DateBrain {
    
    enum directions {
        case present
        case after
    }
    
    func setNewDateWithDistanceFromDate(direction presentorafter: directions, from date: Date, distance datedistance: Int) -> Date? {
        var result : Date?
        switch presentorafter {
        case .present:
            let calendar = Calendar.current
            var dateComponents = DateComponents()
            if datedistance <= 0 {
                dateComponents.day = datedistance
            } else if datedistance > 0 {
                dateComponents.day = -datedistance
            }
            result = calendar.date(byAdding: dateComponents, to: date)!
        case .after:
            let calendar = Calendar.current
            var dateComponents = DateComponents()
            if datedistance >= 0 {
                dateComponents.day = datedistance
            } else if datedistance < 0 {
                dateComponents.day = -datedistance
            }
            result = calendar.date(byAdding: dateComponents, to: date)!
        }
        return result
    }
    
}
