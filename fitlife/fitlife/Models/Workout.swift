//
//  Workout.swift
//  fitlife
//
//  Created by Thomas Mendoza on 9/30/24.
//

import Foundation

class WorkoutEntry: Identifiable, Codable, ObservableObject {
    var id: UUID
    var exercise: Exercise
    var sets: Int
    var reps: Int
    var weight: Double
    var date: Date
    
    init(id: UUID = UUID(), exercise: Exercise, sets: Int, reps: Int, weight: Double, date: Date = Date()) {
        self.id = id
        self.exercise = exercise
        self.sets = sets
        self.reps = reps
        self.weight = weight
        self.date = date
    }
}
