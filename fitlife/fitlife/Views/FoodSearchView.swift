import SwiftUI
import SwiftData

struct FoodSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    @State private var searchResults: [FatSecretFood] = []
    @State private var isSearching = false
    @State private var errorMessage: String?
    @State private var selectedMealType: MealType
    
    private let selectedDate: Date
    private let mealType: MealType
    
    init(selectedDate: Date, mealType: MealType) {
        self.selectedDate = selectedDate
        self.mealType = mealType
        _selectedMealType = State(initialValue: mealType)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    searchBar
                    
                    Group {
                        if let error = errorMessage {
                            ContentMessageView(message: error, color: .red)
                        } else if searchResults.isEmpty && !searchText.isEmpty {
                            ContentMessageView(message: "No results found", color: .secondary)
                        } else {
                            resultsList
                        }
                    }
                }
                
                if isSearching {
                    LoadingView()
                }
            }
            .navigationTitle("Search Foods")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.black)
                }
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .font(.system(size: 20))
                
                TextField("Search for foods...", text: $searchText)
                    .font(.system(size: 17))
                    .textFieldStyle(PlainTextFieldStyle())
                    .autocapitalization(.none)
                    .onChange(of: searchText) { oldValue, newValue in
                        guard oldValue != newValue else { return }
                        searchFoods()
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 20))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }
    
    private var resultsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(searchResults, id: \.foodId) { food in
                    NavigationLink {
                        ServingSizeSelectionView(
                            food: food,
                            selectedDate: selectedDate,
                            mealType: selectedMealType,
                            onComplete: { dismiss() }
                        )
                    } label: {
                        FoodSearchResultRow(food: food)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func searchFoods() {
        let trimmedText = searchText.trimmingCharacters(in: .whitespaces)
        guard !trimmedText.isEmpty else {
            searchResults = []
            return
        }
        
        Task {
            isSearching = true
            defer { isSearching = false }
            
            do {
                errorMessage = nil
                searchResults = try await FatSecretService.shared.searchFoods(query: trimmedText)
            } catch {
                errorMessage = "Unable to search foods: \(error.localizedDescription)"
            }
        }
    }
}

struct ServingSizeSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let food: FatSecretFood
    let selectedDate: Date
    let mealType: MealType
    let onComplete: () -> Void
    let existingEntry: NutritionEntry?
    
    @State private var selectedServing: FatSecretFood.Serving?
    @State private var servingCount: Double
    @State private var selectedMealType: MealType
    @State private var detailedFood: FatSecretFood?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    init(food: FatSecretFood, 
         selectedDate: Date, 
         mealType: MealType, 
         initialServingCount: Double = 1.0,
         existingEntry: NutritionEntry? = nil,
         onComplete: @escaping () -> Void) {
        self.food = food
        self.selectedDate = selectedDate
        self.mealType = mealType
        self.onComplete = onComplete
        self.existingEntry = existingEntry
        _servingCount = State(initialValue: initialServingCount)
        _selectedMealType = State(initialValue: mealType)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                mealTypeSelection
                
                if let detailedFood = detailedFood {
                    if let servings = detailedFood.servings?.serving, !servings.isEmpty {
                        servingSizeSelection
                        servingCountSection
                        
                        if let serving = selectedServing {
                            NutritionSummary(serving: serving, servingCount: servingCount)
                        }
                        
                        AddToLogButton(
                            isEnabled: selectedServing != nil,
                            action: addFoodToLog
                        )
                    } else {
                        ContentMessageView(
                            message: "No serving information available",
                            color: .secondary
                        )
                    }
                }
            }
        }
        .navigationTitle(food.foodName)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .overlay {
            if isLoading {
                LoadingView()
            }
        }
        .alert("Error", isPresented: .constant(errorMessage != nil)) {
            Button("OK") { errorMessage = nil }
        } message: {
            if let error = errorMessage {
                Text(error)
            }
        }
        .task {
            await loadFoodDetails()
        }
    }
    
    private var mealTypeSelection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Select Meal")
            
            HStack(spacing: 8) {
                ForEach(MealType.allCases, id: \.self) { type in
                    MealTypeButton(
                        type: type,
                        isSelected: selectedMealType == type,
                        action: { selectedMealType = type }
                    )
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var servingSizeSelection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Serving Size")
            
            ServingSizeMenu(
                servings: detailedFood?.servings?.serving ?? [],
                selectedServing: $selectedServing
            )
        }
        .padding(.horizontal)
    }
    
    private var servingCountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Number of Servings")
            ServingCountStepper(servingCount: $servingCount)
        }
        .padding(.horizontal)
    }
    
    private func addFoodToLog() {
        do {
            try validateAndSave()
            onComplete()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func validateAndSave() throws {
        guard let serving = selectedServing else {
            throw FoodSearchError.failedToSaveEntry
        }
        
        guard servingCount >= Constants.minimumServingCount else {
            throw FoodSearchError.failedToSaveEntry
        }
        
        if let existingEntry = existingEntry {
            updateExistingEntry(existingEntry)
        } else {
            try createNewEntry(with: serving)
        }
    }
    
    private func updateExistingEntry(_ entry: NutritionEntry) {
        entry.servings = servingCount
        entry.mealType = selectedMealType
    }
    
    private func createNewEntry(with serving: FatSecretFood.Serving) throws {
        let foodItem = createFoodItem(with: serving)
        modelContext.insert(foodItem)
        
        let entry = createNutritionEntry(with: foodItem)
        modelContext.insert(entry)
        
        try addEntryToDailyLog(entry)
    }
    
    private func addEntryToDailyLog(_ entry: NutritionEntry) throws {
        let startOfDay = Calendar.current.startOfDay(for: selectedDate)
        let endOfDay = startOfDay.addingTimeInterval(86400)
        
        let descriptor = FetchDescriptor<DailyNutritionLog>(
            predicate: #Predicate<DailyNutritionLog> { log in
                log.date >= startOfDay && log.date < endOfDay
            }
        )
        
        if let dailyLog = try modelContext.fetch(descriptor).first {
            dailyLog.entries.append(entry)
        } else {
            let newLog = DailyNutritionLog(date: startOfDay)
            newLog.entries.append(entry)
            modelContext.insert(newLog)
        }
    }
    
    private func loadFoodDetails() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            detailedFood = try await FatSecretService.shared.getFoodDetails(id: food.food_id)
            if let firstServing = detailedFood?.servings?.serving.first {
                selectedServing = firstServing
            }
        } catch {
            errorMessage = "Unable to load food details: \(error.localizedDescription)"
        }
    }
    
    private func createFoodItem(with serving: FatSecretFood.Serving) -> FoodItem {
        FoodItem(
            name: food.foodName,
            brandName: food.brandName,
            servingSize: serving.servingDescription,
            servingSizeGrams: Double(serving.metric_serving_amount ?? "0") ?? 0,
            calories: serving.caloriesInt,
            protein: serving.proteinDouble,
            carbs: serving.carbsDouble,
            fat: serving.fatDouble,
            fatSecretId: food.foodId
        )
    }
    
    private func createNutritionEntry(with foodItem: FoodItem) -> NutritionEntry {
        NutritionEntry(
            foodItem: foodItem,
            servings: servingCount,
            date: selectedDate,
            mealType: selectedMealType
        )
    }
}

