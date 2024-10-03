//  MacroNutrientProgressCard.swift
//  Created by Luke Flannigan on 10/2/24.

import SwiftUI

struct MacroNutrientProgressCard: View {
    let nutrientName: String
    let currentAmount: Int
    let goalAmount: Int
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(nutrientName)
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(.primary)

            HStack {
                Text("\(currentAmount)g")
                    .font(.custom("Poppins-Bold", size: 24))
                    .foregroundColor(.primary)
                Spacer()
                Text("Goal: \(goalAmount)g")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.secondary)
            }

            ProgressBar(
                progress: CGFloat(currentAmount) / CGFloat(goalAmount),
                gradientColors: [color, color.opacity(0.5)]
            )
            .frame(height: 8)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
    }
}
