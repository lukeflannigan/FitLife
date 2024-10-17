//
//  Exercise.swift
//  fitlife
//
//  Created by Thomas Mendoza on 9/30/24.
//

import Foundation
import SwiftData

enum Difficulty: String, CaseIterable, Codable{
    case easy = "Warmup"
    case medium = "Moderate"
    case hard = "Intense"
}

@Model
class Exercise: Identifiable, ObservableObject {
    var id: UUID
    var name: String
    var type: String
    var muscleGroup: String
    var exerciseDescription: String
    var imageName: String
    var difficulty: Difficulty

    init(id: UUID = UUID(), name: String = "", type: String = "", muscleGroup: String = "", difficulty: Difficulty = .easy, exerciseDescription: String = "", imageName: String = "") {
        self.id = id
        self.name = name
        self.type = type
        self.muscleGroup = muscleGroup
        self.exerciseDescription = exerciseDescription
        self.imageName = imageName
        self.difficulty = difficulty
    }
}


