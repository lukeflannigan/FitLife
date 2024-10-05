//
//  Exercise.swift
//  fitlife
//
//  Created by Thomas Mendoza on 9/30/24.
//

import Foundation
import SwiftData

@Model
class Exercise: Identifiable, ObservableObject {
    var id: UUID
    var name: String
    var type: String
    var muscleGroup: String

    init(id: UUID = UUID(), name: String = "", type: String = "", muscleGroup: String = "") {
        self.id = id
        self.name = name
        self.type = type
        self.muscleGroup = muscleGroup
    }
}

extension Exercise {
    static var mockExercises = [
        Exercise(name: "Bench Press", type: "Strength", muscleGroup: "Chest"),
        Exercise(name: "Squat", type: "Strength", muscleGroup: "Legs"),
        Exercise(name: "Deadlift", type: "Strength", muscleGroup: "Back")
    ]
}

