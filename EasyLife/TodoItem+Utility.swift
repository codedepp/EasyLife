//
//  TodoItem+Utility.swift
//  EasyLife
//
//  Created by Lee Arromba on 12/04/2017.
//  Copyright © 2017 Pink Chicken Ltd. All rights reserved.
//

import Foundation
import CoreData

extension TodoItem {
    var repeatState: RepeatState? { // TODO: will never be nil right?
        get {
            return RepeatState(rawValue: Int(repeats))
        }
        set {
            repeats = Int16(newValue?.rawValue ?? 0)
        }
    }
    
    func incrementDate() {
        guard
            let oldDate = date,
            let repeatState = repeatState,
            let incrementedDate = repeatState.increment(date: oldDate) else {
                return
        }
        self.date = incrementedDate
        if incrementedDate < Date() {
            incrementDate()
        }
    }
}
