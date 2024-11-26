//
//  WorkoutTemplate.swift
//  fitlife
//
//  Created by Thomas Mendoza on 11/26/24.
//

import Foundation
import SwiftData

@Model
class WorkoutTemplate: Identifiable {
    @Attribute(.unique) var id: UUID // Unique ID for each template
    var name: String // Name of the workout template
    var exercises: [WorkoutExercise] // List of exercises in the template
    
    init(name: String, exercises: [WorkoutExercise] = []) {
        self.id = UUID()
        self.name = name
        self.exercises = exercises
    }
}
