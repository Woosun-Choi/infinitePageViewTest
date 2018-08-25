//
//  NoteEditProtocols.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 24..
//  Copyright © 2018년 goya. All rights reserved.
//

import Foundation

protocol SaveNewData {
    func saveNewData(image imageData: Data?, comment commentData: String?)
}

protocol SetSavingData {
    func setSavingData(image imageData: Data?, comment commentData: String?)
}
