//  InfoRow.swift
//  Created by Luke Flannigan on 10/3/24.

import SwiftUI

struct InfoRow: View {
    let iconName: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: iconName)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("Poppins-Medium", size: 14))
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.custom("Poppins-Regular", size: 16))
                    .foregroundColor(.primary)
            }
            Spacer()
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
    }
}

