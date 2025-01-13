//
//  Workout.swift
//  fitlife
//
//  Created by Thomas Mendoza on 9/30/24.
//

import Foundation
import SwiftData

@Model
class Workout {
    var id: UUID
    var name: String
    var date: Date
    var completed: Bool = false
    @Relationship(deleteRule: .cascade, inverse: \WorkoutExercise.workout)
    var workoutExercises: [WorkoutExercise] = []

    init(id: UUID = UUID(), name: String, date: Date = Date(), completed: Bool = false, workoutExercises: [WorkoutExercise] = []) {
        self.id = id
        self.name = name
        self.date = date
        self.completed = completed
        self.workoutExercises = workoutExercises
    }
    
    func addExercise(_ workoutExercise: WorkoutExercise, context: ModelContext) {
        workoutExercises.append(workoutExercise)
        context.insert(workoutExercise)
    }
    
    func removeExercise(_ workoutExercise: WorkoutExercise, context: ModelContext) {
        if let index = workoutExercises.firstIndex(where: { $0.id == workoutExercise.id}) {
            workoutExercises.remove(at: index)
            context.delete(workoutExercise)
        }
    }
}
