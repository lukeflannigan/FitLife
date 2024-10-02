// MainView.swift
// Created by Luke Flannigan on 10/1/24.

import SwiftUI

enum Tab {
    case profile
    case nutrition
    case home
    case workouts
    case progress
}

struct MainView: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
        ZStack {
            switch selectedTab {
            case .profile:
                ProfileView()
            case .nutrition:
                NutritionView()
            case .home:
                HomeView()
            case .workouts:
                WorkoutsView()
            case .progress:
                ProgressView()
            }
            
            VStack {
                Spacer()
                CustomTabBarView(selectedTab: $selectedTab)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
