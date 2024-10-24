//
//  Exercise.swift
//  fitlife
//
//  Created by Thomas Mendoza on 9/30/24.
//

import Foundation
import SwiftData
import SwiftUI

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
    var imageData: Data?

    init(id: UUID = UUID(), name: String = "", type: String = "", muscleGroup: String = "",exerciseDescription: String = "", imageName: String = "",  difficulty: Difficulty = .easy, imageData: Data? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.muscleGroup = muscleGroup
        self.exerciseDescription = exerciseDescription
        self.imageName = imageName
        self.difficulty = difficulty
        self.imageData = imageData
    }
}


