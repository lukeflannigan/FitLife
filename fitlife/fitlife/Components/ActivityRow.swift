// ActivityRow.swift
// Created by Luke Flannigan on 10/1/24.

import SwiftUI

struct ActivityRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let time: String

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                )
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(time)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
    }
}
