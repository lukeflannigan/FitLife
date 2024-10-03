// ProgressBar.swift
//  Created by Luke Flannigan on 10/1/24.

import SwiftUI

struct ProgressBar: View {
    let progress: CGFloat 
    let goal: String
    let current: String
    let target: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(goal)
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(.primary)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(UIColor.systemGray5))
                        .frame(height: 8)
                        .cornerRadius(4)
                    Rectangle()
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]),
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                        .frame(width: geometry.size.width * progress, height: 8)
                        .cornerRadius(4)
                }
            }
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
