//  ExerciseData.swift
// Created by Luke Flannigan on 10/17/24.

import Foundation

struct ExerciseData: Identifiable, Codable {
    let id: UUID
    let name: String
    let type: String
    let muscleGroup: String
    let exerciseDescription: String
    let imageName: String
    let difficulty: Difficulty

    func toExercise() -> Exercise {
        return Exercise(
            id: id,
            name: name,
            type: type,
            muscleGroup: muscleGroup,
            difficulty: difficulty,
            exerciseDescription: exerciseDescription,
            imageName: imageName
        )
    }
}
