import SwiftUI

struct DashboardView: View {
    @State private var selectedTab = 2 // Start on Home tab
    
    let userName = "Dr. Lehr"
    let stats = [
        Stat(title: "Calories", value: "1,200", goal: "2,000"),
        Stat(title: "Protein", value: "75g", goal: "120g"),
        Stat(title: "Carbs", value: "150g", goal: "250g"),
        Stat(title: "Fats", value: "40g", goal: "65g")
    ]
    let activities = [
        Activity(icon: "dumbbell.fill", title: "Upper Body Workout", subtitle: "45 minutes • 250 calories", time: "2h ago"),
        Activity(icon: "fork.knife", title: "Lunch", subtitle: "Grilled Chicken Salad", time: "5h ago")
    ]
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        headerSection
                        quickStatsSection
                        recentActivitySection
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
    
    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Today's Overview")
                .font(.headline)
            
            ForEach(0..<stats.count / 2) { row in
                HStack(spacing: 15) {
                    StatCard(stat: stats[row * 2])
                    StatCard(stat: stats[row * 2 + 1])
                }
            }
        }
    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Recent Activity")
                    .font(.headline)
                Spacer()
                Button("See All") {
                    // Action to see all activities
                }
                .foregroundColor(.blue)
            }
            
            ForEach(activities) { activity in
                ActivityRow(activity: activity)
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

struct StatCard: View {
    let stat: Stat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(stat.title)
                .foregroundColor(.secondary)
            Text(stat.value)
                .font(.title2)
                .fontWeight(.bold)
            Text("Goal: \(stat.goal)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
    }
}

struct ActivityRow: View {
    let activity: Activity
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: activity.icon)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.blue)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.title)
                    .fontWeight(.semibold)
                Text(activity.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(activity.time)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(15)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
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

struct Stat: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let goal: String
}

struct Activity: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    let time: String
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
