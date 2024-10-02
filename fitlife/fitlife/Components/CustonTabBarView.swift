// CustonTabBarView.swift
// Created by Luke Flannigan on 10/1/24.

import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedTab: Tab

    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(selectedTab: $selectedTab, tab: .profile, imageName: "person.fill", title: "Profile")
            Spacer(minLength: 0)
            TabBarButton(selectedTab: $selectedTab, tab: .nutrition, imageName: "leaf.fill", title: "Nutrition")
            Spacer(minLength: 0)
            TabBarButton(selectedTab: $selectedTab, tab: .home, imageName: "house.fill", title: "Home")
            Spacer(minLength: 0)
            TabBarButton(selectedTab: $selectedTab, tab: .workouts, imageName: "dumbbell.fill", title: "Workouts")
            Spacer(minLength: 0)
            TabBarButton(selectedTab: $selectedTab, tab: .progress, imageName: "chart.bar.fill", title: "Progress")
        }
        .padding(.horizontal, 10)
        .padding(.top, 10)
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 20)
        .background(Color(UIColor.systemBackground).opacity(0.95))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
    }
}
