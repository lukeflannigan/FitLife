//
//  BaseGoal.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 9/26/24.
//

import Foundation
import SwiftData

enum BaseGoal: String, Codable {
    case weightLoss = "Lose Weight"
    case weightGain = "Gain Weight"
    case muscleGain = "Gain Muscle"
    case weightMaintain = "Maintain Weight"
    case modifyDiet = "Modify Diet"
    case stayHealthy = "Stay Healthy"
}
