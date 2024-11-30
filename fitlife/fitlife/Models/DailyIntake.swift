//
//  DailyIntake.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 10/21/24.
//

import Foundation
import SwiftData

@Model
class DailyIntake: Identifiable {
    var id: UUID
    var date: Date
    var calories: Double
    var protein: Double
    var carbs: Double
    var fats: Double
    var name: String // Added name so that User can enter name of what food they ate.
    
    init(id: UUID = UUID(), date: Date = Date(), calories: Double, protein: Double, carbs: Double, fats: Double, name: String = "") {
        self.id = id
        self.date = date
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fats = fats
        self.name = name   //Modified this to match the change above.
    }
    
    // Convenience description for debugging or displaying intake
    var description: String {
        return "\(name): \(calories) kcal, \(protein)g protein, \(carbs)g carbs, \(fats)g fats"
    }
    var activityDescription: String {
        return "\(name): \(calories) kcal, \(protein)g protein"
    }
}
