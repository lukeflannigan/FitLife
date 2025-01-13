// StatCard.swift
// Created by Luke Flannigan on 10/1/24.

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let goal: Double
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(.secondary)
            Text(value)
                .font(.custom("Poppins-Bold", size: 24))
                .foregroundColor(.primary)
            Text("Goal: \(goal, format: .number.rounded(increment: 1.0))g")
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [color, color.opacity(0.5)]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing),
                    lineWidth: 2
                )
        )
    }
}
