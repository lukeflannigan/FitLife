//  NutritionView.swift
//  Created by Luke Flannigan on 10/1/24.

import SwiftUI
import SwiftData

struct NutritionView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var dailyLogs: [DailyNutritionLog]
    @State private var selectedDate = Date()
    @State private var showFoodSearch = false
    @State private var showRecipeSearch = false
    
    private var selectedLog: DailyNutritionLog? {
        dailyLogs.first { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 24) {
                        dateSelector
                        nutritionSummary
                        mealsListView
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 90)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Nutrition")
                            .font(.title2.bold())
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showRecipeSearch = true }) {
                            Image(systemName: "book.closed.fill")
                                .foregroundColor(.black)
                        }
                    }
                }
                
                addFoodButton
                    .padding(.bottom, 49)
                    .background(
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .ignoresSafeArea()
                    )
            }
            .sheet(isPresented: $showFoodSearch) {
                NavigationStack {
                    FoodSearchView(selectedDate: selectedDate, mealType: .breakfast)
                }
            }
            .sheet(isPresented: $showRecipeSearch) {
                NavigationStack {
                    SearchView()
                }
            }
        }
    }
    
    private var dateSelector: some View {
        HStack(spacing: 20) {
            Button(action: { moveDate(by: -1) }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.primary)
                    .font(.title3)
            }
            
            Capsule()
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10)
                .frame(height: 40)
                .overlay(
                    Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.headline)
                )
            
            Button(action: { moveDate(by: 1) }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.primary)
                    .font(.title3)
            }
            .disabled(isNextDayDisabled)
        }
        .padding(.vertical)
        .onChange(of: selectedDate) { ensureLogExists() }
    }
    
    private var nutritionSummary: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                CalorieProgressCircle(calories: selectedLog?.totalCalories ?? 0)
                
                VStack(spacing: 12) {
                    MacroProgressBar(
                        label: "Protein",
                        value: selectedLog?.totalProtein ?? 0,
                        goal: 150,
                        color: .green
                    )
                    MacroProgressBar(
                        label: "Carbs",
                        value: selectedLog?.totalCarbs ?? 0,
                        goal: 250,
                        color: .blue
                    )
                    MacroProgressBar(
                        label: "Fat",
                        value: selectedLog?.totalFat ?? 0,
                        goal: 65,
                        color: .orange
                    )
                }
            }
            .padding(20)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.06), radius: 12)
        }
    }
    
    private var mealsListView: some View {
        VStack(spacing: 16) {
            ForEach(MealType.allCases, id: \.self) { mealType in
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: mealType.icon)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 26, height: 26)
                            .background(mealType.iconColor)
                            .clipShape(Circle())
                        
                        Text(mealType.rawValue)
                            .font(.system(size: 16, weight: .semibold))
                        
                        Spacer()
                        
                        Text("\((selectedLog?.entriesByMeal[mealType]?.reduce(0) { $0 + Int($1.totalCalories) }) ?? 0) kcal")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    
                    if let entries = selectedLog?.entriesByMeal[mealType], !entries.isEmpty {
                        ForEach(entries) { entry in
                            SwipeableEntryRow(entry: entry, onDelete: deleteEntry)
                                .padding(.leading, 34)
                        }
                    } else {
                        Text("No foods logged")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .padding(.leading, 34)
                    }
                }
                .padding(16)
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.06), radius: 12)
            }
        }
    }
    
    private var addFoodButton: some View {
        Button(action: { showFoodSearch = true }) {
            HStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                Text("Add Food")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.black)
            .cornerRadius(26)
            .shadow(color: Color.black.opacity(0.15), radius: 20)
        }
        .padding(.horizontal, 20)
    }
    
    private var isNextDayDisabled: Bool {
        Calendar.current.isDateInTomorrow(selectedDate) || 
        Calendar.current.isDate(selectedDate, inSameDayAs: Date())
    }
    
    private func moveDate(by days: Int) {
        if let newDate = Calendar.current.date(byAdding: .day, value: days, to: selectedDate) {
            if !Calendar.current.isDateInTomorrow(newDate) {
                selectedDate = newDate
            }
        }
    }
    
    private func ensureLogExists() {
        let startOfDay = Calendar.current.startOfDay(for: selectedDate)
        let logExists = dailyLogs.contains { Calendar.current.isDate($0.date, inSameDayAs: startOfDay) }
        
        if !logExists {
            let newLog = DailyNutritionLog(date: startOfDay)
            modelContext.insert(newLog)
        }
    }
    
    private func deleteEntry(_ entry: NutritionEntry) {
        guard let dailyLog = dailyLogs.first(where: { $0.entries.contains { $0.id == entry.id }}) else { return }
        
        dailyLog.entries.removeAll { $0.id == entry.id }
        modelContext.delete(entry)
        
        let isToday = Calendar.current.isDate(dailyLog.date, inSameDayAs: Date())
        if dailyLog.entries.isEmpty && !isToday {
            modelContext.delete(dailyLog)
        }
    }
}

