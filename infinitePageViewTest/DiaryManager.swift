//
//  DiaryManager.swift
//  infinitePageViewTest
//
//  Created by goya on 12/11/2018.
//  Copyright © 2018 goya. All rights reserved.
//

import Foundation

class DiaryManager {
    
    var currentDate = Date().dateWithDateComponents()
    var isShowsAll = false
    var diaries = [TodaysDiary]()
    
    func loadDiariesFromDataBase() {
        if let diarys = try? Diary.loadAllDiary() {
            for diary in diarys {
                if let date = diary.date {
                    let todaysDiary = TodaysDiary(date: date, diary: diary)
                    diaries.append(todaysDiary)
                }
            }
            diaries.sort(){$0.date! < $1.date!}
            if diaries.last?.date != currentDate {
                diaries.append(TodaysDiary(date: currentDate, diary: nil))
            }
        }
    }
    
    func checkEmptyTodaysDiary() {
        diaries = diaries.filter{$0.diary != nil}
    }
}
