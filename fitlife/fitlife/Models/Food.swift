//  Food.swift
//  Created by Luke Flannigan on 10/4/24.

import Foundation

struct Food: Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
    let protein: Double
    let carbs: Double
    let fat: Double
}
