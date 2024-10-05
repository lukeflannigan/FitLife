//  FoodDetailView.swift
//  Created by Luke Flannigan on 10/4/24.

import SwiftUI

struct FoodDetailView: View {
    let food: Food
    
    var body: some View {
        List {
            Section(header: Text("Nutrition Facts")) {
                InfoRow(iconName: "flame.fill", title: "Calories", value: "\(food.calories)")
                InfoRow(iconName: "atom", title: "Protein", value: String(format: "%.1fg", food.protein))
                InfoRow(iconName: "leaf.fill", title: "Carbs", value: String(format: "%.1fg", food.carbs))
                InfoRow(iconName: "drop.fill", title: "Fat", value: String(format: "%.1fg", food.fat))
            }
        }
        .navigationTitle(food.name)
    }
}
