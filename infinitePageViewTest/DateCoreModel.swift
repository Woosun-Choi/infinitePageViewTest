//
//  dateCoreModel.swift
//  dateAppTest
//
//  Created by goya on 2018. 7. 24..
//  Copyright © 2018년 goya. All rights reserved.
//

import Foundation

class DateCoreModel {
    
    var currentDate : Date {
        return Date().dateWithDateComponents()
    }
    
    private var targetDate : Date = Date()
    
    var myDate : Date {
        get {
            return targetDate
        } set {
            targetDate = newValue.dateWithDateComponents()
        }
    }
    
    public var day_String : String {
        return myDate.requestStringFromDate(data: .day) ?? ""
    }
    
    var month_String : String {
        return myDate.requestStringFromDate(data: .month) ?? ""
    }
    
    var weekday_String : String {
        return myDate.requestStringFromDate(data: .weekday) ?? ""
    }
    
    var day_Int : Int {
        return myDate.requestIntFromDate(data: .day) ?? 0
    }
    
    var month_Int : Int {
        return myDate.requestIntFromDate(data: .month) ?? 0
    }
    
    var year_Int : Int {
        return myDate.requestIntFromDate(data: .year) ?? 0
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