private struct FoodSearchResultRow: View {
    let food: FatSecretFood
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(food.foodName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .accessibilityLabel("Food name: \(food.foodName)")
                
                if let brand = food.brandName {
                    Text(brand)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .accessibilityLabel("Brand: \(brand)")
                }
            }
            
            Spacer()
            
            Circle()
                .fill(Color.black)
                .frame(width: 32, height: 32)
                .overlay(
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                )
                .accessibilityHidden(true)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(Color(.systemBackground))
                .shadow(
                    color: .black.opacity(Constants.shadowOpacity),
                    radius: Constants.shadowRadius
                )
        )
        .accessibilityElement(children: .combine)
        .accessibilityHint("Tap to view serving sizes and nutrition information")
    }
}

private struct NutritionInfoCard: View {
    let title: String
    let value: String
    let unit: String
    
    private var formattedValue: String {
        if title == "Calories" {
            return value
        }
        return String(format: "%.1f", Double(value) ?? 0)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(formattedValue)
                .font(.system(size: 20, weight: .semibold))
            
            Text(unit)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .cornerRadius(Constants.cornerRadius)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(formattedValue) \(unit)")
    }
}

private struct ContentMessageView: View {
    let message: String
    let color: Color
    
    var body: some View {
        VStack {
            Spacer()
            Text(message)
                .foregroundColor(color)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
    }
}

private struct LoadingView: View {
    var body: some View {
        SwiftUI.ProgressView()
            .scaleEffect(1.5)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.2))
    }
}

private struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.subheadline)
            .foregroundColor(.secondary)
    }
}

private struct MealTypeButton: View {
    let type: MealType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: type.icon)
                    .font(.system(size: 16))
                Text(type.rawValue)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color.black : Color(.systemGray6))
            .foregroundColor(isSelected ? .white : .black)
            .cornerRadius(12)
        }
    }
}

private struct ServingSizeMenu: View {
    let servings: [FatSecretFood.Serving]
    @Binding var selectedServing: FatSecretFood.Serving?
    
    var body: some View {
        Menu {
            ForEach(servings, id: \.serving_id) { serving in
                Button(serving.servingDescription) {
                    selectedServing = serving
                }
            }
        } label: {
            HStack {
                Text(selectedServing?.servingDescription ?? "Select serving size")
                    .foregroundColor(selectedServing == nil ? .secondary : .primary)
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
}

private struct ServingCountStepper: View {
    @Binding var servingCount: Double
    
    var body: some View {
        HStack(spacing: 16) {
            StepperButton(
                systemName: "minus",
                action: { if servingCount > 0.5 { servingCount -= 0.5 }}
            )
            
            ServingCountField(servingCount: $servingCount)
            
            StepperButton(
                systemName: "plus",
                action: { servingCount += 0.5 }
            )
        }
    }
}

private struct StepperButton: View {
    let systemName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .frame(width: 44, height: 44)
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
    }
}

private struct ServingCountField: View {
    @Binding var servingCount: Double
    
    var body: some View {
        TextField("1.0", value: $servingCount, format: .number.precision(.fractionLength(1)))
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.center)
            .frame(width: 80)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(Constants.cornerRadius)
            .shadow(
                color: .black.opacity(Constants.shadowOpacity),
                radius: Constants.shadowRadius
            )
            .accessibilityLabel("Serving count")
            .accessibilityValue(String(format: "%.1f servings", servingCount))
    }
}

private struct NutritionSummary: View {
    let serving: FatSecretFood.Serving
    let servingCount: Double
    
    var body: some View {
        VStack(spacing: 16) {
            SectionHeader(title: "Nutrition Information")
            
            HStack(spacing: 20) {
                NutritionInfoCard(
                    title: "Calories",
                    value: "\(Int(Double(serving.caloriesInt) * servingCount))",
                    unit: "kcal"
                )
                
                NutritionInfoCard(
                    title: "Protein",
                    value: String(format: "%.1f", serving.proteinDouble * servingCount),
                    unit: "g"
                )
                
                NutritionInfoCard(
                    title: "Carbs",
                    value: String(format: "%.1f", serving.carbsDouble * servingCount),
                    unit: "g"
                )
                
                NutritionInfoCard(
                    title: "Fat",
                    value: String(format: "%.1f", serving.fatDouble * servingCount),
                    unit: "g"
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
        .padding(.horizontal)
    }
}

private struct AddToLogButton: View {
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Add to Food Diary")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isEnabled ? Color.black : Color.gray)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        }
        .disabled(!isEnabled)
        .padding()
    }
}

// Styling constants
private enum Constants {
    static let cornerRadius: CGFloat = 12
    static let shadowRadius: CGFloat = 8
    static let shadowOpacity: CGFloat = 0.1
    static let minimumServingCount: Double = 0.5
    static let servingIncrement: Double = 0.5
    static let defaultServingCount: Double = 1.0
}

// Error handling
private enum FoodSearchError: LocalizedError {
    case failedToLoadDetails
    case failedToSaveEntry
    
    var errorDescription: String? {
        switch self {
        case .failedToLoadDetails:
            return "Unable to load food details. Please try again."
        case .failedToSaveEntry:
            return "Failed to save food entry. Please try again."
        }
    }
}
