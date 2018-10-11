//
//  setCalendar.swift
//  dateAppTest
//
//  Created by goya on 2018. 7. 24..
//  Copyright © 2018년 goya. All rights reserved.
//

import Foundation

class DateBrain {
    
    var calendar : Calendar!
    
    var currentDate : Date {
        //return setDateWithDateComponents()
        return Date().dateWithDateComponents()
    }
    
    var currentDay : Int {
        return transformDateTo(type: .day_Int, from: currentDate) ?? 0
    }
    
    var currentMonth : Int {
        return transformDateTo(type: .month_Int, from: currentDate) ?? 0
    }
    
    var currentYear : Int {
        return transformDateTo(type: .year_Int, from: currentDate) ?? 0
    }
    
    private var targetDate : Date = Date()
    
    var myDate : Date {
        get {
            return targetDate
        } set {
            //targetDate = setDateWithDateComponents(from: newValue)
            targetDate = newValue.dateWithDateComponents()
        }
    }
    
    fileprivate func setDateWithDateComponents(from calledDate: Date = Date()) -> Date {
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: calledDate)
        let date = calendar.date(from: dateComponents)!
        return date
    }
    
    //MARK: Date transform settings
    
    fileprivate struct setDatecomponentsForTransform {
        static func transformToIntCase(_ com: Calendar.Component, from date: Date) -> DateComponents {
            var component : DateComponents
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([com], from: date)
            component = dateComponents
            return component
        }
        static func transformToStringCase(dateformat format: String, from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter.string(from: date)
        }
    }
    
    enum dateformatterCases {
        case day_String
        case day_WithMultiNumber_String
        case weekday_String
        case month_String
        case year_String
        case day_Int
        case month_Int
        case year_Int
    }
    
    private enum requiredDateTransform {
        case transformToString((Date) -> String)
        case transformToInt((Date) -> Int)
    }
    
    private var transformTypeForDate : Dictionary<dateformatterCases,requiredDateTransform> = [
        .month_String : .transformToString({
            return setDatecomponentsForTransform.transformToStringCase(dateformat: "MMM", from: $0)
        }),
        .weekday_String : .transformToString({
            return setDatecomponentsForTransform.transformToStringCase(dateformat: "EEEE", from: $0)
        }),
        .day_String : .transformToString({
            let ruffStyle = Int(setDatecomponentsForTransform.transformToStringCase(dateformat: "dd", from: $0))
            let calculateForDensity = (ruffStyle! - (ruffStyle! % 10)) + (ruffStyle! % 10)
            var dayString = ""
            (calculateForDensity < 10) ? (dayString = " " + "\(calculateForDensity)") : (dayString = "\(calculateForDensity)")
            return dayString
        }),
        .year_String : .transformToString({
            return setDatecomponentsForTransform.transformToStringCase(dateformat: "YYYY", from: $0)
        }),
        .day_WithMultiNumber_String : .transformToString({
            return setDatecomponentsForTransform.transformToStringCase(dateformat: "dd", from: $0)
        }),
        .day_Int : .transformToInt ({
            return setDatecomponentsForTransform.transformToIntCase(.day, from: $0).day!
        }),
        .month_Int : .transformToInt ({
            return setDatecomponentsForTransform.transformToIntCase(.month, from: $0).month!
        }),
        .year_Int : .transformToInt ({
            return setDatecomponentsForTransform.transformToIntCase(.year, from: $0).year!
        })
    ]
    
    func transformDateTo<T>(type formWith: dateformatterCases, from date: Date = Date()) -> T? {
        if let recommendedType = transformTypeForDate[formWith] {
            switch recommendedType {
            case .transformToString(let form) : return form(date) as? T
            case .transformToInt(let form) : return form(date) as? T
            }
        }
        return nil
    }
    
    //init setting
    
    init() {
        calendar = Calendar.current
    }
}

extension Date {
    func dateWithDateComponents() -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        let date = calendar.date(from: dateComponents)
        return date!
    }
}
