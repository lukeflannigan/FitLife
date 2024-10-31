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
    var id: String
    var name: String
    var type: String
    var muscleGroup: String
    var exerciseDescription: String
    var imageName: String
    var difficulty: Difficulty
    var imageData: Data?
    var primaryMuscles: [String]
    var secondaryMuscles: [String]
    var equipment: String?
    var force: String?
    var mechanic: String?

    init(
        id: String = UUID().uuidString,
        name: String = "",
        type: String = "",
        muscleGroup: String = "",
        exerciseDescription: String = "",
        imageName: String = "",
        difficulty: Difficulty = .easy,
        imageData: Data? = nil,
        primaryMuscles: [String] = [],
        secondaryMuscles: [String] = [],
        equipment: String? = nil,
        force: String? = nil,
        mechanic: String? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.muscleGroup = muscleGroup
        self.exerciseDescription = exerciseDescription
        self.imageName = imageName
        self.difficulty = difficulty
        self.imageData = imageData
        self.primaryMuscles = primaryMuscles
        self.secondaryMuscles = secondaryMuscles
        self.equipment = equipment
        self.force = force
        self.mechanic = mechanic
    }
}


