//
//  Exercise.swift
//  fitlife
//
//  Created by Thomas Mendoza on 9/30/24.
//

import Foundation

class Exercise: Identifiable, Codable, ObservableObject {
    var id: UUID
    var name: String
    var type: String
    var muscleGroup: String
    
    init(id: UUID = UUID(), name: String, type: String, muscleGroup: String) {
        self.id = id
        self.name = name
        self.type = type
        self.muscleGroup = muscleGroup
    }
}

