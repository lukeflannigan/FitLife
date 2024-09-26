//
//  WeeklyGoal.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 9/25/24.
//

import Foundation
import SwiftData

enum WeeklyGoal: String, Codable {
    case loseWeightSlow = "Lose 0.5lbs per Week"
    case loseWeightMedium = "Lose 1lb per Week"
    case loseWeightFast = "Lose 2lbs per Week"
    case maintainWeight = "Maintain Weight"
    case gainWeightSlow = "Gain 0.5lbs per Week"
    case gainWeightMedium = "Gain 1lb per Week"
    case gainWeightFast = "Gain 2lbs per Week"
}
