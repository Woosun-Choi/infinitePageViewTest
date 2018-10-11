//
//  dateCoreModel.swift
//  dateAppTest
//
//  Created by goya on 2018. 7. 24..
//  Copyright © 2018년 goya. All rights reserved.
//

import Foundation

class DateCoreModel: DateBrain {
    
    public var day_String : String {
        return transformDateTo(type: .day_String, from: myDate) ?? ""
    }
    
    var month_String : String {
        return transformDateTo(type: .month_String, from: myDate) ?? ""
    }
    
    var weekday_String : String {
        return transformDateTo(type: .weekday_String, from: myDate) ?? ""
    }
    
    var dat_Int : Int {
        return transformDateTo(type: .day_Int, from: myDate) ?? 0
    }
    
    var month_Int : Int {
        return transformDateTo(type: .month_Int, from: myDate) ?? 0
    }
    
    var year_Int : Int {
        return transformDateTo(type: .year_Int, from: myDate) ?? 0
    }
    
    enum directions {
        case present
        case after
    }
    
    func setNewDateWithDistanceFromDate(direction presentorafter: directions, from date: Date, distance datedistance: Int) -> Date? {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        
        switch presentorafter {
        case .present:
            (datedistance <= 0) ? (dateComponents.day = datedistance) : (dateComponents.day = -datedistance)
            return calendar.date(byAdding: dateComponents, to: date)!
        case .after:
            (datedistance >= 0) ? (dateComponents.day = datedistance) : (dateComponents.day = -datedistance)
            return calendar.date(byAdding: dateComponents, to: date)!
        }
    }
    
}
