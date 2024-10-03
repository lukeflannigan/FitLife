// ProgressBar.swift
//  Created by Luke Flannigan on 10/1/24.

import SwiftUI

struct ProgressBar: View {
    let progress: CGFloat // Basically a double 0-1. 
    var gradientColors: [Color] = [Color("GradientStart"), Color("GradientEnd")]

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(UIColor.systemGray5))
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: gradientColors),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * progress)
            }
        }
        .frame(height: 8)
    }
}
