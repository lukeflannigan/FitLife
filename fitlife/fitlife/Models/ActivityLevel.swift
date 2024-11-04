//
//  ActivityLevel.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 9/25/24.
//

import Foundation
import SwiftData

enum ActivityLevel: String, Codable {
    case sedentary = "Sedentary"
    case lightActivity = "Lightly Active"
    case moderateActivity = "Moderate Active"
    case veryActive = "Very Active"
    case superActive = "Super Active"
    
    func calorieMultiplier() -> Double {
        switch self {
        case .sedentary: return 1.2
        case .lightActivity: return 1.375
        case .moderateActivity: return 1.55
        case .veryActive: return 1.725
        case .superActive: return 1.9
        }
    }
}
