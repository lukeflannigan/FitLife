//  ExerciseData.swift
// Created by Luke Flannigan on 10/17/24.

import Foundation

struct ExerciseData: Codable {
    let id: String
    let name: String
    let force: String?
    let level: String
    let mechanic: String?
    let equipment: String?
    let primaryMuscles: [String]
    let secondaryMuscles: [String]
    let instructions: [String]
    let category: String
    let images: [String]
    
    func toExercise() -> Exercise {
        return Exercise(
            id: id,
            name: name,
            category: category,
            force: force,
            level: level,
            mechanic: mechanic,
            equipment: equipment,
            primaryMuscles: primaryMuscles,
            secondaryMuscles: secondaryMuscles,
            instructions: instructions,
            images: images
        )
    }
}
