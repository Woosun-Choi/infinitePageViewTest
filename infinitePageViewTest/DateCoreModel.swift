//
//  dateCoreModel.swift
//  dateAppTest
//
//  Created by goya on 2018. 7. 24..
//  Copyright © 2018년 goya. All rights reserved.
//

import Foundation

class DateCoreModel: DateBrain {
    
    var day_String : String {
        return performDateTransformTo(type: .day_String, from: myDate) as! String
    }
    
    var month_String : String {
        return performDateTransformTo(type: .month_String, from: myDate) as! String
    }
    
    var weekday_String : String {
        return performDateTransformTo(type: .weekday_String, from: myDate) as! String
    }
    
    lazy var dat_Int : Int = {
        performDateTransformTo(type: .day_Int, from: myDate) as! Int
    }()
    
    lazy var month_Int : Int = {
        performDateTransformTo(type: .month_Int, from: myDate) as! Int
    }()
    
    lazy var year_Int : Int = {
        performDateTransformTo(type: .year_Int, from: myDate) as! Int
    }()
    
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
