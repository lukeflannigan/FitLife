//
//  NutritionGoals.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 9/29/24.
//

import Foundation
import SwiftData

enum NutritionGoal: String, Codable {
    case trackMacros = "Track Macros"
    case eatVegan = "Eat Vegan"
    case eatVegetarian = "Eat Vegetarian"
    case eatPescetarian = "Eat Pescetarian"
    case lessSugar = "Less Sugar"
    case lessProtein = "Less Protein"
    case lessDairy = "Less Dairy"
    case lessFats = "Less Fats"
    case moreProtein = "More Protein"
    case moreDairy = "More Dairy"
    case moreFats = "More Fats"
    case moreVeggies = "More Veggies"
    case moreFruits = "More Fruits"
}

