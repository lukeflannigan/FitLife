//
//  ExerciseSet.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 11/13/24.
//

import Foundation
import SwiftData

@Model
class ExerciseSet: Identifiable, Comparable {
    var id: UUID
    var reps: Int
    var weight: Double
    var date: Date
    
    static func < (lhs: ExerciseSet, rhs: ExerciseSet) -> Bool {
        lhs.date > rhs.date
    }
    
    init(id: UUID = UUID(), reps: Int, weight: Double, date: Date = Date()) {
        self.id = id
        self.reps = reps
        self.weight = weight
        self.date = date
    }
    
    static var emptySet: ExerciseSet {
        ExerciseSet(reps: 0, weight: 0)
    }
}
