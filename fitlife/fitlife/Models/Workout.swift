//
//  Workout.swift
//  fitlife
//
//  Created by Thomas Mendoza on 9/30/24.
//

import Foundation
import SwiftData

@Model
class Workout: Identifiable, ObservableObject {
    var id: UUID
    var name: String
    var exercises: [Exercise]
    var sets: Int
    var reps: Int
    var weight: Double
    var date: Date
    var isFavorite: Bool

    init(id: UUID = UUID(), name: String = "defaultworkoutname", exercises: [Exercise], sets: Int = 0, reps: Int = 0, weight: Double = 0.0, date: Date = Date(), isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.exercises = exercises
        self.sets = sets
        self.reps = reps
        self.weight = weight
        self.date = date
        self.isFavorite = isFavorite
    }
}

extension Workout {
    static var mockWorkoutEntries = [
        Workout(exercises: [Exercise(name: "Bench Press", type: "Strength", muscleGroup: "Chest")], sets: 3, reps: 10, weight: 150),
        Workout(exercises: [Exercise(name: "Squat", type: "Strength", muscleGroup: "Legs")], sets: 4, reps: 8, weight: 200)
    ]
}

