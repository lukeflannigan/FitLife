//  CaloricIntakeCard.swift
//  Created by Luke Flannigan on 10/2/24.

import SwiftUI

struct CaloricIntakeCard: View {
    let currentCalories: Int
    let goalCalories: Int

    var body: some View {
        VStack(spacing: 10) {
            Text("Calories")
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(.primary)

            ProgressBar(progress: CGFloat(currentCalories) / CGFloat(goalCalories))
                .frame(height: 8)

            HStack {
                Text("\(currentCalories) cal")
                    .font(.custom("Poppins-Bold", size: 24))
                    .foregroundColor(.primary)
                Spacer()
                Text("Goal: \(goalCalories) cal")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
    }
}

