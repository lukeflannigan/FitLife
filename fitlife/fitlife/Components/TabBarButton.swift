// TabBarButton.swift
// Created by Luke Flannigan on 10/1/24.

import SwiftUI

struct TabBarButton: View {
    @Binding var selectedTab: Tab
    let tab: Tab
    let imageName: String
    let title: String

    var body: some View {
        Button(action: {
            withAnimation {
                selectedTab = tab
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: imageName)
                    .font(.system(size: 20))
                    .foregroundColor(selectedTab == tab ? Color("GradientStart") : .secondary)
                Text(title)
                    .font(.custom("Poppins-Medium", size: 10))
                    .foregroundColor(selectedTab == tab ? Color("GradientStart") : .secondary)
            }
            .frame(maxWidth: .infinity) 
        }
    }
}
