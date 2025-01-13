//  ExerciseData.swift
// Created by Luke Flannigan on 10/17/24..

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
        let difficulty: Difficulty
        switch level.lowercased() {
        case "beginner":
            difficulty = .easy
        case "intermediate":
            difficulty = .medium
        case "expert":
            difficulty = .hard
        default:
            difficulty = .medium
        }
        
        return Exercise(
            id: id,
            name: name,
            type: category,
            muscleGroup: primaryMuscles.first ?? "",
            exerciseDescription: instructions.joined(separator: "\n"),
            imageName: getImageUrl(from: images.first),
            difficulty: difficulty,
            primaryMuscles: primaryMuscles,
            secondaryMuscles: secondaryMuscles,
            equipment: equipment,
            force: force,
            mechanic: mechanic
        )
    }
    
    private func getImageUrl(from imagePath: String?) -> String {
        guard let imagePath = imagePath else { return "" }
        return "https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/\(imagePath)"
    }
}

class ExerciseAPIClient {
    static let shared = ExerciseAPIClient()
    private let baseURL = "https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/dist/exercises.json"
    
    func fetchExercises() async throws -> [Exercise] {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let exercises = try decoder.decode([ExerciseData].self, from: data)
        return exercises.map { $0.toExercise() }
    }
}
