//
//  BodyWeight.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 10/21/24.
//

import Foundation
import SwiftData

@Model
class BodyWeightEntry: Identifiable {
    var id: UUID
    var date: Date
    var weight: Double
    
    init(id: UUID = UUID(), date: Date, weight: Double) {
        self.id = id
        self.date = date
        self.weight = weight
    }
}
