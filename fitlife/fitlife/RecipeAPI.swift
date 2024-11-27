import SwiftUI
import Foundation

//–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// The RecipeObject: i.e All Relevant Recipe Information.
struct RecipeObject: Hashable, Codable{
    let label: String
    let image: String
    let url: String
    let shareAs: String
    let ingredientLines: [String]
    let yield: Double
    let calories: Double
    let totalNutrients: TotalNutrients
    
    // Nested struct for nutrients
    struct TotalNutrients: Codable, Hashable {
        let FAT: Nutrient
        let CHOCDF: Nutrient
        let FIBTG: Nutrient
        let PROCNT: Nutrient
        let SUGAR: Nutrient
        
        struct Nutrient: Codable, Hashable {
            let label: String
            let quantity: Double
            let unit: String
        }
    }
}

//–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// Struct for API Response
struct RecipeResponse: Codable{
    let hits: [Hit]
    
    struct Hit: Codable{
        let recipe: RecipeObject
    }
}

//–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
class ViewModel: ObservableObject {
    @Published var recipes: [RecipeObject] = [] // Array to hold fetched recipes
    
    func fetchData(query: String) {
        if let path = Bundle.main.path(forResource: "RecipeSearch", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
           let id = dict["app_id"] as? String,
           let key = dict["app_key"] as? String{
            
            // Ensure the query is URL-safe
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "
            
            // Construct the URL string with credentials
            let urlString = "https://api.edamam.com/api/recipes/v2?q=\(encodedQuery)&app_key=\(key)&_cont=CHcVQBtNNQphDmgVQntAEX4BYUt6AwAPSmBJAmEVY1FzAQYVX3cUC2YWMFJ6BldUFzBECmUaMl1zUAUEQzYRUmMXYAYlARFqX3cWQT1OcV9xBE4%3D&type=any&app_id=\(id)"
            
            
            //Validate the URL.
            guard let url = URL(string: urlString) else {
                print("Error: Invalid Link")  //changed String from from 'URL to 'Link' for improved user comprehension.
                return
            }
            
            //This creates the URL Session Data task.
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // Handle errors
                if let error = error {
                    print("\nError: \(error.localizedDescription)\n!")
                    return
                }
                
                // Check for Valid Data
                guard let validData = data else{
                    print("\nError: No data received.\n")
                    return
                }
                
                do{
                    let decodedResponse  = try JSONDecoder().decode(RecipeResponse.self, from: validData)
                    DispatchQueue.main.async{
                        self.recipes = decodedResponse.hits.map { $0.recipe }
                    }
                }catch{
                    print("Failed to decode JSON: \(error.localizedDescription)")
                    
                    // Pretty-print JSON for debugging purposes
                    if let jsonObject = try? JSONSerialization.jsonObject(with: validData, options: []),
                       let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                       let prettyPrintedString = String(data: prettyData, encoding: .utf8) {
                        print("Pretty JSON Response:\n\(prettyPrintedString)")
                    }
                    else {
                        print("Unable to format JSON.")
                    }
                    // Print out the raw response in case JSON couldn't be decoded
                    print(String(data: validData, encoding: .utf8) ?? "Unable to convert data to string for debugging.")
                }
            }
            task.resume()
        }
    }
}

//–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

