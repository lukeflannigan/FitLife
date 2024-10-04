//  ActionButton.swift
//  Created by Luke Flannigan on 10/2/24.

import SwiftUI

struct ActionButton: View {
    let title: String
    let iconName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .font(.system(size: 20))
                Text(title)
                    .font(.custom("Poppins-Medium", size: 16))
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(15)
        }
    }
}

