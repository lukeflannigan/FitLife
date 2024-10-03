//  GoalProgressView.swift
//  Created by Luke Flannigan on 10/2/24.

import SwiftUI

struct GoalProgressView: View {
    let progress: CGFloat
    let goal: String
    let current: String
    let target: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(goal)
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(.primary)

            ProgressBar(progress: progress)
                .frame(height: 8)

            HStack {
                Text("\(current)/\(target)")
                    .font(.custom("Poppins-Medium", size: 14))
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.custom("Poppins-Bold", size: 14))
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
    }
}