struct SearchView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var searchText = ""
    @State private var isSearching = false
    
    var body: some View {
        NavigationView {
            ScrollView {  // Added ScrollView here
                VStack {
                    // Search bar
                    HStack {
                        TextField("Search recipes...", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                        
                        Button(action: {
                            if !searchText.isEmpty {
                                isSearching = true
                                viewModel.fetchData(query: searchText)
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    
                    // Results list
                    if isSearching {
                        if viewModel.recipes.isEmpty {
                            ProgressView()
                                .padding()
                        } else {
                            LazyVStack(spacing: 16) {  // Using LazyVStack for better performance
                                ForEach(viewModel.recipes, id: \.self) { recipe in
                                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                        RecipeCard(recipe: recipe)  // Extracted card view
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        // Initial state
                        VStack {
                            Image(systemName: "fork.knife.circle.fill")
                                .font(.system(size: 64))
                                .foregroundColor(.black)
                                .padding()
                            Text("Search for recipes")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                        .padding(.top, 40)
                    }
                }
            }
            .navigationTitle("Recipe Search")
            .background(Color(.systemBackground))
        }
    }
}

//–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// Extracted card view for better organization
struct RecipeCard: View {
    let recipe: RecipeObject
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
            AsyncImage(url: URL(string: recipe.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color(.systemGray6))
                    .overlay(
                        ProgressView()
                            .tint(.gray)
                    )
            }
            .frame(height: 200)
            .clipped()
            
            // Recipe Info
            VStack(alignment: .leading, spacing: 12) {
                // Recipe Name
                Text(recipe.label)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                
                // Stats bar
                HStack(spacing: 24) {
                    // Calories
                    HStack(spacing: 8) {
                        Image(systemName: "flame")
                            .foregroundColor(.orange)
                        Text("\(Int(recipe.calories))")
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                        Text("calories")
                            .foregroundColor(.gray)
                    }
                    
                    // Servings
                    HStack(spacing: 8) {
                        Image(systemName: "person.2")
                            .foregroundColor(.gray)
                        Text("\(Int(recipe.yield))")
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                        Text("servings")
                            .foregroundColor(.gray)
                    }
                }
                .font(.system(size: 15))
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .background(Color.white)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 2)
        .padding(.horizontal)
        .padding(.vertical, 6)
    }
}

//–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// Updated RecipeDetailView with improved scrolling
struct RecipeDetailView: View {
    @Environment(\.dismiss) var dismiss
    let recipe: RecipeObject
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                // Image
                ZStack(alignment: .topLeading) {
                    AsyncImage(url: URL(string: recipe.image)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 300)
                    .clipped()
                    
                    // Back button
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .padding(.top, 48)
                    .padding(.leading, 16)
                }
                
                // Title Section
                Text(recipe.label)
                    .font(.system(size: 32, weight: .bold))
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                
                // Content
                VStack(spacing: 24) {
                    // Stats Cards
                    HStack(spacing: 20) {
                        NutritionStatBox(icon: "flame.fill", value: "\(Int(recipe.calories))", label: "Calories", color: .orange)
                        NutritionStatBox(icon: "person.2.fill", value: "\(Int(recipe.yield))", label: "Servings", color: .blue)
                    }
                    
                    // Macros Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Nutrition Facts")
                            .font(.title2.bold())
                        
                        VStack(spacing: 12) {
                            MacroRow(name: "Fat", value: recipe.totalNutrients.FAT.quantity, unit: recipe.totalNutrients.FAT.unit, color: .yellow)
                            MacroRow(name: "Carbs", value: recipe.totalNutrients.CHOCDF.quantity, unit: recipe.totalNutrients.CHOCDF.unit, color: .orange)
                            MacroRow(name: "Protein", value: recipe.totalNutrients.PROCNT.quantity, unit: recipe.totalNutrients.PROCNT.unit, color: .red)
                            MacroRow(name: "Fiber", value: recipe.totalNutrients.FIBTG.quantity, unit: recipe.totalNutrients.FIBTG.unit, color: .green)
                            MacroRow(name: "Sugar", value: recipe.totalNutrients.SUGAR.quantity, unit: recipe.totalNutrients.SUGAR.unit, color: .purple)
                        }
                    }
                    
                    // Ingredients Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Ingredients")
                            .font(.title2.bold())
                        
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(recipe.ingredientLines, id: \.self) { ingredient in
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text(ingredient)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                            }
                        }
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // The preview environment in xCode doesn't fully support opening URLs.
                    Link(destination: URL(string: recipe.shareAs)!) {
                        HStack {
                            Text("View Full Recipe")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right.circle.fill")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                }
                .padding(20)
                .padding(.bottom, 100)
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

// Helper Views
struct NutritionStatBox: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            Text(value)
                .font(.title2.bold())
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

struct MacroRow: View {
    let name: String
    let value: Double
    let unit: String
    let color: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(name)
                .fontWeight(.medium)
            Spacer()
            Text("\(String(format: "%.1f", value))\(unit)")
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

//–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

#Preview {
    SearchView()
}


//–––––––––––––––––––––––––––––––––––––––––FIN–––––––––––––––––––––––––––––––––––––––––––––––
