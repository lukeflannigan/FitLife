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
    var date: Date

    init(id: UUID = UUID(), name: String = "defaultworkoutname", exercises: [Exercise], date: Date = Date()) {
        self.id = id
        self.name = name
        self.exercises = exercises
        self.date = date
    }
}

extension Workout {
    static var mockWorkoutEntry =
        Workout(
            name: "Chest and Legs Workout",
            exercises: [
                Exercise(
                    name: "Bench Press",
                    type: "Strength",
                    muscleGroup: "Chest",
                    exerciseDescription: "A compound exercise for chest muscles",
                    imageName: "bench_press_image",
                    difficulty: .medium,
                    primaryMuscles: ["Pectorals"],
                    secondaryMuscles: ["Triceps", "Deltoids"],
                    equipment: "Barbell",
                    sets: 3,
                    reps: 10,
                    weight: 150
                ),
                Exercise(
                    name: "Squat",
                    type: "Strength",
                    muscleGroup: "Legs",
                    exerciseDescription: "A compound exercise for leg muscles",
                    imageName: "squat_image",
                    difficulty: .hard,
                    primaryMuscles: ["Quadriceps"],
                    secondaryMuscles: ["Glutes", "Hamstrings"],
                    equipment: "Barbell",
                    sets: 4,
                    reps: 8,
                    weight: 200
                )
            ]
        )
}


