//
//  LoadManager.swift
//  infinitePageViewTest
//
//  Created by goya on 08/11/2018.
//  Copyright © 2018 goya. All rights reserved.
//

import Foundation

struct LoadManager {
    
    static let currentDate = Date().dateWithDateComponents()
    static var notedDates = [Date]()
    static var lastLoadedDate : Date = LoadManager.currentDate
    
    static var currentIndex : Int {
        if let index = notedDates.index(of: lastLoadedDate){
            return index
        } else {
            return 0
        }
    }
    
    enum requestedStatus {
        case showAll
        case showNoteExistOnly
    }
    
    static var loadingStatus : requestedStatus = .showNoteExistOnly
    
    static func getDateFromDiary() {
        notedDates = [Date]()
        if let diarys = try? Diary.loadAllDiary() {
            for diary in diarys {
                if let date = diary.date {
                    notedDates.append(date)
                }
            }
            notedDates.sort(){$0 < $1}
            if notedDates.last != currentDate {
                notedDates.append(currentDate)
            }
        }
    }
    
    private struct dateDistance {
        static let aDay = 1
        static let aWeek = 7
    }
    
    private enum directions {
        case present
        case after
    }
    
    private static func setNewDateWithDistanceFromDate(direction presentorafter: directions, from date: Date, distance datedistance: Int) -> Date? {
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
    
    static var presentDate: Date {
        let newDate = setNewDateWithDistanceFromDate(direction: .present, from: lastLoadedDate, distance: 1) ?? currentDate
        return newDate
    }
    
    static var afterDate: Date {
        let newDate = setNewDateWithDistanceFromDate(direction: .after, from: lastLoadedDate, distance: 1) ?? currentDate
        return newDate
    }
}
