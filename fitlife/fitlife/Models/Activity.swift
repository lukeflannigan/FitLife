//
//  Activity.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 11/30/24.
//

import Foundation

enum Activity: Identifiable {
    case workout(Workout)
    case food(DailyIntake)

    var id: UUID {
        switch self {
        case .workout(let workout): return workout.id
        case .food(let food): return food.id
        }
    }

    var date: Date {
        switch self {
        case .workout(let workout): return workout.date
        case .food(let food): return food.date
        }
    }

    var title: String {
        switch self {
        case .workout(let workout): return workout.name
        case .food(let food): return food.name
        }
    }

    var subtitle: String {
        switch self {
        case .workout(let workout): return "Completed on \(workout.date.formatted(date: .abbreviated, time: .omitted))"
        case .food(let food): return food.activityDescription
        }
    }

    var icon: String {
        switch self {
        case .workout: return "figure.walk"
        case .food: return "fork.knife"
        }
    }
}
