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
    var id: String  
    var name: String
    var category: String  
    var force: String?
    var level: String
    var mechanic: String?
    var equipment: String?
    var primaryMuscles: [String]
    var secondaryMuscles: [String]
    var instructions: [String]
    var images: [String]
    
    init(
        id: String = "",
        name: String = "",
        category: String = "",
        force: String? = nil,
        level: String = "beginner",
        mechanic: String? = nil,
        equipment: String? = nil,
        primaryMuscles: [String] = [],
        secondaryMuscles: [String] = [],
        instructions: [String] = [],
        images: [String] = []
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.force = force
        self.level = level
        self.mechanic = mechanic
        self.equipment = equipment
        self.primaryMuscles = primaryMuscles
        self.secondaryMuscles = secondaryMuscles
        self.instructions = instructions
        self.images = images
    }
}


