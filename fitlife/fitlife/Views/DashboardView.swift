import SwiftUI

struct DashboardView: View {
    @State private var selectedTab = 2 // Start on Home tab
    
    let userName = "Dr. Lehr"
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        headerSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                }
                
                customTabBar
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back,")
                    .foregroundColor(.secondary)
                Text(userName)
                    .font(.title)
                    .fontWeight(.bold)
            }
            Spacer()
            Button(action: {
                // Action for notifications
            }) {
                Image(systemName: "bell.fill")
                    .foregroundColor(.primary)
                    .padding(12)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(Circle())
            }
        }
    }
    
    private var customTabBar: some View {
        HStack {
            ForEach(TabItem.allCases, id: \.self) { tab in
                Spacer()
                TabBarButton(tab: tab, isSelected: selectedTab == tab.rawValue) {
                    selectedTab = tab.rawValue
                }
                Spacer()
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 30)
        .background(Color(UIColor.systemBackground).opacity(0.95))
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.iconName)
                    .foregroundColor(isSelected ? .blue : .gray)
                Text(tab.title)
                    .font(.caption2)
                    .foregroundColor(isSelected ? .blue : .gray)
            }
        }
    }
}

enum TabItem: Int, CaseIterable {
    case profile, nutrition, home, workouts, progress
    
    var title: String {
        switch self {
        case .profile: return "Profile"
        case .nutrition: return "Nutrition"
        case .home: return "Home"
        case .workouts: return "Workouts"
        case .progress: return "Progress"
        }
    }
    
    var iconName: String {
        switch self {
        case .profile: return "person.fill"
        case .nutrition: return "leaf.fill"
        case .home: return "house.fill"
        case .workouts: return "dumbbell.fill"
        case .progress: return "chart.bar.fill"
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
