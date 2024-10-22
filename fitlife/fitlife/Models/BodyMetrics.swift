//
//  BodyMetrics.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 10/22/24.
//

import Foundation
import SwiftData

@Model
class BodyMetrics {
    var startingWeightInKg: Double
    var currentWeightInKg: Double
    var goalWeightInKg: Double
    var bodyWeightLog: [BodyWeightEntry]

    init(startingWeightInKg: Double = 0, currentWeightInKg: Double = 0, goalWeightInKg: Double = 0, bodyWeightLog: [BodyWeightEntry] = []) {
        self.startingWeightInKg = startingWeightInKg
        self.currentWeightInKg = currentWeightInKg
        self.goalWeightInKg = goalWeightInKg
        self.bodyWeightLog = bodyWeightLog
    }

    // Method to log daily weight
    func logWeight(_ weight: Double) {
        currentWeightInKg = weight
        bodyWeightLog.append(BodyWeightEntry(date: Date(), weight: weight))
        adjustGoalsBasedOnWeight()
    }

    // Adjust related goals when weight changes
    func adjustGoalsBasedOnWeight() {
        // Placeholder: Adjust other goals based on weight change
    }
}