private struct CalorieProgressCircle: View {
    let calories: Int
    let goal: Int = 2000
    
    private var progress: Double {
        min(Double(calories) / Double(goal), 1.0)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.systemGray6), lineWidth: 12)
                .frame(width: 120, height: 120)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [.purple, .indigo, .purple],
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(270)
                    ),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .frame(width: 120, height: 120)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
            
            VStack(spacing: 4) {
                Text("\(calories)")
                    .font(.system(size: 24, weight: .bold))
                Text("kcal")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct MacroProgressBar: View {
    let label: String
    let value: Double
    let goal: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(Int(value))g")
                    .font(.system(size: 14, weight: .medium))
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray6))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: min(geometry.size.width * CGFloat(value / goal), geometry.size.width), height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}

struct FoodEntryRow: View {
    let entry: NutritionEntry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.foodItem.name)
                    .font(.subheadline.weight(.medium))
                
                if let brand = entry.foodItem.brandName {
                    Text(brand)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text("\(entry.servings, specifier: "%.1f") serving(s)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(Int(entry.totalCalories)) cal")
                .font(.subheadline.weight(.medium))
        }
    }
}

extension MealType {
    var icon: String {
        switch self {
        case .breakfast: return "sunrise.fill"
        case .lunch: return "sun.max.fill"
        case .dinner: return "moon.stars.fill"
        case .snack: return "leaf.fill"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .breakfast: return .orange
        case .lunch: return .yellow
        case .dinner: return .indigo
        case .snack: return .green
        }
    }
}

private struct SwipeableEntryRow: View {
    let entry: NutritionEntry
    let onDelete: (NutritionEntry) -> Void
    
    @State private var offset: CGFloat = 0
    @State private var showEditView = false
    @State private var isActive = false
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Color.red
                .overlay(
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .padding(.trailing, 20),
                    alignment: .trailing
                )
            
            HStack {
                FoodEntryRow(entry: entry)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .background(Color(.systemBackground))
                    .onTapGesture {
                        if !isActive {
                            showEditView = true
                        }
                    }
            }
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        isActive = true
                        offset = gesture.translation.width < 0 
                            ? max(gesture.translation.width, -100)
                            : max(gesture.translation.width - 100, -100)
                    }
                    .onEnded { gesture in
                        withAnimation(.spring()) {
                            if offset < -50 {
                                onDelete(entry)
                            } else {
                                offset = 0
                            }
                            isActive = false
                        }
                    }
            )
        }
        .frame(height: 50)
        .clipped()
        .sheet(isPresented: $showEditView) {
            NavigationStack {
                if let fatSecretId = entry.foodItem.fatSecretId {
                    EditServingSizeView(
                        foodId: fatSecretId,
                        existingEntry: entry
                    )
                }
            }
        }
    }
}

private struct EditServingSizeView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let foodId: String
    let existingEntry: NutritionEntry
    
    @State private var detailedFood: FatSecretFood?
    @State private var servingCount: Double
    @State private var selectedMealType: MealType
    
    init(foodId: String, existingEntry: NutritionEntry) {
        self.foodId = foodId
        self.existingEntry = existingEntry
        _servingCount = State(initialValue: existingEntry.servings)
        _selectedMealType = State(initialValue: existingEntry.mealType)
    }
    
    var body: some View {
        if let detailedFood = detailedFood {
            ServingSizeSelectionView(
                food: detailedFood,
                selectedDate: existingEntry.date,
                mealType: selectedMealType,
                initialServingCount: servingCount,
                existingEntry: existingEntry,
                onComplete: { dismiss() }
            )
        } else {
            ProgressView()
                .task {
                    do {
                        detailedFood = try await FatSecretService.shared.getFoodDetails(id: foodId)
                    } catch {
                        print("Error loading food details:", error)
                    }
                }
        }
    }
}
